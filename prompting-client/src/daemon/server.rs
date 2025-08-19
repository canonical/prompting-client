//! The GRPC server that handles incoming connections from client UIs.
use crate::{
    daemon::{worker::RefActivePrompt, ActionedPrompt, ReplyToPrompt},
    log_filter,
    protos::{
        apparmor_prompting::{HomePermission, PromptReply, SetLoggingFilterResponse},
        AppArmorPrompting, AppArmorPromptingServer, GetCurrentPromptResponse, PromptReplyResponse,
        ResolveHomePatternTypeResponse,
    },
    snapd_client::{PromptId, SnapdError, TypedPromptReply},
    Error,
};
use std::sync::Arc;
use tokio::{
    net::UnixListener,
    sync::mpsc::{channel, UnboundedSender},
};
use tokio_stream::wrappers::ReceiverStream;
use tonic::{async_trait, Code, Request, Response, Status};
use tracing::{debug, error, info, warn};
use tracing_subscriber::{reload::Handle, EnvFilter};

pub fn new_server_and_listener<R, S>(
    client: R,
    reload_handle: S,
    active_prompt: RefActivePrompt,
    tx_actioned_prompts: UnboundedSender<ActionedPrompt>,
    socket_path: String,
) -> (AppArmorPromptingServer<Service<R, S>>, UnixListener)
where
    R: ReplyToPrompt + Clone,
    S: SetLogFilter,
{
    let service = Service::new(
        client.clone(),
        reload_handle,
        active_prompt,
        tx_actioned_prompts,
    );
    let listener = UnixListener::bind(&socket_path).expect("to be able to bind to our socket");

    (AppArmorPromptingServer::new(service), listener)
}

pub trait SetLogFilter: Send + Sync + 'static {
    fn set_filter(&self, filter: &str) -> crate::Result<()>;
}

impl<L, S> SetLogFilter for Arc<Handle<L, S>>
where
    L: From<EnvFilter> + Send + Sync + 'static,
    S: 'static,
{
    fn set_filter(&self, filter: &str) -> crate::Result<()> {
        info!(?filter, "attempting to update logging filter");
        let f = filter
            .parse::<EnvFilter>()
            .map_err(|_| Error::UnableToUpdateLogFilter {
                reason: format!("{filter:?} is not a valid logging filter"),
            })?;

        self.reload(f).map_err(|e| Error::UnableToUpdateLogFilter {
            reason: format!("failed to set logging filter: {e}"),
        })?;

        Ok(())
    }
}

pub struct Service<R, S>
where
    R: ReplyToPrompt,
    S: SetLogFilter,
{
    client: R,
    reload_handle: S,
    active_prompt: RefActivePrompt,
    tx_actioned_prompts: UnboundedSender<ActionedPrompt>,
}

impl<R, S> Service<R, S>
where
    R: ReplyToPrompt,
    S: SetLogFilter,
{
    pub fn new(
        client: R,
        reload_handle: S,
        active_prompt: RefActivePrompt,
        tx_actioned_prompts: UnboundedSender<ActionedPrompt>,
    ) -> Self {
        Self {
            client,
            reload_handle,
            active_prompt,
            tx_actioned_prompts,
        }
    }

    async fn update_worker(&self, actioned_prompt: ActionedPrompt) {
        if let Err(e) = self.tx_actioned_prompts.send(actioned_prompt) {
            panic!("send on closed tx_actioned_prompts channel: {e}");
        }
    }
}

#[async_trait]
impl<R, S> AppArmorPrompting for Service<R, S>
where
    R: ReplyToPrompt,
    S: SetLogFilter,
{
    type GetCurrentPromptStream = ReceiverStream<Result<GetCurrentPromptResponse, Status>>;
    async fn get_current_prompt(
        &self,
        _request: Request<()>,
    ) -> Result<Response<Self::GetCurrentPromptStream>, Status> {
        let (tx, rx) = channel(1);

        let prompt = match self.active_prompt.get() {
            Some(p) => {
                let id = &p.id().0;
                debug!(%id, "serving request for active prompt (id={id})");

                Some(p.try_into()?)
            }

            None => {
                warn!("got request for current prompt but there is no active prompt");
                return Err(Status::internal("active prompt not found"));
            }
        };

        match self.active_prompt.get_context() {
            Some(mut ctx) => {
                tokio::spawn(async move {
                    debug!("spawning stream");
                    if let Err(e) = tx.send(Ok(GetCurrentPromptResponse { prompt })).await {
                        error!("could not send prompt: {}", e);
                    }
                    ctx.done().await;
                    debug!("closing stream");
                });
            }
            None => {
                warn!("got request for current prompt but there is no context");
                return Err(Status::internal("context not found"));
            }
        };

        Ok(Response::new(ReceiverStream::new(rx)))
    }

    async fn reply_to_prompt(
        &self,
        request: Request<PromptReply>,
    ) -> Result<Response<PromptReplyResponse>, Status> {
        use crate::protos::apparmor_prompting::prompt_reply_response::{
            HomeRuleConflict, HomeRuleConflicts, InvalidHomePermissions, InvalidPathPattern,
            ParseError, PromptReplyType, UnsupportedValue,
        };

        let req = request.into_inner();
        let id = PromptId(req.prompt_id.clone());
        let reply: TypedPromptReply = req.try_into()?;

        debug!(id=%id.0, "replying to prompt id={}", id.0);
        let resp = match self.client.reply(&id, reply).await {
            Ok(others) => {
                self.update_worker(ActionedPrompt::Actioned { id, others })
                    .await;

                PromptReplyResponse {
                    message: "success".to_string(),
                    prompt_reply_type: Some(PromptReplyType::Success(())),
                }
            }

            Err(Error::SnapdError { message, err, .. }) => {
                let data = match *err {
                    SnapdError::Raw => PromptReplyType::Raw(()),

                    SnapdError::RuleNotFound => PromptReplyType::RuleNotFound(()),

                    SnapdError::PromptNotFound => {
                        warn!(id=%id.0, "prompt not found (id={})", id.0);
                        self.update_worker(ActionedPrompt::NotFound { id }).await;
                        PromptReplyType::PromptNotFound(())
                    }

                    SnapdError::RuleConflicts { conflicts } => {
                        PromptReplyType::RuleConflicts(HomeRuleConflicts {
                            conflicts: conflicts
                                .into_iter()
                                .map(|c| {
                                    Ok(HomeRuleConflict {
                                        permission: map_permission(&c.permission)?,
                                        variant: c.variant,
                                        conflicting_id: c.conflicting_id,
                                    })
                                })
                                .collect::<Result<Vec<_>, Status>>()?,
                        })
                    }

                    SnapdError::InvalidPathPattern { requested, replied } => {
                        PromptReplyType::InvalidPathPattern(InvalidPathPattern {
                            requested,
                            replied,
                        })
                    }

                    SnapdError::InvalidPermissions { requested, replied } => {
                        PromptReplyType::InvalidPermissions(InvalidHomePermissions {
                            requested: map_permissions(requested)?,
                            replied: map_permissions(replied)?,
                        })
                    }

                    SnapdError::ParseError { field, value } => {
                        PromptReplyType::ParseError(ParseError {
                            field: field.to_string(),
                            value,
                        })
                    }

                    SnapdError::UnsupportedValue {
                        field,
                        supported,
                        provided,
                    } => PromptReplyType::UnsupportedValue(UnsupportedValue {
                        field: field.to_string(),
                        supported,
                        provided,
                    }),
                };

                PromptReplyResponse {
                    message,
                    prompt_reply_type: Some(data),
                }
            }

            Err(e) => {
                warn!(id=%id.0, "unknown error from snapd when replying to prompt (id={}): {e}", id.0);
                PromptReplyResponse {
                    message: e.to_string(),
                    prompt_reply_type: Some(PromptReplyType::Raw(())),
                }
            }
        };

        Ok(Response::new(resp))
    }

    async fn resolve_home_pattern_type(
        &self,
        _: Request<String>,
    ) -> Result<Response<ResolveHomePatternTypeResponse>, Status> {
        // FIXME: finish this endpoint
        Err(Status::new(
            Code::Unimplemented,
            "this endpoint is not yet implemented",
        ))
    }

    async fn set_logging_filter(
        &self,
        filter: Request<String>,
    ) -> Result<Response<SetLoggingFilterResponse>, Status> {
        let current = log_filter(&filter.into_inner());

        match self.reload_handle.set_filter(&current) {
            Ok(_) => Ok(Response::new(SetLoggingFilterResponse { current })),
            Err(e) => Err(Status::new(
                Code::InvalidArgument,
                format!("unable to set logging level: {e}"),
            )),
        }
    }
}

fn map_permission(perm: &str) -> Result<i32, Status> {
    match perm {
        "read" => Ok(HomePermission::Read as i32),
        "write" => Ok(HomePermission::Write as i32),
        "execute" => Ok(HomePermission::Execute as i32),
        _ => Err(Status::internal(format!(
            "invalid permission for home interface: {perm}"
        ))),
    }
}

fn map_permissions(perms: Vec<String>) -> Result<Vec<i32>, Status> {
    perms.iter().map(|s| map_permission(s)).collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        daemon::{
            worker::{ActivePrompt, RefActivePrompt},
            EnrichedPrompt,
        },
        protos::apparmor_prompting::{
            self,
            app_armor_prompting_client::AppArmorPromptingClient,
            enriched_path_kind::Kind,
            get_current_prompt_response::Prompt,
            prompt_reply::{self, PromptReply::HomePromptReply},
            prompt_reply_response::PromptReplyType,
            Action, EnrichedPathKind as ProtoEnrichedPathKind, HomeDir, HomePrompt, Lifespan,
            MetaData,
        },
        snapd_client::{
            self,
            interfaces::home::{
                EnrichedPathKind, HomeConstraints, HomeInterface, HomeReplyConstraints,
                HomeUiInputData,
            },
            Prompt as SnapPrompt, PromptId, PromptReply as SnapPromptReply, SnapMeta, TypedPrompt,
            TypedPromptReply, TypedUiInput, UiInput,
        },
        Error,
    };
    use simple_test_case::test_case;
    use std::{
        fs, io,
        ops::{Deref, DerefMut},
    };
    use tokio::sync::mpsc::{unbounded_channel, UnboundedSender};
    use tokio_context::context::Context;
    use tokio_stream::wrappers::UnixListenerStream;
    use tonic::{
        async_trait,
        transport::{Channel, Server},
        Request,
    };
    use uuid::Uuid;

    #[derive(Debug, Clone)]
    struct MockClient {
        want_err: bool,
        expected_reply: Option<TypedPromptReply>,
    }

    #[async_trait]
    impl ReplyToPrompt for MockClient {
        async fn reply(
            &self,
            _id: &PromptId,
            reply: TypedPromptReply,
        ) -> crate::Result<Vec<PromptId>> {
            if self.want_err {
                return Err(Error::Io(io::Error::other(
                    "error requested of mock snapd client",
                )));
            }
            if let Some(expected_reply) = self.expected_reply.clone() {
                match (reply, expected_reply) {
                    (TypedPromptReply::Home(reply), TypedPromptReply::Home(expected_reply)) => {
                        assert_eq!(reply, expected_reply, "Replies did not match");
                    }
                }
            }

            Ok(Vec::new())
        }
    }

    // Ensure that our test sockets get cleaned up when the client is dropped
    #[derive(Debug)]
    struct SelfCleaningClient {
        inner: AppArmorPromptingClient<Channel>,
        socket_path: String,
    }

    impl Drop for SelfCleaningClient {
        fn drop(&mut self) {
            let _ = fs::remove_file(&self.socket_path);
        }
    }

    impl Deref for SelfCleaningClient {
        type Target = AppArmorPromptingClient<Channel>;

        fn deref(&self) -> &Self::Target {
            &self.inner
        }
    }

    impl DerefMut for SelfCleaningClient {
        fn deref_mut(&mut self) -> &mut Self::Target {
            &mut self.inner
        }
    }

    struct MockReloadHandle;
    impl SetLogFilter for MockReloadHandle {
        fn set_filter(&self, level: &str) -> crate::Result<()> {
            panic!("attempt to set log level to {level}");
        }
    }

    async fn setup_server_and_client(
        mock_client: MockClient,
        active_prompt: RefActivePrompt,
        tx_actioned_prompts: UnboundedSender<ActionedPrompt>,
    ) -> SelfCleaningClient {
        let test_name = Uuid::new_v4().to_string();
        let socket_path = format!("/tmp/{test_name}_socket");
        let _ = fs::remove_file(&socket_path); // Remove the old socket file if it exists

        let (server, listener) = new_server_and_listener(
            mock_client,
            MockReloadHandle,
            active_prompt,
            tx_actioned_prompts,
            socket_path.clone(),
        );

        tokio::spawn(async move {
            Server::builder()
                .add_service(server)
                .serve_with_incoming(UnixListenerStream::new(listener))
                .await
                .unwrap();
        });

        let path = socket_path.clone();
        let inner = AppArmorPromptingClient::connect(format!("unix://{path}"))
            .await
            .unwrap();
        SelfCleaningClient { inner, socket_path }
    }

    fn active_prompt() -> ActivePrompt {
        let (_, ui_handle) = Context::new();
        ActivePrompt {
            typed_ui_input: ui_input(),
            enriched_prompt: enriched_prompt(),
            ui_handle: Some(ui_handle),
        }
    }

    fn enriched_prompt() -> EnrichedPrompt {
        EnrichedPrompt {
            prompt: TypedPrompt::Home(SnapPrompt {
                id: PromptId("1".to_string()),
                timestamp: "0".to_string(),
                snap: "2".to_string(),
                pid: 1234,
                interface: "home".to_string(),
                constraints: HomeConstraints {
                    path: "6".to_string(),
                    requested_permissions: Vec::new(),
                    available_permissions: Vec::new(),
                },
            }),
            meta: Some(SnapMeta {
                name: "2".to_string(),
                updated_at: "3".to_string(),
                store_url: "4".to_string(),
                publisher: "5".to_string(),
            }),
        }
    }

    fn ui_input() -> TypedUiInput {
        TypedUiInput::Home(UiInput::<HomeInterface> {
            id: PromptId("1".to_string()),
            meta: SnapMeta {
                name: "2".to_string(),
                updated_at: "3".to_string(),
                store_url: "4".to_string(),
                publisher: "5".to_string(),
            },
            data: HomeUiInputData {
                requested_path: "6".to_string(),
                home_dir: "7".to_string(),
                requested_permissions: Vec::new(),
                available_permissions: Vec::new(),
                suggested_permissions: Vec::new(),
                pattern_options: Vec::new(),
                initial_pattern_option: 0,
                enriched_path_kind: EnrichedPathKind::HomeDir,
            },
        })
    }

    fn prompt() -> Prompt {
        Prompt::HomePrompt(HomePrompt {
            meta_data: Some(MetaData {
                prompt_id: "1".to_string(),
                snap_name: "2".to_string(),
                store_url: "4".to_string(),
                publisher: "5".to_string(),
                updated_at: "3".to_string(),
            }),
            requested_path: "6".to_string(),
            home_dir: "7".to_string(),
            requested_permissions: Vec::new(),
            available_permissions: Vec::new(),
            suggested_permissions: Vec::new(),
            pattern_options: Vec::new(),
            initial_pattern_option: 0,
            enriched_path_kind: Some(ProtoEnrichedPathKind {
                kind: Some(Kind::HomeDir(HomeDir {})),
            }),
        })
    }

    fn prompt_reply(prompt_reply_inner: Option<prompt_reply::PromptReply>) -> PromptReply {
        PromptReply {
            prompt_id: "1".to_string(),
            action: Action::Allow as i32,
            lifespan: Lifespan::Single as i32,
            prompt_reply: prompt_reply_inner,
        }
    }

    fn prompt_reply_inner() -> Option<prompt_reply::PromptReply> {
        Some(HomePromptReply(apparmor_prompting::HomePromptReply {
            path_pattern: "6".to_string(),
            permissions: Vec::new(),
        }))
    }

    fn typed_prompt_reply() -> TypedPromptReply {
        TypedPromptReply::Home(SnapPromptReply::<HomeInterface> {
            action: snapd_client::Action::Allow,
            lifespan: snapd_client::Lifespan::Single,
            duration: None,
            constraints: HomeReplyConstraints {
                path_pattern: "6".to_string(),
                permissions: Vec::new(),
                available_permissions: Vec::new(),
            },
        })
    }

    struct ExpectedErrors {
        snapd_err: bool,
        tx_err: bool,
        want_err: bool,
    }

    #[test_case(None, None; "empty prompt")]
    #[test_case(Some(active_prompt()), Some(prompt()); "non-empty prompt")]
    #[tokio::test]
    async fn test_get_current_prompt(
        active_prompt: Option<ActivePrompt>,
        expected: Option<Prompt>,
    ) {
        let mock_client = MockClient {
            want_err: false,
            expected_reply: None,
        };
        let (tx_actioned_prompts, _rx_actioned_prompts) = unbounded_channel();
        let mut active_prompt = RefActivePrompt::new(active_prompt);
        let mut client =
            setup_server_and_client(mock_client, active_prompt.clone(), tx_actioned_prompts).await;

        let mut stream = client
            .get_current_prompt(Request::new(()))
            .await
            .unwrap()
            .into_inner();

        let resp = stream
            .message()
            .await
            .unwrap()
            .and_then(|response| response.prompt);

        assert_eq!(resp, expected);

        if expected.is_some() {
            active_prompt.drop();
        }
        let next = stream.message().await.unwrap();
        assert_eq!(next, None);
    }

    #[test_case(prompt_reply(None), ExpectedErrors{snapd_err: false, tx_err: false, want_err: true}; "Error when map_prompt_reply fails")]
    #[test_case(prompt_reply(prompt_reply_inner()), ExpectedErrors{snapd_err: true, tx_err: false, want_err: false}; "Returns unknown error code when snapd returns an error")]
    #[test_case(prompt_reply(prompt_reply_inner()), ExpectedErrors{snapd_err: false, tx_err: true, want_err: true}; "Error when returning actioned prompts returns an error")]
    #[test_case(prompt_reply(prompt_reply_inner()), ExpectedErrors{snapd_err: false, tx_err: false, want_err: false}; "Succesfully reply to a prompt")]
    #[tokio::test]
    async fn test_reply_to_prompt(prompt_reply: PromptReply, expected_errors: ExpectedErrors) {
        let mock_client = MockClient {
            want_err: expected_errors.snapd_err,
            expected_reply: Some(typed_prompt_reply()),
        };
        let (tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();
        let mut rx_actioned_prompts = Some(rx_actioned_prompts);
        if expected_errors.tx_err {
            rx_actioned_prompts = None;
        }
        let active_prompt = RefActivePrompt::new(None);
        let mut client =
            setup_server_and_client(mock_client, active_prompt, tx_actioned_prompts).await;

        let resp = client.reply_to_prompt(Request::new(prompt_reply)).await;

        if expected_errors.want_err {
            assert!(resp.is_err());
            return;
        }

        let is_success = matches!(
            resp.unwrap().into_inner().prompt_reply_type.unwrap(),
            PromptReplyType::Success(())
        );

        if expected_errors.snapd_err {
            assert!(!is_success);
        } else {
            assert!(is_success);
            if let Some(mut rx) = rx_actioned_prompts {
                match rx.recv().await {
                    Some(ActionedPrompt::Actioned { id, .. }) => assert_eq!(id.0, "1".to_string()),
                    res => panic!("expected actioned prompt, got {res:?}"),
                }
            }
        }
    }
}
