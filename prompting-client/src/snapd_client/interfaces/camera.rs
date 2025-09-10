use crate::{
    prompt_sequence::MatchAttempt,
    protos::{
        apparmor_prompting::{CameraPromptReply, DevicePermission, MetaData},
        CameraPrompt as ProtoCameraPrompt,
    },
    snapd_client::{
        interfaces::{
            ConstraintsFilter, Prompt, PromptReply, ProtoPrompt, ReplyConstraintsOverrides,
            SnapInterface,
        },
        prompt::UiInput,
        Action, Error, Lifespan, Result, SnapMeta,
    },
};
use serde::{Deserialize, Serialize};
use tonic::Status;

impl Prompt<CameraInterface> {
    pub fn requested_permissions(&self) -> &[String] {
        &self.constraints.requested_permissions
    }
}

impl PromptReply<CameraInterface> {
    /// Attempt to set a custom permission set for this reply.
    ///
    /// This method will error if the requested permissions are not available on the parent
    /// [Prompt].
    pub fn try_with_custom_permissions(mut self, permissions: Vec<String>) -> Result<Self> {
        if permissions
            .iter()
            .all(|p| self.constraints.available_permissions.contains(p))
        {
            self.constraints.permissions = permissions;
            Ok(self)
        } else {
            Err(Error::InvalidCustomPermissions {
                requested: permissions,
                available: self.constraints.available_permissions,
            })
        }
    }
}

/// The interface for allowing access to the user's camera.
#[derive(Debug, Default, Clone, Deserialize, Serialize, PartialEq, Eq)]
pub struct CameraInterface;

impl SnapInterface for CameraInterface {
    const NAME: &'static str = "camera";

    type Constraints = CameraConstraints;
    type ReplyConstraints = CameraReplyConstraints;

    type ConstraintsFilter = CameraConstraintsFilter;
    type ReplyConstraintsOverrides = CameraReplyConstraintsOverrides;

    type UiInputData = CameraUiInputData;
    type UiReplyConstraints = CameraPromptReply;

    fn prompt_to_reply(prompt: Prompt<Self>, action: Action) -> PromptReply<Self> {
        PromptReply {
            action,
            lifespan: Lifespan::Single,
            duration: None,
            constraints: CameraReplyConstraints {
                permissions: prompt.constraints.requested_permissions,
                available_permissions: prompt.constraints.available_permissions,
            },
        }
    }

    fn ui_input_from_prompt(prompt: Prompt<Self>, meta: Option<SnapMeta>) -> Result<UiInput<Self>> {
        let meta = meta.unwrap_or_else(|| SnapMeta {
            name: prompt.snap,
            updated_at: String::default(),
            store_url: String::default(),
            publisher: String::default(),
        });

        Ok(UiInput {
            id: prompt.id,
            meta,
            data: CameraUiInputData {},
        })
    }

    fn proto_prompt_from_ui_input(input: UiInput<Self>) -> Result<ProtoPrompt, Status> {
        let SnapMeta {
            name,
            updated_at,
            store_url,
            publisher,
        } = input.meta;

        Ok(ProtoPrompt::CameraPrompt(ProtoCameraPrompt {
            meta_data: Some(MetaData {
                prompt_id: input.id.0,
                snap_name: name,
                store_url,
                publisher,
                updated_at,
            }),
        }))
    }

    fn map_proto_reply_constraints(
        &self,
        raw_constraints: CameraPromptReply,
    ) -> Result<CameraReplyConstraints, String> {
        let permissions = raw_constraints
            .permissions
            .into_iter()
            .map(|id| {
                let perm = DevicePermission::try_from(id)
                    .map_err(|_| format!("unknown permission id: {id}"))?;
                let s = match perm {
                    DevicePermission::Access => "access".to_owned(),
                };

                Ok(s)
            })
            .collect::<std::result::Result<Vec<_>, String>>()?;

        Ok(CameraReplyConstraints {
            permissions,
            available_permissions: Vec::new(),
        })
    }
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct CameraConstraints {
    pub(crate) requested_permissions: Vec<String>,
    pub(crate) available_permissions: Vec<String>,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CameraUiInputData {}

#[derive(Debug, Default, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct CameraReplyConstraints {
    pub(crate) permissions: Vec<String>,
    #[serde(skip)]
    pub(crate) available_permissions: Vec<String>,
}

#[derive(Debug, Default, Serialize, Deserialize, Clone)]
#[serde(rename_all = "kebab-case")]
pub struct CameraConstraintsFilter {}

impl ConstraintsFilter for CameraConstraintsFilter {
    type Constraints = CameraConstraints;

    fn matches(&self, _constraints: &Self::Constraints) -> MatchAttempt {
        MatchAttempt::Success
    }
}

#[derive(Debug, Default, Serialize, Deserialize, Clone)]
#[serde(rename_all = "kebab-case")]
pub struct CameraReplyConstraintsOverrides {
    pub permissions: Option<Vec<String>>,
}

impl ReplyConstraintsOverrides for CameraReplyConstraintsOverrides {
    type ReplyConstraints = CameraReplyConstraints;

    fn apply(self, mut constraints: Self::ReplyConstraints) -> Self::ReplyConstraints {
        if let Some(permissions) = self.permissions {
            constraints.permissions = permissions;
        }

        constraints
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::snapd_client::{RawPrompt, TypedPrompt};
    use simple_test_case::test_case;

    const CAMERA_PROMPT: &str = r#"{
      "id": "C7OUCCDWCE6CC===",
      "timestamp": "2024-06-28T19:15:37.321782305Z",
      "snap": "firefox",
      "pid": 1234,
      "interface": "camera",      
      "constraints": {
        "requested-permissions": [
            "access"
        ],
        "available-permissions": [
            "access"
        ]
      }
    }"#;

    #[test]
    fn deserializing_a_camera_prompt_works() {
        let raw: RawPrompt = serde_json::from_str(CAMERA_PROMPT).unwrap();
        assert_eq!(raw.interface, "camera");

        let p: TypedPrompt = raw.try_into().unwrap();
        assert!(matches!(p, TypedPrompt::Camera(_)));
    }

    #[test_case(&["allow"], &["allow", "read"]; "some not in available")]
    #[test_case(&["allow"], &["write"]; "none in available")]
    #[test]
    fn invalid_reply_permissions_error(available: &[&str], requested: &[&str]) {
        let reply: PromptReply<CameraInterface> = PromptReply {
            constraints: CameraReplyConstraints {
                available_permissions: available.iter().map(|&s| s.into()).collect(),
                ..Default::default()
            },
            ..Default::default()
        };

        let res = reply.try_with_custom_permissions(requested.iter().map(|&s| s.into()).collect());
        match res {
            Err(Error::InvalidCustomPermissions { .. }) => (),
            Err(e) => panic!("expected InvalidCustomPermissions, got {e}"),
            Ok(_) => panic!("should have errored"),
        }
    }
}
