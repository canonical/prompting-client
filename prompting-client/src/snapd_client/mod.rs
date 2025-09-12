use crate::{
    exit_with,
    snapd_client::{prompt::RawPrompt, response::parse_response},
    socket_client::UnixSocketClient,
    Error, ExitStatus, Result,
};
use chrono::{DateTime, SecondsFormat, Utc};
use hyper::Uri;
use serde::{de::DeserializeOwned, Deserialize, Serialize};
use std::{collections::HashMap, env, str::FromStr};
use tokio::net::UnixStream;
use tracing::{debug, error, info, warn};

pub mod interfaces;
mod prompt;
mod response;

pub use interfaces::{TypedPrompt, TypedPromptReply, TypedUiInput};
pub use prompt::{Action, Lifespan, Prompt, PromptReply, UiInput};
pub use response::{RuleConflict, SnapdError};

const FEATURE_NAME: &str = "apparmor-prompting";
const LONG_POLL_TIMEOUT: &str = "1h";
const NOTICE_TYPES: &str = "interfaces-requests-prompt";
const SNAPD_BASE_URI: &str = "http://localhost/v2";
const SNAPD_SOCKET: &str = "/run/snapd.socket";
const SNAPD_SNAP_SOCKET: &str = "/run/snapd-snap.socket";
const SNAPD_ABSTRACT_SNAP_SOCKET: &str = "\0/snapd/snapd-snap.socket";

#[derive(Debug, Default, Clone, PartialEq, Eq, Deserialize, Serialize)]
pub struct PromptId(pub String);

#[derive(Debug, Default, Clone, PartialEq, Eq, Deserialize, Serialize, Hash)]
pub struct Cgroup(pub String);

impl From<&str> for Cgroup {
    fn from(value: &str) -> Self {
        Cgroup(value.to_string())
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
pub enum PromptNotice {
    Update(PromptId),
    Resolved(PromptId),
}

/// Abstraction layer to make swapping out the underlying client possible for
/// testing.
#[allow(async_fn_in_trait)]
pub trait Client {
    async fn get_json<T>(&self, path: &str) -> Result<T>
    where
        T: DeserializeOwned;

    async fn post_json<T, U>(&self, path: &str, body: U) -> Result<T>
    where
        T: DeserializeOwned,
        U: Serialize;
}

impl Client for UnixSocketClient {
    async fn get_json<T>(&self, path: &str) -> Result<T>
    where
        T: DeserializeOwned,
    {
        let s = format!("{SNAPD_BASE_URI}/{path}");
        let uri = Uri::from_str(&s).map_err(|_| Error::InvalidUri {
            reason: "malformed",
            uri: s,
        })?;

        let res = self.get(uri).await?;

        parse_response(res).await
    }

    async fn post_json<T, U>(&self, path: &str, body: U) -> Result<T>
    where
        T: DeserializeOwned,
        U: Serialize,
    {
        let s = format!("{SNAPD_BASE_URI}/{path}");
        let uri = Uri::from_str(&s).map_err(|_| Error::InvalidUri {
            reason: "malformed",
            uri: s,
        })?;

        let res = self
            .post(uri, "application/json", serde_json::to_vec(&body)?)
            .await?;

        parse_response(res).await
    }
}

#[derive(Debug, Clone)]
pub struct SnapdClient<C>
where
    C: Client,
{
    client: C,
    notices_after: String,
}

pub type SnapdSocketClient = SnapdClient<UnixSocketClient>;

impl SnapdSocketClient {
    pub async fn new() -> Self {
        Self::new_with_notices_after(Utc::now()).await
    }

    pub async fn new_with_notices_after(dt: DateTime<Utc>) -> Self {
        // The #[allow(unused_variables)] attribute is necessary here because, when the "dry-run" feature is enabled,
        // the `socket` variable is not used in all code paths, which would otherwise cause a warning.
        #[allow(unused_variables)]
        let socket = if env::var("SNAP_NAME").is_ok() {
            if UnixStream::connect(SNAPD_ABSTRACT_SNAP_SOCKET)
                .await
                .is_ok()
            {
                info!("using the abstract snapd snap socket at address: @{SNAPD_ABSTRACT_SNAP_SOCKET}");
                SNAPD_ABSTRACT_SNAP_SOCKET
            } else {
                info!("using the snapd snap socket at address: {SNAPD_SNAP_SOCKET}");
                SNAPD_SNAP_SOCKET
            }
        } else {
            info!("using the snapd socket at address: {SNAPD_SOCKET}");
            SNAPD_SOCKET
        };

        #[cfg(feature = "dry-run")]
        let socket = {
            let snapd_override =
                env::var("SNAPD_SOCKET_OVERRIDE").expect("SNAPD_SOCKET_OVERRIDE env var to be set");
            info!("using override for the snap socket at address: {snapd_override}");

            snapd_override
        };

        Self {
            client: UnixSocketClient::new(socket),
            notices_after: dt.to_rfc3339_opts(SecondsFormat::Nanos, true),
        }
    }
}

impl<C> SnapdClient<C>
where
    C: Client,
{
    /// Check whether or not the apparmor-prompting feature is enabled on this system
    pub async fn is_prompting_enabled(&self) -> Result<bool> {
        let info: SysInfo = self.client.get_json("system-info").await?;

        info.prompting_enabled()
    }

    /// If prompting is not currently enabled then we exit with code 0 to avoid systemd marking
    /// the service as failed. Instead, snapd will ensure that we are started when the flag is enabled.
    pub async fn exit_if_prompting_not_enabled(&self) -> Result<()> {
        if !self.is_prompting_enabled().await? {
            warn!("the prompting feature is not enabled: exiting");
            // TODO: use `ExitStatus::PromptingDisabled` code when support for `SuccessExitStatus=` lands in snapcraft: https://github.com/canonical/snapcraft/issues/5692
            exit_with(ExitStatus::Success);
        }

        Ok(())
    }

    /// HTTP long poll on the /v2/notices API from snapd to await prompt requests for the user we
    /// are running under.
    ///
    /// Calling this method will update our [Self::notices_after] field when we successfully obtain
    /// new notices from snapd.
    ///
    /// Notices from snapd have an optional top level key of 'last-data' which can contain
    /// metadata that allows us to filter what IDs we need to look at. If the 'resolved' key is
    /// present and if its value is 'replied' then this is snapd telling us that a prompt has
    /// been actioned and we should clear any internal state we have associated with that ID.
    pub async fn pending_prompt_notices(&mut self) -> Result<Vec<PromptNotice>> {
        let path = format!(
            "notices?types={NOTICE_TYPES}&timeout={LONG_POLL_TIMEOUT}&after={}",
            self.notices_after
        );

        let raw_notices: Vec<Notice> = self.client.get_json(&path).await?;
        if let Some(n) = raw_notices.last() {
            n.last_occurred.clone_into(&mut self.notices_after);
        }

        debug!("received notices: {raw_notices:?}");

        let notices: Vec<PromptNotice> = raw_notices
            .into_iter()
            .map(|n| match n.last_data {
                Some(LastData { resolved: Some(s) }) if s == "replied" => {
                    PromptNotice::Resolved(n.key)
                }
                _ => PromptNotice::Update(n.key),
            })
            .collect();

        return Ok(notices);

        // serde structs

        #[derive(Debug, Deserialize)]
        #[serde(rename_all = "kebab-case")]
        struct Notice {
            key: PromptId,
            last_occurred: String,
            #[serde(default)]
            last_data: Option<LastData>,
            #[allow(dead_code)]
            #[serde(flatten)]
            extra: HashMap<String, serde_json::Value>,
        }

        #[derive(Debug, Deserialize)]
        #[serde(rename_all = "kebab-case")]
        struct LastData {
            #[serde(default)]
            resolved: Option<String>,
        }
    }

    /// Pull details for all pending prompts from snapd
    pub async fn all_pending_prompt_details(&self) -> Result<Vec<TypedPrompt>> {
        let raw_prompts: Vec<RawPrompt> =
            self.client.get_json("interfaces/requests/prompts").await?;

        raw_prompts.into_iter().map(|p| p.try_into()).collect()
    }

    /// Pull details for a specific prompt from snapd
    pub async fn prompt_details(&self, id: &PromptId) -> Result<TypedPrompt> {
        let prompt: RawPrompt = self
            .client
            .get_json(&format!("interfaces/requests/prompts/{}", id.0))
            .await?;

        prompt.try_into()
    }

    /// Submit a reply to the given prompt to snapd
    pub async fn reply_to_prompt(
        &self,
        id: &PromptId,
        reply: TypedPromptReply,
    ) -> Result<Vec<PromptId>> {
        let resp: Option<Vec<PromptId>> = self
            .client
            .post_json(&format!("interfaces/requests/prompts/{}", id.0), reply)
            .await?;

        debug!(prompt = id.0, ?resp, "response from snapd");

        Ok(resp.unwrap_or_default())
    }

    /// Pull metadata for rendering apparmor prompts using the `snaps` snapd endpoint.
    pub async fn snap_metadata(&self, name: &str) -> Option<SnapMeta> {
        let res = self.client.get_json(&format!("snaps/{name}")).await;
        return match res {
            Ok(SnapDetails {
                install_date,
                publisher,
            }) => Some(SnapMeta {
                name: name.to_owned(),
                updated_at: install_date
                    .split_once('T')
                    .map(|(s, _)| s.to_owned())
                    .unwrap_or(install_date),
                store_url: format!("snap://{name}"),
                publisher: publisher.display_name,
            }),

            Err(e) => {
                error!("unable to pull snap metadata for {name}: {e}");
                None
            }
        };

        // Serde structs

        #[derive(Debug, Default, Deserialize)]
        #[serde(rename_all = "kebab-case")]
        struct SnapDetails {
            install_date: String,
            publisher: Publisher,
        }

        #[derive(Debug, Default, Deserialize)]
        #[serde(rename_all = "kebab-case")]
        struct Publisher {
            display_name: String,
        }
    }
}

#[derive(Debug, Default, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct SnapMeta {
    pub name: String,
    pub updated_at: String,
    pub store_url: String,
    pub publisher: String,
}

#[derive(Debug, Default, Deserialize)]
struct SysInfo {
    features: HashMap<String, Feature>,
}

impl SysInfo {
    fn prompting_enabled(mut self) -> Result<bool> {
        let f = self
            .features
            .remove(FEATURE_NAME)
            .ok_or(Error::NotAvailable)?;

        match f.unsupported_reason {
            Some(reason) => Err(Error::NotSupported { reason }),
            None => Ok(f.supported && f.enabled),
        }
    }
}

#[derive(Debug, Default, Deserialize)]
#[serde(rename_all = "kebab-case")]
struct Feature {
    enabled: bool,
    supported: bool,
    unsupported_reason: Option<String>,
}

#[cfg(test)]
mod tests {
    use super::*;
    use simple_test_case::test_case;

    #[derive(Debug)]
    enum Enabled {
        Ok(bool),
        NotSupported(&'static str),
    }

    #[test_case(false, None, Enabled::Ok(false); "supported but not enabled")]
    #[test_case(true, None, Enabled::Ok(true); "supported and enabled")]
    #[test_case(false, Some("foo"), Enabled::NotSupported("foo"); "unsupported and not enabled")]
    #[test_case(true, Some("foo"), Enabled::NotSupported("foo"); "unsupported but enabled")]
    #[test]
    fn prompting_enabled_works(enabled: bool, unsupported_reason: Option<&str>, expected: Enabled) {
        let mut features = HashMap::default();
        features.insert(
            FEATURE_NAME.to_string(),
            Feature {
                enabled,
                supported: unsupported_reason.is_none(),
                unsupported_reason: unsupported_reason.map(String::from),
            },
        );

        let s = SysInfo { features };

        match (s.prompting_enabled(), expected) {
            (Ok(got), Enabled::Ok(wanted)) => assert_eq!(got, wanted, "boolean return was wrong"),
            (Err(Error::NotSupported { reason }), Enabled::NotSupported(s)) => {
                assert_eq!(reason, s)
            }
            (got, wanted) => panic!("expected {wanted:?}, got {got:?}"),
        }
    }

    #[test]
    fn prompting_enabled_errors_correctly_when_not_available() {
        let s = SysInfo::default();

        match s.prompting_enabled() {
            Err(Error::NotAvailable) => (),
            res => panic!("expected NotAvailable, got {res:?}"),
        }
    }
}
