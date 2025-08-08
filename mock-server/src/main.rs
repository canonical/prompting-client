use axum::{Router, routing::get};

use tokio::{
    fs::File,
    io::{AsyncBufReadExt, BufReader},
    net::UnixListener,
    sync::{
        Mutex,
        mpsc::{self, UnboundedReceiver},
    },
};

use std::sync::Arc;

use anyhow::Result;
struct AppState {
    rx: UnboundedReceiver<String>,
}

#[tokio::main]
async fn main() -> Result<()> {
    let (tx, rx) = mpsc::unbounded_channel::<String>();

    let data = Arc::new(Mutex::new(AppState { rx }));

    let app = Router::new().route(
        "/",
        get({
            let rr = data.clone();

            move || receiver(rr)
        }),
    );

    // todo: delete socket file

    let listener = UnixListener::bind("mock.sock").unwrap();

    tokio::spawn(async move {
        let file = File::open("mypipe").await?;
        let reader = BufReader::new(file);
        let mut lines = reader.lines();

        while let Ok(Some(line)) = lines.next_line().await {
            tx.send(line)?;
        }

        anyhow::Ok(())
    });

    axum::serve(listener, app).await.unwrap();

    Ok(())
}

async fn receiver(data: Arc<Mutex<AppState>>) -> String {
    let mut lock = data.lock().await;
    let string = lock.rx.recv().await.unwrap();

    println!("{string}");

    string
}
