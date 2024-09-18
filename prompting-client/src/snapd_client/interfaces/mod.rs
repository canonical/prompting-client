//! Each snapd interface is handled slightly differently in terms of how we handle processing
//! prompts for it and how we generate the UI for the user.
use crate::{
    prompt_sequence::MatchAttempt,
    snapd_client::{Action, Prompt, PromptReply},
    Result,
};
use serde::{de::DeserializeOwned, Serialize};
use std::fmt;

use super::{prompt::UiInput, SnapMeta};

pub mod home;

#[allow(async_fn_in_trait)]
pub trait SnapInterface: fmt::Debug + Clone {
    const NAME: &'static str;

    type Constraints: fmt::Debug + Clone + Serialize + DeserializeOwned;
    type ReplyConstraints: fmt::Debug + Clone + Serialize + DeserializeOwned;

    type ConstraintsFilter: ConstraintsFilter<Constraints = Self::Constraints>;
    type ReplyConstraintsOverrides: ReplyConstraintsOverrides<
        ReplyConstraints = Self::ReplyConstraints,
    >;

    type UiInputData: fmt::Debug + Clone + Serialize + DeserializeOwned;
    type UiReply: fmt::Debug + Clone + Serialize + DeserializeOwned;

    fn prompt_to_reply(prompt: Prompt<Self>, action: Action) -> PromptReply<Self>;

    fn map_ui_input(&self, prompt: Prompt<Self>, meta: Option<SnapMeta>) -> Result<UiInput<Self>>;

    fn map_ui_reply(&self, reply: Self::UiReply) -> PromptReply<Self>;
}

pub trait ConstraintsFilter: Default + fmt::Debug + Clone + Serialize + DeserializeOwned {
    type Constraints: fmt::Debug + Clone + Serialize + DeserializeOwned;

    fn matches(&self, constraints: &Self::Constraints) -> MatchAttempt;
}

pub trait ReplyConstraintsOverrides:
    Default + fmt::Debug + Clone + Serialize + DeserializeOwned
{
    type ReplyConstraints: fmt::Debug + Clone + Serialize + DeserializeOwned;

    fn apply(self, constraints: Self::ReplyConstraints) -> Self::ReplyConstraints;
}
