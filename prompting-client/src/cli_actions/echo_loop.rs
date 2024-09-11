use crate::{
    daemon::{poll_for_prompts, PromptUpdate},
    recording::PromptRecording,
    snapd_client::{PromptId, SnapdSocketClient, TypedPrompt},
    Result,
};
use tokio::sync::mpsc::unbounded_channel;
use tracing::info;

/// A simple echo loop that prints out the prompts seen when polling for notices
pub async fn run_echo_loop(
    snapd_client: &mut SnapdSocketClient,
    path: Option<String>,
) -> Result<()> {
    let (tx_prompts, mut rx_prompts) = unbounded_channel();
    let mut rec = PromptRecording::new(path);

    info!("starting poll loop");
    tokio::spawn(poll_for_prompts(snapd_client.clone(), tx_prompts));

    loop {
        match rec.await_update_handling_ctrl_c(&mut rx_prompts).await {
            Some(PromptUpdate::Add(ep)) => match &ep.prompt {
                TypedPrompt::Home(p) if rec.is_prompt_for_writing_output(p) => {
                    return rec.allow_write(p.clone(), snapd_client).await;
                }

                p => {
                    println!("PROMPT: {}", serde_json::to_string(&ep)?);
                    rec.push_prompt(p);
                }
            },

            Some(PromptUpdate::Drop(PromptId(id))) => println!("PROMPT ACTIONED: {id}"),

            None => return Ok(()),
        }
    }
}
