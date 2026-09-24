use anyhow::{Result, bail};
use std::ffi::CString;
use tokio::{fs, fs::File};

pub struct Pipe;

impl Pipe {
    pub async fn create(path: &str) -> Result<File> {
        if !fs::try_exists(path).await? {
            make_fifo(path)?
        }

        let file = File::open(path).await?;

        Ok(file)
    }
}

fn make_fifo(path: &str) -> Result<()> {
    let c_path = CString::new(path)?;
    // SAFETY: c_path.as_ptr() is a valid, null-terminated C string for mkfifo.
    match unsafe { libc::mkfifo(c_path.as_ptr(), libc::S_IWUSR | libc::S_IRUSR) } {
        0 => Ok(()),
        _ => bail!("Failed to create FIFO"),
    }
}
