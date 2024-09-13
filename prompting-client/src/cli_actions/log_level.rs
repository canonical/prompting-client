use crate::{
    protos::apparmor_prompting::app_armor_prompting_client::AppArmorPromptingClient, Error, Result,
    SOCKET_ENV_VAR,
};
use hyper_util::rt::TokioIo;
use std::env;
use std::io;
use tokio::net::UnixStream;
use tonic::transport::{Channel, Endpoint, Uri};
use tower::service_fn;

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

    // See https://github.com/hyperium/tonic/blob/master/examples/src/uds/client.rs
    let channel = Endpoint::from_static("https://not-used.com")
        .connect_with_connector(service_fn(move |_: Uri| {
            let path = path.clone();
            async { Ok::<_, io::Error>(TokioIo::new(UnixStream::connect(path).await?)) }
        }))
        .await
        .unwrap();

    AppArmorPromptingClient::new(channel)
}
