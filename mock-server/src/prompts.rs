use serde_json::Value;
use std::{collections::HashMap, fs};

pub struct Prompts;

impl Prompts {
    pub fn read_initial_state(path: &str) -> HashMap<u64, Value> {
        let mut results = HashMap::new();

        if let Ok(entries) = fs::read_dir(path) {
            for entry in entries.flatten() {
                let path = entry.path();

                if path.is_file() && path.extension().and_then(|s| s.to_str()) == Some("json") {
                    if let Ok(content) = fs::read_to_string(&path) {
                        if let Ok(value) = serde_json::from_str::<Value>(&content) {
                            let id = value
                                .get("id")
                                .and_then(|v| v.as_str())
                                .and_then(|s| s.parse::<u64>().ok())
                                .unwrap_or(0);

                            results.insert(id, value);
                        }
                    }
                }
            }
        }

        results
    }
}
