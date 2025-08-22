use chrono::Utc;
use serde_json::{Value, json};
use std::{collections::HashMap, fs};

pub struct Prompts;

impl Prompts {
    pub fn read_initial_state(path: &str) -> HashMap<String, Value> {
        let mut results = HashMap::new();

        if let Ok(entries) = fs::read_dir(path) {
            for entry in entries.flatten() {
                let path = entry.path();

                if path.is_file() && path.extension().and_then(|s| s.to_str()) == Some("json") {
                    if let Ok(content) = fs::read_to_string(&path) {
                        if let Ok(value) = serde_json::from_str::<Value>(&content) {
                            let id = value.get("id").and_then(|v| v.as_str()).unwrap();

                            results.insert(id.to_string(), value);
                        }
                    }
                }
            }
        }

        results
    }

    pub fn make_notice(id: u64, key: &str) -> Value {
        let timestamp = Utc::now().format("%Y-%m-%dT%H:%M:%S.%fZ");

        json!([{
            "id": id.to_string(),
            "user-id": 1000,
            "type": "interfaces-requests-prompt",
            "key": key,
            "first-occurred": timestamp.to_string(),
            "last-occurred": timestamp.to_string(),
            "last-repeated": timestamp.to_string(),
            "occurrences": 1,
            "expire-after": "168h0m0s"
        }])
    }
}
