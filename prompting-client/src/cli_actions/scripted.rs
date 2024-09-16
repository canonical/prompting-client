use crate::{
    daemon::{EnrichedPrompt, PollLoop, PromptUpdate},
    prompt_sequence::{MatchError, PromptFilter, PromptSequence},
    snapd_client::{
        interfaces::{
            home::{HomeConstraintsFilter, HomeInterface},
            SnapInterface,
        },
        Action, PromptId, SnapdSocketClient, TypedPrompt, TypedPromptReply,
    },
    Error, Result, SNAP_NAME,
};
use hyper::StatusCode;
use std::time::Duration;
use tokio::{select, sync::mpsc::unbounded_channel};
use tracing::{debug, error, info, warn};

/// Run a scripted client that actions prompts based on a predefined sequence of prompts that we
/// expect to see.
pub async fn run_scripted_client_loop(
    snapd_client: &mut SnapdSocketClient,
    path: String,
    vars: &[(&str, &str)],
    grace_period: Option<u64>,
) -> Result<()> {
    eprintln!("creating client");
    let mut scripted_client =
        ScriptedClient::try_new_allowing_script_read(path, vars, snapd_client.clone())?;
    let (tx_prompts, mut rx_prompts) = unbounded_channel();

    info!("starting poll loop");
    let mut poll_loop = PollLoop::new(snapd_client.clone(), tx_prompts);
    poll_loop.skip_outstanding_prompts();
    tokio::spawn(async move { poll_loop.run().await });

    info!(
        script=%scripted_client.path,
        n_prompts=%scripted_client.seq.len(),
        "running provided script"
    );

    while scripted_client.is_running() {
        match rx_prompts.recv().await {
            Some(PromptUpdate::Add(ep)) if scripted_client.should_handle(&ep) => {
                scripted_client.reply(ep, snapd_client).await?
            }
            Some(PromptUpdate::Add(ep)) => eprintln!("dropping prompt: {ep:?}"),
            Some(PromptUpdate::Drop(PromptId(id))) => warn!(%id, "drop for prompt id"),
            None => break,
        }
    }

    let grace_period = match grace_period {
        Some(n) => n,
        None => return Ok(()),
    };

    info!(seconds=%grace_period, "sequence complete, entering grace period");
    select! {
        _ = tokio::time::sleep(Duration::from_secs(grace_period)) => Ok(()),
        res = grace_period_deny_and_error(snapd_client) => res,
    }
}

/// Poll for outstanding prompts and auto-deny them before returning an error. This function will
/// loop until at least one un-actioned prompt is encountered.
async fn grace_period_deny_and_error(snapd_client: &mut SnapdSocketClient) -> Result<()> {
    loop {
        let ids = snapd_client.pending_prompt_ids().await?;
        let mut prompts = Vec::with_capacity(ids.len());

        for id in ids {
            let prompt = match snapd_client.prompt_details(&id).await {
                Ok(p) => p,
                Err(_) => continue,
            };

            snapd_client
                .reply_to_prompt(&id, prompt.clone().into_deny_once())
                .await?;

            prompts.push(prompt);
        }

        // It is possible that all of the prompts we saw a notice for were already actioned or
        // otherwise no longer available when we attempt to pull the details from snapd. We only
        // error if there was a non-zero number of unaction prompts.
        if !prompts.is_empty() {
            return Err(Error::FailedPromptSequence {
                error: MatchError::UnexpectedPrompts { prompts },
            });
        }
    }
}

#[derive(Debug)]
struct ScriptedClient {
    seq: PromptSequence,
    path: String,
}

impl ScriptedClient {
    fn try_new_allowing_script_read(
        path: String,
        vars: &[(&str, &str)],
        mut snapd_client: SnapdSocketClient,
    ) -> Result<Self> {
        // We need to spawn a task to wait for the read prompt we generate when reading in our
        // script file. We can't handle this in the main poll loop as we need to construct the
        // client up front.
        let mut filter = PromptFilter::default();
        let mut constraints = HomeConstraintsFilter::default();
        constraints
            .try_with_path(format!(".*{path}"))
            .expect("valid regex");
        filter
            .with_snap(SNAP_NAME)
            .with_interface("home")
            .with_constraints(constraints);

        eprintln!("script path: {path}");

        tokio::task::spawn(async move {
            loop {
                let pending = snapd_client.pending_prompt_ids().await.unwrap();
                for id in pending {
                    match snapd_client.prompt_details(&id).await {
                        Ok(TypedPrompt::Home(inner)) if filter.matches(&inner).is_success() => {
                            debug!("allowing read of script file");
                            let reply = HomeInterface::prompt_to_reply(inner, Action::Allow)
                                .for_timespan("10s") // Using a timespan so our rule auto-removes
                                .into();
                            snapd_client.reply_to_prompt(&id, reply).await.unwrap();
                            return;
                        }

                        _ => (),
                    };
                }
            }
        });

        let seq = PromptSequence::try_new_from_file(&path, vars)?;

        Ok(Self { seq, path })
    }

    fn should_handle(&self, ep: &EnrichedPrompt) -> bool {
        self.seq.should_handle(&ep.prompt)
    }

    async fn reply_for_prompt(
        &mut self,
        prompt: TypedPrompt,
        prev_error: Option<String>,
    ) -> Result<TypedPromptReply> {
        if let Some(error) = prev_error {
            return Err(Error::FailedPromptSequence {
                error: MatchError::UnexpectedError { error },
            });
        }

        match prompt {
            TypedPrompt::Home(inner) if inner.constraints.path == self.path => {
                Ok(TypedPromptReply::Home(
                    // Using a timespan so our rule auto-removes
                    HomeInterface::prompt_to_reply(inner, Action::Allow).for_timespan("10s"),
                ))
            }

            _ => match self.seq.try_match_next(prompt) {
                Ok(reply) => Ok(reply),
                Err(error) => Err(Error::FailedPromptSequence { error }),
            },
        }
    }

    fn is_running(&self) -> bool {
        !self.seq.is_empty()
    }

    async fn reply(
        &mut self,
        EnrichedPrompt { prompt, .. }: EnrichedPrompt,
        snapd_client: &mut SnapdSocketClient,
    ) -> Result<()> {
        let mut reply = self.reply_for_prompt(prompt.clone(), None).await?;
        let id = prompt.id().clone();

        debug!(id=%id.0, ?reply, "replying to prompt");

        while let Err(e) = snapd_client.reply_to_prompt(&id, reply).await {
            let prev_error = match e {
                Error::SnapdError { status, .. } if status == StatusCode::NOT_FOUND => {
                    warn!(?id, "prompt has already been actioned");
                    return Ok(());
                }

                Error::SnapdError { message, .. } => message,

                _ => {
                    error!(%e, "unexpected error in replying to prompt");
                    return Err(e);
                }
            };

            debug!(%prev_error, "error returned from snapd, retrying");
            reply = self
                .reply_for_prompt(prompt.clone(), Some(prev_error))
                .await?;

            debug!(id=%id.0, ?reply, "replying to prompt");
        }

        Ok(())
    }
}
