use anyhow::Result;
use tokio::{fs, net::UnixListener};

pub struct Socket;

impl Socket {
    pub async fn create(path: &str) -> Result<UnixListener> {
        if fs::try_exists(path).await? {
            fs::remove_file(path).await?;
        }

        let listener = UnixListener::bind(path)?;

        Ok(listener)
    }
}
