//! Parsing of snapd API responses
use crate::{socket_client::body_json, Error, Result};
use hyper::{body::Incoming, Response};
use serde::{
    de::{self, DeserializeOwned, Deserializer},
    Deserialize, Serialize,
};
use serde_json::Value;
use tracing::error;

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
pub enum SnapdError {
    Raw,
    PromptNotFound,
    RuleNotFound,
    RuleConflict {
        conflicts: Vec<RuleConflict>,
    },
    InvalidReplyPermissions {
        requested: Vec<String>,
        replied: Vec<String>,
    },
    InvalidPathPattern {
        requested: String,
        replied: String,
    },
    MalformedFieldScalar {
        reason: String,
        field: &'static str,
        value: String,
    },
    MalformedFieldVector {
        reason: String,
        field: &'static str,
        value: Vec<String>,
        supported: Vec<String>,
    },
    UnsupportedValue {
        field: String,
        supported: Vec<String>,
        provided: Vec<String>,
    },
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct RuleConflict {
    permission: String,
    variant: String,
    conflicting_id: String,
}

/// Parse a raw response body from snapd into our internal Result type
pub async fn parse_response<T>(res: Response<Incoming>) -> Result<T>
where
    T: DeserializeOwned,
{
    let status = res.status();
    let resp: SnapdResponse<T> = body_json(res).await?;

    resp.result.map_err(|(message, err)| Error::SnapdError {
        status,
        message,
        err: Box::new(err),
    })
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(rename_all = "kebab-case")]
struct SnapdResponse<T> {
    #[serde(rename = "type")]
    ty: String,
    status_code: u16,
    status: String,
    result: std::result::Result<T, (String, SnapdError)>,
}

impl<'de, T> Deserialize<'de> for SnapdResponse<T>
where
    T: DeserializeOwned,
{
    fn deserialize<D>(deserializer: D) -> std::result::Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        #[derive(Debug, Deserialize)]
        #[serde(rename_all = "kebab-case")]
        struct RawResponse {
            #[serde(rename = "type")]
            ty: String,
            status_code: u16,
            status: String,
            result: serde_json::Value,
        }

        let RawResponse {
            ty,
            status_code,
            status,
            result,
        } = RawResponse::deserialize(deserializer)?;

        if ty != "error" {
            let result = T::deserialize(result).map_err(de::Error::custom)?;
            return Ok(SnapdResponse {
                ty,
                status_code,
                status,
                result: Ok(result),
            });
        }

        #[derive(Debug, Deserialize)]
        enum ErrorKind {
            #[serde(rename = "interfaces-requests-invalid-fields")]
            InvalidFields,
            #[serde(rename = "interfaces-requests-prompt-not-found")]
            PromptNotFound,
            #[serde(rename = "interfaces-requests-reply-not-match-request")]
            ReplyNotMatchRequest,
            #[serde(rename = "interfaces-requests-rule-conflict")]
            RuleConflict,
            #[serde(rename = "interfaces-requests-rule-not-found")]
            RuleNotFound,
        }

        #[derive(Debug, Deserialize)]
        struct RawError {
            message: String,
            kind: Option<ErrorKind>,
            value: Option<serde_json::Value>,
        }

        let RawError {
            message,
            kind,
            value,
        } = RawError::deserialize(result).map_err(de::Error::custom)?;

        match (kind, value) {
            (Some(ErrorKind::PromptNotFound), None) => Ok(SnapdResponse {
                ty,
                status_code,
                status,
                result: Err((message, SnapdError::PromptNotFound)),
            }),

            (Some(ErrorKind::RuleNotFound), None) => Ok(SnapdResponse {
                ty,
                status_code,
                status,
                result: Err((message, SnapdError::RuleNotFound)),
            }),

            (Some(ErrorKind::InvalidFields), Some(value)) => {
                #[derive(Debug, Deserialize)]
                #[serde(rename_all = "kebab-case")]
                struct Fields {
                    expiration: Option<StrValue>,
                    duration: Option<StrValue>,
                    path_pattern: Option<StrValue>,
                    permissions: Option<VecSupportedValue>,
                    interface: Option<VecSupportedValue>,
                    lifespan: Option<VecSupportedValue>,
                }

                #[derive(Debug, Deserialize)]
                struct StrValue {
                    reason: String,
                    value: String,
                }

                #[derive(Debug, Deserialize)]
                struct VecSupportedValue {
                    reason: String,
                    supported: Vec<String>,
                    value: Vec<String>,
                }

                let fs: Fields = serde_json::from_value(value).map_err(de::Error::custom)?;
                let err = if let Some(e) = fs.path_pattern {
                    SnapdError::MalformedFieldScalar {
                        reason: e.reason,
                        field: "path-pattern",
                        value: e.value,
                    }
                } else if let Some(e) = fs.expiration {
                    SnapdError::MalformedFieldScalar {
                        reason: e.reason,
                        field: "expiration",
                        value: e.value,
                    }
                } else if let Some(e) = fs.duration {
                    SnapdError::MalformedFieldScalar {
                        reason: e.reason,
                        field: "duration",
                        value: e.value,
                    }
                } else if let Some(e) = fs.permissions {
                    SnapdError::MalformedFieldVector {
                        reason: e.reason,
                        field: "permissions",
                        value: e.value,
                        supported: e.supported,
                    }
                } else if let Some(e) = fs.interface {
                    SnapdError::MalformedFieldVector {
                        reason: e.reason,
                        field: "interface",
                        value: e.value,
                        supported: e.supported,
                    }
                } else if let Some(e) = fs.lifespan {
                    SnapdError::MalformedFieldVector {
                        reason: e.reason,
                        field: "lifespan",
                        value: e.value,
                        supported: e.supported,
                    }
                } else {
                    error!("malformed reply-not-match-request error from snapd");
                    SnapdError::Raw
                };

                Ok(SnapdResponse {
                    ty,
                    status_code,
                    status,
                    result: Err((message, err)),
                })
            }

            (Some(ErrorKind::ReplyNotMatchRequest), Some(value)) => {
                #[derive(Debug, Deserialize)]
                #[serde(rename_all = "kebab-case")]
                struct Fields {
                    path_pattern: Option<PathPatternError>,
                    permissions: Option<PermissionsError>,
                }

                #[derive(Debug, Deserialize)]
                #[serde(rename_all = "kebab-case")]
                struct PathPatternError {
                    requested_path: String,
                    replied_pattern: String,
                }

                #[derive(Debug, Deserialize)]
                #[serde(rename_all = "kebab-case")]
                struct PermissionsError {
                    requested_permissions: Vec<String>,
                    replied_permissions: Vec<String>,
                }

                let fs: Fields = serde_json::from_value(value).map_err(de::Error::custom)?;
                let err = match (fs.path_pattern, fs.permissions) {
                    (Some(e), None) => SnapdError::InvalidPathPattern {
                        requested: e.requested_path,
                        replied: e.replied_pattern,
                    },

                    (None, Some(e)) => SnapdError::InvalidReplyPermissions {
                        requested: e.requested_permissions,
                        replied: e.replied_permissions,
                    },

                    _ => {
                        error!("malformed reply-not-match-request error from snapd");
                        SnapdError::Raw
                    }
                };

                Ok(SnapdResponse {
                    ty,
                    status_code,
                    status,
                    result: Err((message, err)),
                })
            }

            (Some(ErrorKind::RuleConflict), Some(mut value)) => {
                let conflicts: Vec<RuleConflict> = match value["conflicts"].take() {
                    Value::Null => {
                        error!("malformed rule conflict error from snapd: {value}");
                        return Ok(SnapdResponse {
                            ty,
                            status_code,
                            status,
                            result: Err((message, SnapdError::Raw)),
                        });
                    }

                    val => serde_json::from_value(val).map_err(de::Error::custom)?,
                };

                Ok(SnapdResponse {
                    ty,
                    status_code,
                    status,
                    result: Err((message, SnapdError::RuleConflict { conflicts })),
                })
            }

            (None, _) | (_, None) => Ok(SnapdResponse {
                ty,
                status_code,
                status,
                result: Err((message, SnapdError::Raw)),
            }),

            (kind, value) => {
                error!("malformed error response from snapd: {kind:?} {value:?}");
                Ok(SnapdResponse {
                    ty,
                    status_code,
                    status,
                    result: Err((message, SnapdError::Raw)),
                })
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::snapd_client::{PromptId, RawPrompt};
    use simple_test_case::dir_cases;

    #[dir_cases("resources/response-parsing-tests")]
    #[test]
    fn response_parsing_sanity_check(_path: &str, contents: &str) {
        let _parsed: SnapdResponse<String> = serde_json::from_str(contents).unwrap();
    }

    const RAW_PROMPT: &str = r#"{
  "result": {
    "constraints": {
      "available-permissions": [
        "read",
        "write",
        "execute"
      ],
      "path": "/home/ubuntu/test/0ec9a598-eee3-4785-bd5a-c5c0e3ff04e9/test-2.txt",
      "requested-permissions": [
        "write"
      ]
    },
    "id": "00000000000000BE",
    "interface": "home",
    "snap": "aa-prompting-test",
    "timestamp": "2024-08-15T13:28:17.077016791Z"
  },
  "status": "OK",
  "status-code": 200,
  "type": "sync",
  "warning-count": 2,
  "warning-timestamp": "2024-08-14T06:39:37.371971895Z"
}"#;

    #[test]
    fn raw_prompt_parsing_works() {
        let raw: SnapdResponse<RawPrompt> = serde_json::from_str(RAW_PROMPT).unwrap();
        let expected = RawPrompt {
            id: PromptId("00000000000000BE".to_string()),
            timestamp: "2024-08-15T13:28:17.077016791Z".to_string(),
            snap: "aa-prompting-test".to_string(),
            interface: "home".to_string(),
            constraints: serde_json::json!({
                "available-permissions": vec!["read", "write", "execute"],
                "path": "/home/ubuntu/test/0ec9a598-eee3-4785-bd5a-c5c0e3ff04e9/test-2.txt",
                "requested-permissions": vec!["write"]
            }),
        };

        assert_eq!(raw.result, Ok(expected));
    }
}
