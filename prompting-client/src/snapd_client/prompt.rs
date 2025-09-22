//! Generic types for working with apparmor prompts.
//!
//! There are two sets of prompt types used in the prompting client:
//!   - Types that are generic over [SnapInterface], provided by this module
//!   - `Typed...` counterpart enums provided by the [interfaces][0] module
//!
//! The generic types are used within the interface specific logic written to support each Snapd
//! interface, and the `Typed...` enums are used by the [daemon][crate::daemon] to handle the
//! interface agnostic behaviour of the main daemon event loop. The enum types are kept in the
//! interfaces module so that all of the per-interface specific code is co-located.
//!
//! See the documentation on [SnapInterface] for more details on how the different types relate to
//! one another and the structure of the data pipeline used by the daemon.
//!
//!   [0]: crate::snapd_client::interfaces
use crate::{
    snapd_client::{interfaces::SnapInterface, Cgroup, PromptId, SnapMeta},
    Result,
};
use serde::{Deserialize, Serialize};
use strum::{Display, EnumString};

/// Utility type for parsing the top level structure of the prompt JSON object received from
/// Snapd. At this stage there are no guarantees about the structure of the `constraints` field,
/// which needs to be parsed based on the value of the top level `interface` field.
#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct RawPrompt {
    pub(crate) id: PromptId,
    pub(crate) timestamp: String,
    pub(crate) snap: String,
    pub(crate) pid: i64,
    #[serde(default = "Cgroup::internal")]
    pub(crate) cgroup: Cgroup,
    pub(crate) interface: String,
    pub(crate) constraints: serde_json::Value,
}

/// A prompt that contains [SnapInterface] specific constraints.
#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct Prompt<I>
where
    I: SnapInterface,
{
    pub(crate) id: PromptId,
    pub(crate) timestamp: String,
    pub(crate) snap: String,
    pub(crate) pid: i64,
    pub(crate) cgroup: Cgroup,
    pub(crate) interface: String,
    pub(crate) constraints: I::Constraints,
}

impl<I> Prompt<I>
where
    I: SnapInterface,
{
    pub fn id(&self) -> &str {
        &self.id.0
    }

    pub fn snap(&self) -> &str {
        &self.snap
    }

    pub fn pid(&self) -> i64 {
        self.pid
    }

    pub fn cgroup(&self) -> &Cgroup {
        &self.cgroup
    }

    pub fn timestamp(&self) -> &str {
        &self.timestamp
    }

    pub fn interface(&self) -> &str {
        &self.interface
    }

    /// Attempt to deserialize the `constraints` field into structured data associated with a
    /// particulart [SnapInterface].
    ///
    /// # Safety
    ///
    /// Calling this method on a [RawPrompt] that has constraints that parse correctly for the
    /// given [SnapInterface], but not the correct interface name may result in malformed prompts
    /// being presented to the user. On debug builds this will trigger an assert.
    pub(crate) unsafe fn try_from_raw(
        RawPrompt {
            id,
            timestamp,
            snap,
            pid,
            cgroup,
            interface,
            constraints,
        }: RawPrompt,
    ) -> Result<Self> {
        debug_assert_eq!(
            interface,
            I::NAME,
            "Prompt::try_from called for for wrong interface"
        );

        Ok(Prompt {
            id,
            timestamp,
            snap,
            pid,
            cgroup,
            interface,
            constraints: serde_json::from_value(constraints)?,
        })
    }
}

/// A reply to a prompt that contains [SnapInterface] specific reply-constraints.
#[derive(Debug, Default, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct PromptReply<I>
where
    I: SnapInterface,
{
    pub(crate) action: Action,
    pub(crate) lifespan: Lifespan,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub(crate) duration: Option<String>,
    pub(crate) constraints: I::ReplyConstraints,
}

impl<I> PromptReply<I>
where
    I: SnapInterface,
{
    /// Set this reply to apply for the remainder of the user's current session.
    pub fn for_session(mut self) -> Self {
        self.lifespan = Lifespan::Session;
        self
    }

    /// Set this reply to create a new permanent rule.
    pub fn for_forever(mut self) -> Self {
        self.lifespan = Lifespan::Forever;
        self
    }

    /// Set this reply to apply for the specified timespan.
    ///
    /// Timespans are provided in the format parsable by go's [ParseDuration](https://pkg.go.dev/time#ParseDuration).
    pub fn for_timespan(mut self, duration: impl Into<String>) -> Self {
        self.lifespan = Lifespan::Timespan;
        self.duration = Some(duration.into());
        self
    }
}

/// [SnapInterface] specific data that can be serialized for sending to the Flutter UI.
#[derive(Debug, Default, Clone, PartialEq, Eq)]
pub struct UiInput<I>
where
    I: SnapInterface,
{
    pub(crate) id: PromptId,
    pub(crate) meta: SnapMeta,
    pub(crate) data: I::UiInputData,
}

#[derive(
    Debug, Default, Clone, Copy, PartialEq, Eq, Deserialize, Serialize, Display, EnumString,
)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "lowercase")]
pub enum Action {
    Allow,
    #[default]
    Deny,
}

#[derive(
    Debug, Default, Clone, Copy, PartialEq, Eq, Deserialize, Serialize, Display, EnumString,
)]
#[serde(rename_all = "lowercase")]
#[strum(serialize_all = "lowercase")]
pub enum Lifespan {
    #[default]
    Single,
    Session,
    Forever,
    Timespan, // supported in snapd but not currently used in the UI
}

#[cfg(test)]
mod tests {
    use simple_test_case::test_case;

    use super::*;

    #[test_case(
        r#"{
            "id": "0000000000000002",
            "timestamp": "2024-08-14T07:28:22.694800024Z",
            "snap": "firefox",
            "pid": 1234,
            "cgroup": "/user.slice/user-1000.slice/user@1000.service/app.slice/myapp.scope",
            "interface": "home",
            "constraints": {}
        }"#,
        RawPrompt {
            id: PromptId("0000000000000002".to_string()),
            timestamp: "2024-08-14T07:28:22.694800024Z".to_string(),
            snap: "firefox".to_string(),
            pid: 1234,
            cgroup: Cgroup(
                "/user.slice/user-1000.slice/user@1000.service/app.slice/myapp.scope".to_string(),
            ),
            interface: "home".to_string(),
            constraints: serde_json::json!({}),
        };
        "raw prompt with cgroup"
    )]
    #[test_case(
        r#"{
            "id": "0000000000000002",
            "timestamp": "2024-08-14T07:28:22.694800024Z",
            "snap": "firefox",
            "pid": 1234,
            "interface": "home",
            "constraints": {}
        }"#,
        RawPrompt {
            id: PromptId("0000000000000002".to_string()),
            timestamp: "2024-08-14T07:28:22.694800024Z".to_string(),
            snap: "firefox".to_string(),
            pid: 1234,
            cgroup: Cgroup("internal".to_string()),
            interface: "home".to_string(),
            constraints: serde_json::json!({}),
        };
        "raw prompt without cgroup"
    )]
    #[test]
    fn raw_prompt_deserializes(json: &str, expected: RawPrompt) {
        let raw: RawPrompt = serde_json::from_str(json).unwrap();
        assert_eq!(raw, expected);
    }
}
