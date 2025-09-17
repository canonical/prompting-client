use std::env;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let current_dir = env::current_dir()?;

    println!("Current directory: {current_dir:?}");

    std::fs::create_dir_all("./src/protos")?;

    let files = &["../protos/apparmor-prompting.proto"];
    let include_dirs = &["../protos"];

    tonic_build::configure()
        .build_server(true)
        .build_client(true)
        .out_dir("./src/protos")
        .protoc_arg("--experimental_allow_proto3_optional")
        .compile_protos(files, include_dirs)?;

    Ok(())
}
