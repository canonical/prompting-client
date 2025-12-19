//! Per-interface logic and data types for working with Snapd prompts.
//!
//! Each snapd interface is handled slightly differently in terms of how we handle processing
//! prompts for it and how we generate the UI for the user. The [SnapInterface] trait is used to
//! provide the functionality and associated types required by the [daemon][crate::daemon] for
//! supporting a new interface.
//!
//! The majority of use cases for working with per-interface prompts should be possible to write
//! using the [TypedPrompt], [TypedUiInput] and [TypedPromptReply] types rather than making use of
//! implementations of [SnapInterface] directly.
use crate::{
    daemon::EnrichedPrompt,
    prompt_sequence::MatchAttempt,
    protos::apparmor_prompting::{
        self, get_current_prompt_response::Prompt as ProtoPrompt,
        prompt_reply::PromptReply as ProtoConstraints, PromptReply as ProtoPromptReply,
    },
    snapd_client::{
        self,
        prompt::{Prompt, RawPrompt, UiInput},
        Action, Cgroup, PromptId, PromptReply, SnapMeta,
    },
    Error, Result,
};
use serde::{de::DeserializeOwned, Deserialize, Serialize};
use std::fmt;
use tonic::{Code, Status};

pub mod camera;
pub mod home;
pub mod microphone;

use camera::CameraInterface;
use home::HomeInterface;
use microphone::MicrophoneInterface;

#[macro_export]
macro_rules! map_enum {
    ($from:ident => $to:ident; [$($variant:ident),+]; $val:expr;) => {
        match $val {
            $(
                $from::$variant => $to::$variant,
            )+
        }
    };

    ($fmod:ident::$from:ident => $tmod:ident::$to:ident; [$($variant:ident),+]; $val:expr;) => {
        match $val {
            $(
                $fmod::$from::$variant => $tmod::$to::$variant,
            )+
        }
    };
}

/// The core of the prompting client daemon is generic over the content of the per-interface data
/// we receive in prompts from Snapd, with the specifics being handled by implementations of this
/// trait.
///
/// At a high level, the purpose of this trait is to provide a set of methods and types that act as
/// a data pipeline for processing prompts from Snapd via the Flutter UI and user interaction:
///
///   - `RawPrompt` data from Snapd is obtained using the `SnapdClient::prompt_details` method
///   - A `TypedPrompt` is then created based on the prompt interface name and deserialization of the
///     `constraints` field into the `Constraints` associated type
///   - This typed prompt is combined with `SnapMeta` pulled from Snapd to create an `EnrichedPrompt`
///     which can be converted to a `UiInput` using the `SnapInterface::ui_input_from_prompt` method
///   - This is then converted to a `ProtoPrompt` to be sent to the Flutter UI
///   - The `ProtoPromptReply` type received from the UI is then converted to a `TypedPromptReply`
///     before being submitted to Snapd
///
/// See the documentation on each of the associated types and methods for more details.
#[allow(async_fn_in_trait)]
pub trait SnapInterface: fmt::Debug + Sized {
    /// The snapd interface name as provided by Snapd in the `interface` field in prompts.
    const NAME: &'static str;

    /// Serialization type for the `constraints` field of a prompt for this interface.
    ///
    /// The structure of this data needs to be developed and agreed upon with the Snapd team when
    /// support for a new interface is being implemented.
    type Constraints: fmt::Debug + Clone + Serialize + DeserializeOwned;

    /// The Rust representation of the data that will be sent to the Flutter UI over GRPC to
    /// display a prompt for this interface.
    ///
    /// The contents of this type must be sufficient to parse the required GRPC message using
    /// [SnapInterface::proto_prompt_from_ui_input].
    type UiInputData: fmt::Debug + Clone;

    /// The Rust representation of the constraints data received from the Flutter UI over GRPC.
    ///
    /// The contents of this type must be sufficient to parse the required GRPC message using
    /// [SnapInterface::map_proto_reply_constraints].
    type UiReplyConstraints: fmt::Debug;

    /// Serialization type for the `constraints` field of a reply to prompts for this interface.
    ///
    /// This data structure is closely related (but not guaranteed to be identical) to the data
    /// structure received from Snapd under the `constraints` field of prompts for this interface.
    type ReplyConstraints: fmt::Debug + Clone + Serialize;

    /// Serialization type for use with the scripted client in order to match on received prompts
    /// and determine whether or not they should be handled or ignored.
    ///
    /// See the documentation for the [ConstraintsFilter] trait for more details.
    type ConstraintsFilter: ConstraintsFilter<Constraints = Self::Constraints>;

    /// Serialization type for use with the scripted client to specify how the client should
    /// respond to a matched prompt.
    ///
    /// See the documentation for the [ReplyConstraintsOverrides] trait for more details.
    type ReplyConstraintsOverrides: ReplyConstraintsOverrides<
        ReplyConstraints = Self::ReplyConstraints,
    >;

    /// Maps the parsed prompt data from Snapd along with meta-data about the snap that triggered
    /// the prompt (if available) into the data required for the Flutter UI.
    ///
    /// The Flutter UI is driven by the data provided by the daemon, so this method is where we
    /// implement the logic that generates the options presented to the user.
    fn ui_input_from_prompt(prompt: Prompt<Self>, meta: Option<SnapMeta>) -> Result<UiInput<Self>>;

    /// Maps [UiInput] to the protobuf serialization type required for sending data to the Flutter
    /// UI.
    ///
    /// This mapping from Snapd prompt data to the protobuf type is split between this method and
    /// [SnapInterface::ui_input_from_prompt] so that testing of the generation of [UiInput] data
    /// is more ergonomic. (The generated protobuf types from Tonic are not nice to construct
    /// directly or work with in tests)
    fn proto_prompt_from_ui_input(ui_input: UiInput<Self>) -> Result<ProtoPrompt, Status>;

    /// Used to parse the interface specific `constraints` data received from the Flutter UI.
    fn map_proto_reply_constraints(
        &self,
        raw_constraints: Self::UiReplyConstraints,
    ) -> Result<Self::ReplyConstraints, String>;

    /// Helper method for directly mapping a prompt to a reply.
    ///
    /// This is used by the scripted client along with [ReplyConstraintsOverrides] to generate
    /// scripted replies to prompts identified using a [ConstraintsFilter].
    fn prompt_to_reply(prompt: Prompt<Self>, action: Action) -> PromptReply<Self>;
}

/// A filter used by the scripted client to determine if incoming prompts for this interface should
/// be considered part of the expected prompt sequence.
pub trait ConstraintsFilter: Default + fmt::Debug + Clone + Serialize + DeserializeOwned {
    /// The structure of the `constraints` field in the received prompt.
    type Constraints: fmt::Debug + Clone + Serialize + DeserializeOwned;

    /// Whether or not this filter matches the provided prompt constraints or not.
    ///
    /// Where possible all match failures should be returned to the caller rather than just the
    /// first failure encountered. This allows the scripted client to provide clearer output to
    /// the user in the case of unexpected test failures.
    fn matches(&self, constraints: &Self::Constraints) -> MatchAttempt;
}

/// A set of overrides to apply to the default reply generated by the scripted client when
/// responding to a prompt.
pub trait ReplyConstraintsOverrides:
    Default + fmt::Debug + Clone + Serialize + DeserializeOwned
{
    /// The structure of the `constraints` field in the reply being sent to Snapd.
    type ReplyConstraints: fmt::Debug + Clone + Serialize + DeserializeOwned;

    /// Apply the contained overrides to a given prompt reply.
    fn apply(self, constraints: Self::ReplyConstraints) -> Self::ReplyConstraints;
}

/// Generic-free counterpart to [Prompt].
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "interface")]
#[serde(rename_all = "kebab-case")]
pub enum TypedPrompt {
    Camera(Prompt<CameraInterface>),
    Home(Prompt<HomeInterface>),
    Microphone(Prompt<MicrophoneInterface>),
}

impl TypedPrompt {
    pub fn into_deny_once(self) -> TypedPromptReply {
        match self {
            Self::Camera(p) => CameraInterface::prompt_to_reply(p, Action::Deny).into(),
            Self::Home(p) => HomeInterface::prompt_to_reply(p, Action::Deny).into(),
            Self::Microphone(p) => MicrophoneInterface::prompt_to_reply(p, Action::Deny).into(),
        }
    }

    pub fn into_allow_once(self) -> TypedPromptReply {
        match self {
            Self::Camera(p) => CameraInterface::prompt_to_reply(p, Action::Allow).into(),
            Self::Home(p) => HomeInterface::prompt_to_reply(p, Action::Allow).into(),
            Self::Microphone(p) => MicrophoneInterface::prompt_to_reply(p, Action::Allow).into(),
        }
    }

    pub fn into_allow_forever(self) -> TypedPromptReply {
        match self {
            Self::Camera(p) => CameraInterface::prompt_to_reply(p, Action::Allow)
                .for_forever()
                .into(),
            Self::Home(p) => HomeInterface::prompt_to_reply(p, Action::Allow)
                .for_forever()
                .into(),
            Self::Microphone(p) => MicrophoneInterface::prompt_to_reply(p, Action::Allow)
                .for_forever()
                .into(),
        }
    }

    pub fn id(&self) -> &PromptId {
        match self {
            Self::Camera(p) => &p.id,
            Self::Home(p) => &p.id,
            Self::Microphone(p) => &p.id,
        }
    }

    pub fn snap(&self) -> &str {
        match self {
            Self::Camera(p) => &p.snap,
            Self::Home(p) => &p.snap,
            Self::Microphone(p) => &p.snap,
        }
    }

    pub fn pid(&self) -> i64 {
        match self {
            Self::Camera(p) => p.pid,
            Self::Home(p) => p.pid,
            Self::Microphone(p) => p.pid,
        }
    }

    pub fn cgroup(&self) -> &Cgroup {
        match self {
            Self::Camera(p) => &p.cgroup,
            Self::Home(p) => &p.cgroup,
            Self::Microphone(p) => &p.cgroup,
        }
    }
}

impl TryFrom<RawPrompt> for TypedPrompt {
    type Error = Error;

    fn try_from(raw: RawPrompt) -> Result<Self> {
        // SAFETY: we are only deserializing the prompt constraints data after checking the value
        //         of raw.interface is correct for the SnapInterface we are using.
        unsafe {
            match raw.interface.as_str() {
                CameraInterface::NAME => Ok(TypedPrompt::Camera(Prompt::try_from_raw(raw)?)),
                HomeInterface::NAME => Ok(TypedPrompt::Home(Prompt::try_from_raw(raw)?)),
                MicrophoneInterface::NAME => {
                    Ok(TypedPrompt::Microphone(Prompt::try_from_raw(raw)?))
                }
                _ => Err(Error::UnsupportedInterface {
                    interface: raw.interface,
                }),
            }
        }
    }
}

/// Generic-free counterpart to [UiInput].
#[derive(Debug, Clone)]
pub enum TypedUiInput {
    Camera(UiInput<CameraInterface>),
    Home(UiInput<HomeInterface>),
    Microphone(UiInput<MicrophoneInterface>),
}

impl TypedUiInput {
    pub fn id(&self) -> &PromptId {
        match self {
            Self::Camera(input) => &input.id,
            Self::Home(input) => &input.id,
            Self::Microphone(input) => &input.id,
        }
    }
}

impl TryFrom<EnrichedPrompt> for TypedUiInput {
    type Error = Error;

    fn try_from(ep: EnrichedPrompt) -> Result<Self, Self::Error> {
        let typed_prompt = match ep.prompt {
            TypedPrompt::Camera(p) => {
                Self::Camera(CameraInterface::ui_input_from_prompt(p, ep.meta)?)
            }
            TypedPrompt::Home(p) => Self::Home(HomeInterface::ui_input_from_prompt(p, ep.meta)?),
            TypedPrompt::Microphone(p) => {
                Self::Microphone(MicrophoneInterface::ui_input_from_prompt(p, ep.meta)?)
            }
        };

        Ok(typed_prompt)
    }
}

impl TryFrom<TypedUiInput> for ProtoPrompt {
    type Error = Status;

    fn try_from(ui_input: TypedUiInput) -> Result<Self, Status> {
        let proto = match ui_input {
            TypedUiInput::Camera(input) => CameraInterface::proto_prompt_from_ui_input(input)?,
            TypedUiInput::Home(input) => HomeInterface::proto_prompt_from_ui_input(input)?,
            TypedUiInput::Microphone(input) => {
                MicrophoneInterface::proto_prompt_from_ui_input(input)?
            }
        };

        Ok(proto)
    }
}

/// Generic-free counterpart to [PromptReply].
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(untagged)]
pub enum TypedPromptReply {
    Camera(PromptReply<CameraInterface>),
    Home(PromptReply<HomeInterface>),
    Microphone(PromptReply<MicrophoneInterface>),
}

impl TryFrom<ProtoPromptReply> for TypedPromptReply {
    type Error = Status;

    fn try_from(mut raw_reply: ProtoPromptReply) -> Result<Self, Status> {
        let data = raw_reply.prompt_reply.take().ok_or(Status::new(
            Code::InvalidArgument,
            "recieved empty prompt_reply",
        ))?;

        let reply = match data {
            ProtoConstraints::CameraPromptReply(r) => {
                let constraints = CameraInterface
                    .map_proto_reply_constraints(r)
                    .map_err(Status::internal)?;

                TypedPromptReply::Camera(PromptReply {
                    action: map_enum!(
                        apparmor_prompting::Action => snapd_client::Action;
                        [Allow, Deny];
                        raw_reply.action();
                    ),
                    lifespan: map_enum!(
                        apparmor_prompting::Lifespan => snapd_client::Lifespan;
                        [Single, Session, Forever];
                        raw_reply.lifespan();
                    ),
                    duration: None, // we don't currently use the Timespan variant for `lifespan`
                    constraints,
                })
            }
            ProtoConstraints::HomePromptReply(r) => {
                let constraints = HomeInterface
                    .map_proto_reply_constraints(r)
                    .map_err(Status::internal)?;

                TypedPromptReply::Home(PromptReply {
                    action: map_enum!(
                        apparmor_prompting::Action => snapd_client::Action;
                        [Allow, Deny];
                        raw_reply.action();
                    ),
                    lifespan: map_enum!(
                        apparmor_prompting::Lifespan => snapd_client::Lifespan;
                        [Single, Session, Forever];
                        raw_reply.lifespan();
                    ),
                    duration: None, // we don't currently use the Timespan variant for `lifespan`
                    constraints,
                })
            }
            ProtoConstraints::MicrophonePromptReply(r) => {
                let constraints = MicrophoneInterface
                    .map_proto_reply_constraints(r)
                    .map_err(Status::internal)?;

                TypedPromptReply::Microphone(PromptReply {
                    action: map_enum!(
                        apparmor_prompting::Action => snapd_client::Action;
                        [Allow, Deny];
                        raw_reply.action();
                    ),
                    lifespan: map_enum!(
                        apparmor_prompting::Lifespan => snapd_client::Lifespan;
                        [Single, Session, Forever];
                        raw_reply.lifespan();
                    ),
                    duration: None, // we don't currently use the Timespan variant for `lifespan`
                    constraints,
                })
            }
        };

        Ok(reply)
    }
}

impl From<PromptReply<CameraInterface>> for TypedPromptReply {
    fn from(value: PromptReply<CameraInterface>) -> Self {
        Self::Camera(value)
    }
}

impl From<PromptReply<HomeInterface>> for TypedPromptReply {
    fn from(value: PromptReply<HomeInterface>) -> Self {
        Self::Home(value)
    }
}

impl From<PromptReply<MicrophoneInterface>> for TypedPromptReply {
    fn from(value: PromptReply<MicrophoneInterface>) -> Self {
        Self::Microphone(value)
    }
}

impl TryFrom<TypedPrompt> for Prompt<CameraInterface> {
    type Error = Error;

    fn try_from(typed_prompt: TypedPrompt) -> Result<Self, Self::Error> {
        match typed_prompt {
            TypedPrompt::Camera(p) => Ok(p),
            _ => Err(Error::PromptConversionError {
                interface: CameraInterface::NAME.to_string(),
            }),
        }
    }
}

impl TryFrom<TypedPrompt> for Prompt<HomeInterface> {
    type Error = Error;

    fn try_from(typed_prompt: TypedPrompt) -> Result<Self, Self::Error> {
        match typed_prompt {
            TypedPrompt::Home(p) => Ok(p),
            _ => Err(Error::PromptConversionError {
                interface: HomeInterface::NAME.to_string(),
            }),
        }
    }
}

impl TryFrom<TypedPrompt> for Prompt<MicrophoneInterface> {
    type Error = Error;

    fn try_from(typed_prompt: TypedPrompt) -> Result<Self, Self::Error> {
        match typed_prompt {
            TypedPrompt::Microphone(p) => Ok(p),
            _ => Err(Error::PromptConversionError {
                interface: MicrophoneInterface::NAME.to_string(),
            }),
        }
    }
}
