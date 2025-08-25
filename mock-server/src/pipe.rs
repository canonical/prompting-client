use anyhow::{Result, bail};
use std::ffi::CString;
use tokio::{fs, fs::File};

pub struct Pipe;

impl Pipe {
    pub async fn create(path: &str) -> Result<File> {
        if !fs::try_exists(path).await? {
            let c_path = CString::new(path)?;
            let res = unsafe { libc::mkfifo(c_path.as_ptr(), libc::S_IWUSR | libc::S_IRUSR) };
            if res != 0 {
                bail!("Failed to create FIFO")
            }
        }

        let file = File::open(path).await?;

        Ok(file)
    }
}
