use crate::{
    protos::apparmor_prompting::app_armor_prompting_client::AppArmorPromptingClient, Error, Result,
    SOCKET_ENV_VAR,
};
use std::env;
use tonic::transport::Channel;

pub async fn set_logging_filter(filter: String) -> Result<String> {
    let mut client = client_from_env().await;

    match client.set_logging_filter(filter).await {
        Ok(resp) => Ok(resp.into_inner().current),
        Err(e) => Err(Error::UnableToUpdateLogFilter {
            reason: e.to_string(),
        }),
    }
}

async fn client_from_env() -> AppArmorPromptingClient<Channel> {
    let path = env::var(SOCKET_ENV_VAR).expect("socket env var not set");
    AppArmorPromptingClient::connect(format!("unix://{path}"))
        .await
        .unwrap()
}
