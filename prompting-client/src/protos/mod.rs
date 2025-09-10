#[rustfmt::skip]
pub mod apparmor_prompting;

pub use apparmor_prompting::{
    app_armor_prompting_server::{AppArmorPrompting, AppArmorPromptingServer},
    get_current_prompt_response::Prompt,
    CameraPrompt, GetCurrentPromptResponse, HomePatternType, HomePrompt, PromptReply,
    PromptReplyResponse, ResolveHomePatternTypeResponse,
};
