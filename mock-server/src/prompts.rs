use chrono::Utc;
use serde_json::{Value, json};
use std::{collections::HashMap, fs};

pub struct Prompts;

impl Prompts {
    pub fn read_initial_state(path: &str) -> HashMap<String, Value> {
        let mut id = 0;
        let mut results = HashMap::new();

        if let Ok(entries) = fs::read_dir(path) {
            for entry in entries.flatten() {
                let path = entry.path();
                if !path.is_file() || path.extension().and_then(|s| s.to_str()) != Some("json") {
                    continue;
                }

                if let Ok(content) = fs::read_to_string(&path) {
                    if let Ok(mut value) = serde_json::from_str::<Value>(&content) {
                        id += 1;

                        let key = format!("{id:016x}");
                        value["id"] = json!(key);

                        results.insert(key, value);
                    }
                }
            }
        }

        results
    }

    pub fn make_notice(id: u64, key: &str) -> Value {
        let timestamp = Self::timestamp();

        json!([{
            "id": id.to_string(),
            "user-id": 1000,
            "type": "interfaces-requests-prompt",
            "key": key,
            "first-occurred": timestamp,
            "last-occurred": timestamp,
            "last-repeated": timestamp,
            "occurrences": 1,
            "expire-after": "168h0m0s"
        }])
    }

    pub fn timestamp() -> String {
        Utc::now().format("%Y-%m-%dT%H:%M:%S.%fZ").to_string()
    }
}
