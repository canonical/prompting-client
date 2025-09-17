//! Parsing of snapd API responses
use crate::{
    socket_client::{body_json, body_raw},
    Error, Result,
};
use hyper::{
    body::{Bytes, Incoming},
    Response, StatusCode,
};
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
    RuleConflicts {
        conflicts: Vec<RuleConflict>,
    },
    InvalidPermissions {
        requested: Vec<String>,
        replied: Vec<String>,
    },
    InvalidPathPattern {
        requested: String,
        replied: String,
    },
    ParseError {
        field: &'static str,
        value: String,
    },
    UnsupportedValue {
        field: &'static str,
        supported: Vec<String>,
        provided: Vec<String>,
    },
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct RuleConflict {
    pub(crate) permission: String,
    pub(crate) variant: String,
    pub(crate) conflicting_id: String,
}

pub async fn parse_raw_response(res: Response<Incoming>) -> Result<Bytes> {
    let status = res.status();
    match status {
        StatusCode::OK => {
            let response: SnapdResponse<()> = body_json(res).await?;
            match response.result {
                Err((message, err)) => Err(Error::SnapdError {
                    status,
                    message,
                    err: Box::new(err),
                }),
                Ok(()) => Err(Error::InvalidSnapdErrorResponse { status }),
            }
        }
        _ => body_raw(res).await,
    }
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
                let fs: InvalidFields = serde_json::from_value(value).map_err(de::Error::custom)?;

                let err = if let Some(e) = fs.path_pattern {
                    e.into_error("path-pattern")
                } else if let Some(e) = fs.expiration {
                    e.into_error("expiration")
                } else if let Some(e) = fs.duration {
                    e.into_error("duration")
                } else if let Some(e) = fs.permissions {
                    e.into_error("permissions")
                } else if let Some(e) = fs.interface {
                    e.into_error("interface")
                } else if let Some(e) = fs.lifespan {
                    e.into_error("lifespan")
                } else if let Some(e) = fs.outcome {
                    e.into_error("outcome")
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
                let ReplyNotMatchRequest {
                    path_pattern,
                    permissions,
                } = serde_json::from_value(value).map_err(de::Error::custom)?;

                let err = match (path_pattern, permissions) {
                    (Some(e), None) => SnapdError::InvalidPathPattern {
                        requested: e.requested_path,
                        replied: e.replied_pattern,
                    },

                    (None, Some(e)) => SnapdError::InvalidPermissions {
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
                    result: Err((message, SnapdError::RuleConflicts { conflicts })),
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

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
struct RawResponse {
    #[serde(rename = "type")]
    ty: String,
    status_code: u16,
    status: String,
    result: serde_json::Value,
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

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
struct InvalidFields {
    expiration: Option<StrValue>,
    duration: Option<StrValue>,
    path_pattern: Option<StrValue>,
    permissions: Option<VecSupportedValue>,
    interface: Option<VecSupportedValue>,
    lifespan: Option<VecSupportedValue>,
    outcome: Option<VecSupportedValue>,
}

#[derive(Debug, Deserialize)]
struct StrValue {
    reason: String,
    value: String,
}

impl StrValue {
    fn into_error(self, field: &'static str) -> SnapdError {
        if self.reason == "parse-error" {
            SnapdError::ParseError {
                field,
                value: self.value,
            }
        } else {
            error!("unknown {field} error: {}", self.reason);
            SnapdError::Raw
        }
    }
}

#[derive(Debug, Deserialize)]
struct VecSupportedValue {
    reason: String,
    supported: Vec<String>,
    value: Vec<String>,
}

impl VecSupportedValue {
    fn into_error(self, field: &'static str) -> SnapdError {
        if self.reason == "unsupported-value" {
            SnapdError::UnsupportedValue {
                field,
                provided: self.value,
                supported: self.supported,
            }
        } else {
            error!("unknown {field} error: {}", self.reason);
            SnapdError::Raw
        }
    }
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
struct ReplyNotMatchRequest {
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::snapd_client::{Cgroup, PromptId, RawPrompt};
    use simple_test_case::dir_cases;

    // Files within this directory need to have a prefix that matches one of the assertion branches
    // below in order to check the overall structure of the response
    #[dir_cases("resources/response-parsing-tests")]
    #[test]
    fn response_parsing_sanity_check(full_path: &str, contents: &str) {
        let path = full_path.split('/').next_back().unwrap();

        let parsed: SnapdResponse<String> = serde_json::from_str(contents).unwrap();
        let (_, err) = parsed.result.unwrap_err();

        if path.starts_with("raw") {
            assert!(matches!(err, SnapdError::Raw));
        } else if path.starts_with("rule-not-found") {
            assert!(matches!(err, SnapdError::RuleNotFound));
        } else if path.starts_with("prompt-not-found") {
            assert!(matches!(err, SnapdError::PromptNotFound));
        } else if path.starts_with("rule-conflict") {
            assert!(matches!(err, SnapdError::RuleConflicts { .. }));
        } else if path.starts_with("invalid-path-pattern") {
            assert!(matches!(err, SnapdError::InvalidPathPattern { .. }));
        } else if path.starts_with("invalid-permissions") {
            assert!(matches!(err, SnapdError::InvalidPermissions { .. }));
        } else if path.starts_with("parse-error") {
            assert!(matches!(err, SnapdError::ParseError { .. }));
        } else if path.starts_with("unsupported") {
            assert!(matches!(err, SnapdError::UnsupportedValue { .. }));
        } else {
            panic!("no assertion in place for test case: {path}");
        }
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
    "pid": 1234,
    "cgroup": "/user.slice/user-1000.slice/user@1000.service/app.slice/myapp.scope",
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
            pid: 1234,
            cgroup: Cgroup(
                "/user.slice/user-1000.slice/user@1000.service/app.slice/myapp.scope".to_string(),
            ),
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
