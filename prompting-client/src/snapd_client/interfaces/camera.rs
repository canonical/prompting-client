use crate::{
    prompt_sequence::MatchAttempt,
    protos::{
        apparmor_prompting::{CameraPromptReply, MetaData},
        CameraPrompt as ProtoCameraPrompt,
    },
    snapd_client::{
        interfaces::{
            ConstraintsFilter, Prompt, PromptReply, ProtoPrompt, ReplyConstraintsOverrides,
            SnapInterface,
        },
        prompt::UiInput,
        Action, Lifespan, Result, SnapMeta,
    },
};
use serde::{Deserialize, Serialize};
use tonic::Status;

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

    fn prompt_to_reply(_prompt: Prompt<Self>, action: Action) -> PromptReply<Self> {
        PromptReply {
            action,
            lifespan: Lifespan::Single,
            duration: None,
            constraints: CameraReplyConstraints {},
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
        _raw_constraints: CameraPromptReply,
    ) -> Result<CameraReplyConstraints, String> {
        Ok(CameraReplyConstraints {})
    }
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct CameraConstraints {}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CameraUiInputData {}

#[derive(Debug, Default, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct CameraReplyConstraints {}

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
pub struct CameraReplyConstraintsOverrides {}

impl ReplyConstraintsOverrides for CameraReplyConstraintsOverrides {
    type ReplyConstraints = CameraReplyConstraints;

    fn apply(self, constraints: Self::ReplyConstraints) -> Self::ReplyConstraints {
        constraints
    }
}

#[cfg(test)]
mod tests {
    use crate::snapd_client::{RawPrompt, TypedPrompt};

    const CAMERA_PROMPT: &str = r#"{
      "id": "C7OUCCDWCE6CC===",
      "timestamp": "2024-06-28T19:15:37.321782305Z",
      "snap": "firefox",
      "pid": 1234,
      "interface": "camera",      
      "constraints": {}
    }"#;

    #[test]
    fn deserializing_a_camera_prompt_works() {
        let raw: RawPrompt = serde_json::from_str(CAMERA_PROMPT).unwrap();
        assert_eq!(raw.interface, "camera");

        let p: TypedPrompt = raw.try_into().unwrap();
        assert!(matches!(p, TypedPrompt::Camera(_)));
    }
}
