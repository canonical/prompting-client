use crate::{
    field_matches, map_enum,
    prompt_sequence::{MatchAttempt, MatchFailure},
    protos::{
        apparmor_prompting::{
            home_prompt::PatternOption, EnrichedPathKind as ProtoEnrichedPathKind, HomePatternType,
            HomePermission, HomePromptReply, MetaData,
        },
        HomePrompt as ProtoHomePrompt,
    },
    snapd_client::{
        interfaces::{
            ConstraintsFilter, Prompt, PromptReply, ProtoPrompt, ReplyConstraintsOverrides,
            SnapInterface,
        },
        prompt::UiInput,
        Action, Error, Lifespan, Result, SnapMeta,
    },
    util::serde_option_regex,
};
use regex::Regex;
use serde::{Deserialize, Serialize};
use std::{env, path::PathBuf};
use tonic::Status;

impl Prompt<HomeInterface> {
    pub fn path(&self) -> &str {
        &self.constraints.path
    }

    pub fn requested_permissions(&self) -> &[String] {
        &self.constraints.requested_permissions
    }
}

impl PromptReply<HomeInterface> {
    /// Specify a custom path pattern to replace the one originally requested in the parent [Prompt].
    ///
    /// If the path pattern provided is invalid or does not apply to the path originally requested
    /// in the parent prompt then submitting this reply will result in an error being returned by
    /// snapd.
    pub fn with_custom_path_pattern(mut self, path_pattern: impl Into<String>) -> Self {
        self.constraints.path_pattern = path_pattern.into();
        self
    }

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

/// The interface for allowing access to the user's home directory.
#[derive(Debug, Default, Clone, Deserialize, Serialize, PartialEq, Eq)]
pub struct HomeInterface;

struct PatternOptions {
    enriched_path_kind: EnrichedPathKind,
    initial_pattern_option: usize,
    pattern_options: Vec<TypedPathPattern>,
}

impl PatternOptions {
    /// Build out the UI Pattern options based on how we categorise the path that was requested in
    /// the prompt.
    ///
    /// Details of the cases and rationale behind how we handle this can be found here:
    ///   https://www.figma.com/board/1DIGbaCf4ZjTcShYjLiAIi/24.10-AppArmor-prompting---MVP-logic?node-id=0-1&t=4kUtDaqmQEvLA8v7-0
    fn new(path: &str, home_dir: &str) -> Self {
        let cpath = CategorisedPath::from_path(path, home_dir);
        let everything_in_home_pattern = TypedPathPattern::after_more_options(
            PatternType::HomeDirectory,
            format!("{home_dir}/**"),
        );

        let mut options = match cpath.kind {
            PathKind::HomeDir => vec![everything_in_home_pattern, cpath.requested_path_pattern()],

            PathKind::TopLevelDir => vec![
                everything_in_home_pattern,
                cpath.top_level_dir_pattern(),
                cpath.requested_path_pattern(),
            ],

            PathKind::SubDir => vec![
                everything_in_home_pattern,
                cpath.top_level_dir_pattern(),
                cpath.dir_contents_pattern(),
                cpath.requested_path_pattern(),
            ],

            PathKind::OutsideOfHomeDir => {
                vec![cpath.dir_contents_pattern(), cpath.requested_path_pattern()]
            }

            PathKind::HomeDirFile => {
                vec![everything_in_home_pattern, cpath.requested_path_pattern()]
            }

            PathKind::TopLevelDirFile => vec![
                everything_in_home_pattern,
                cpath.top_level_dir_pattern(),
                cpath.requested_path_pattern(),
            ],

            PathKind::SubDirFile => vec![
                everything_in_home_pattern,
                cpath.top_level_dir_pattern(),
                cpath.containing_dir_pattern(),
                cpath.requested_path_pattern(),
            ],

            PathKind::OutsideOfHomeFile => vec![
                cpath.containing_dir_pattern(),
                cpath.requested_path_pattern(),
            ],
        };

        let enriched_path_kind = match cpath.kind {
            PathKind::HomeDir => EnrichedPathKind::HomeDir,
            PathKind::TopLevelDir => EnrichedPathKind::TopLevelDir {
                dirname: cpath.get_top_level_dir(),
            },
            PathKind::SubDir | PathKind::OutsideOfHomeDir => EnrichedPathKind::SubDir,
            PathKind::HomeDirFile => EnrichedPathKind::HomeDirFile {
                filename: cpath.get_file_name(),
            },
            PathKind::TopLevelDirFile => EnrichedPathKind::TopLevelDirFile {
                dirname: cpath.get_top_level_dir(),
                filename: cpath.get_file_name(),
            },
            PathKind::SubDirFile | PathKind::OutsideOfHomeFile => EnrichedPathKind::SubDirFile,
        };

        if !cpath.is_dir {
            if let Some(opt) = cpath.matching_extension_pattern() {
                options.push(opt);
            }
        }

        Self {
            enriched_path_kind,
            initial_pattern_option: 1,
            pattern_options: options,
        }
    }
}

fn home_dir_from_env() -> String {
    env::var("SNAP_REAL_HOME").expect("to be running inside of a snap")
}

impl HomeInterface {
    fn ui_options(prompt: &Prompt<Self>) -> Result<PatternOptions> {
        let path = &prompt.constraints.path;
        Ok(PatternOptions::new(path, &home_dir_from_env()))
    }
}

impl SnapInterface for HomeInterface {
    const NAME: &'static str = "home";

    type Constraints = HomeConstraints;
    type ReplyConstraints = HomeReplyConstraints;

    type ConstraintsFilter = HomeConstraintsFilter;
    type ReplyConstraintsOverrides = HomeReplyConstraintsOverrides;

    type UiInputData = HomeUiInputData;
    type UiReplyConstraints = HomePromptReply;

    fn prompt_to_reply(prompt: Prompt<Self>, action: Action) -> PromptReply<Self> {
        PromptReply {
            action,
            lifespan: Lifespan::Single,
            duration: None,
            constraints: HomeReplyConstraints {
                path_pattern: prompt.constraints.path,
                permissions: prompt.constraints.requested_permissions,
                available_permissions: prompt.constraints.available_permissions,
            },
        }
    }

    fn ui_input_from_prompt(prompt: Prompt<Self>, meta: Option<SnapMeta>) -> Result<UiInput<Self>> {
        let PatternOptions {
            initial_pattern_option,
            pattern_options,
            enriched_path_kind,
        } = Self::ui_options(&prompt)?;
        let meta = meta.unwrap_or_else(|| SnapMeta {
            name: prompt.snap,
            updated_at: String::default(),
            store_url: String::default(),
            publisher: String::default(),
        });

        // We elevate the suggested permissions in the ui from write -> read/write in order to
        // minimise the number of prompts users encounter in the common case that an app wants to
        // interact with a file after writing it.
        let mut suggested_permissions = prompt.constraints.requested_permissions.clone();
        if prompt.constraints.is_only_write() {
            suggested_permissions.push("read".to_string());
        }

        Ok(UiInput {
            id: prompt.id,
            meta,
            data: HomeUiInputData {
                requested_path: prompt.constraints.path,
                home_dir: home_dir_from_env(),
                requested_permissions: prompt.constraints.requested_permissions.clone(),
                available_permissions: prompt.constraints.available_permissions,
                suggested_permissions,
                pattern_options,
                initial_pattern_option,
                enriched_path_kind,
            },
        })
    }

    fn proto_prompt_from_ui_input(input: UiInput<Self>) -> Result<ProtoPrompt, Status> {
        let SnapMeta {
            name,
            updated_at,
            store_url,
            publisher,
        } = input.meta;

        let HomeUiInputData {
            requested_path,
            home_dir,
            requested_permissions,
            available_permissions,
            suggested_permissions,
            initial_pattern_option,
            pattern_options,
            enriched_path_kind,
        } = input.data;

        Ok(ProtoPrompt::HomePrompt(ProtoHomePrompt {
            meta_data: Some(MetaData {
                prompt_id: input.id.0,
                snap_name: name,
                store_url,
                publisher,
                updated_at,
            }),
            requested_path,
            home_dir,
            requested_permissions: map_permissions(requested_permissions)?,
            suggested_permissions: map_permissions(suggested_permissions)?,
            available_permissions: map_permissions(available_permissions)?,
            initial_pattern_option: initial_pattern_option as i32,
            pattern_options: pattern_options
                .into_iter()
                .map(map_pattern_option)
                .collect(),
            enriched_path_kind: Some(enriched_path_kind.into()),
        }))
    }

    fn map_proto_reply_constraints(
        &self,
        raw_constraints: HomePromptReply,
    ) -> Result<HomeReplyConstraints, String> {
        let permissions = raw_constraints
            .permissions
            .into_iter()
            .map(|id| {
                let perm = HomePermission::try_from(id)
                    .map_err(|_| format!("unknown permission id: {id}"))?;
                let s = match perm {
                    HomePermission::Read => "read".to_owned(),
                    HomePermission::Write => "write".to_owned(),
                    HomePermission::Execute => "execute".to_owned(),
                };

                Ok(s)
            })
            .collect::<std::result::Result<Vec<_>, String>>()?;

        Ok(HomeReplyConstraints {
            path_pattern: raw_constraints.path_pattern,
            permissions,
            available_permissions: Vec::new(),
        })
    }
}

fn map_permission(perm: &str) -> Result<i32, Status> {
    match perm {
        "read" => Ok(HomePermission::Read as i32),
        "write" => Ok(HomePermission::Write as i32),
        "execute" => Ok(HomePermission::Execute as i32),
        _ => Err(Status::internal(format!(
            "invalid permission for home interface: {perm}"
        ))),
    }
}

fn map_permissions(perms: Vec<String>) -> Result<Vec<i32>, Status> {
    perms.iter().map(|s| map_permission(s)).collect()
}

fn map_pattern_option(
    TypedPathPattern {
        pattern_type,
        path_pattern,
        show_initially,
    }: TypedPathPattern,
) -> PatternOption {
    let home_pattern_type = map_enum!(
        PatternType => HomePatternType;
        [
            RequestedDirectory, RequestedFile, TopLevelDirectory,
            HomeDirectory, MatchingFileExtension, ContainingDirectory,
            RequestedDirectoryContents
        ];
        pattern_type;
    );

    PatternOption {
        home_pattern_type: home_pattern_type as i32,
        path_pattern,
        show_initially,
    }
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct HomeConstraints {
    pub(crate) path: String,
    pub(crate) requested_permissions: Vec<String>,
    pub(crate) available_permissions: Vec<String>,
}

impl HomeConstraints {
    fn is_only_write(&self) -> bool {
        self.requested_permissions.len() == 1 && self.requested_permissions[0] == "write"
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct HomeUiInputData {
    pub(crate) requested_path: String,
    pub(crate) home_dir: String,
    pub(crate) requested_permissions: Vec<String>,
    pub(crate) available_permissions: Vec<String>,
    pub(crate) suggested_permissions: Vec<String>,
    pub(crate) initial_pattern_option: usize,
    pub(crate) pattern_options: Vec<TypedPathPattern>,
    pub(crate) enriched_path_kind: EnrichedPathKind,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct TypedPathPattern {
    pub(crate) pattern_type: PatternType,
    pub(crate) path_pattern: String,
    pub(crate) show_initially: bool,
}

impl TypedPathPattern {
    fn new(
        pattern_type: PatternType,
        path_pattern: impl Into<String>,
        show_initially: bool,
    ) -> Self {
        Self {
            pattern_type,
            path_pattern: path_pattern.into(),
            show_initially,
        }
    }

    fn initial(pattern_type: PatternType, path_pattern: impl Into<String>) -> Self {
        Self::new(pattern_type, path_pattern, true)
    }

    fn after_more_options(pattern_type: PatternType, path_pattern: impl Into<String>) -> Self {
        Self::new(pattern_type, path_pattern, false)
    }
}

#[derive(Debug, Default, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct HomeReplyConstraints {
    pub(crate) path_pattern: String,
    pub(crate) permissions: Vec<String>,
    #[serde(skip)]
    pub(crate) available_permissions: Vec<String>,
}

#[derive(Debug, Default, Serialize, Deserialize, Clone)]
#[serde(rename_all = "kebab-case")]
pub struct HomeConstraintsFilter {
    #[serde(with = "serde_option_regex", default)]
    pub path: Option<Regex>,
    pub requested_permissions: Option<Vec<String>>,
    pub available_permissions: Option<Vec<String>>,
}

impl HomeConstraintsFilter {
    pub fn try_with_path(&mut self, path: impl Into<String>) -> Result<&mut Self> {
        let re = Regex::new(&path.into())?;
        self.path = Some(re);
        Ok(self)
    }

    pub fn with_requested_permissions(&mut self, permissions: Vec<impl Into<String>>) -> &mut Self {
        self.requested_permissions = Some(permissions.into_iter().map(|p| p.into()).collect());
        self
    }

    pub fn with_available_permissions(&mut self, permissions: Vec<impl Into<String>>) -> &mut Self {
        self.available_permissions = Some(permissions.into_iter().map(|p| p.into()).collect());
        self
    }
}

impl ConstraintsFilter for HomeConstraintsFilter {
    type Constraints = HomeConstraints;

    fn matches(&self, constraints: &Self::Constraints) -> MatchAttempt {
        let mut failures = Vec::new();

        if let Some(re) = &self.path {
            if !re.is_match(&constraints.path) {
                failures.push(MatchFailure {
                    field: "path",
                    expected: format!("{:?}", re.to_string()),
                    seen: format!("{:?}", constraints.path),
                });
            }
        }

        field_matches!(self, constraints, failures, requested_permissions);
        field_matches!(self, constraints, failures, available_permissions);

        if failures.is_empty() {
            MatchAttempt::Success
        } else {
            MatchAttempt::Failure(failures)
        }
    }
}

#[derive(Debug, Default, Serialize, Deserialize, Clone)]
#[serde(rename_all = "kebab-case")]
pub struct HomeReplyConstraintsOverrides {
    pub path_pattern: Option<String>,
    pub permissions: Option<Vec<String>>,
}

impl ReplyConstraintsOverrides for HomeReplyConstraintsOverrides {
    type ReplyConstraints = HomeReplyConstraints;

    fn apply(self, mut constraints: Self::ReplyConstraints) -> Self::ReplyConstraints {
        if let Some(path_pattern) = self.path_pattern {
            constraints.path_pattern = path_pattern;
        }
        if let Some(permissions) = self.permissions {
            constraints.permissions = permissions;
        }

        constraints
    }
}

/// PathKind's enriched with file names and directory names when needed for templating in the prompting UI.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub enum EnrichedPathKind {
    HomeDir,
    TopLevelDir { dirname: String },
    SubDir,
    HomeDirFile { filename: String },
    TopLevelDirFile { dirname: String, filename: String },
    SubDirFile,
}

impl From<EnrichedPathKind> for ProtoEnrichedPathKind {
    fn from(k: EnrichedPathKind) -> Self {
        use crate::protos::apparmor_prompting::{
            enriched_path_kind::Kind, HomeDir, HomeDirFile, SubDir, SubDirFile, TopLevelDir,
            TopLevelDirFile,
        };

        match k {
            EnrichedPathKind::HomeDir => Self {
                kind: Some(Kind::HomeDir(HomeDir {})),
            },
            EnrichedPathKind::TopLevelDir { dirname } => Self {
                kind: Some(Kind::TopLevelDir(TopLevelDir { dirname })),
            },
            EnrichedPathKind::SubDir => Self {
                kind: Some(Kind::SubDir(SubDir {})),
            },
            EnrichedPathKind::HomeDirFile { filename } => Self {
                kind: Some(Kind::HomeDirFile(HomeDirFile { filename })),
            },
            EnrichedPathKind::TopLevelDirFile { dirname, filename } => Self {
                kind: Some(Kind::TopLevelDirFile(TopLevelDirFile { dirname, filename })),
            },
            EnrichedPathKind::SubDirFile => Self {
                kind: Some(Kind::SubDirFile(SubDirFile {})),
            },
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum PathKind {
    HomeDir,
    TopLevelDir,
    SubDir,
    OutsideOfHomeDir,
    HomeDirFile,
    TopLevelDirFile,
    SubDirFile,
    OutsideOfHomeFile,
}

#[derive(Debug, Clone, PartialEq, Eq)]
struct CategorisedPath<'a> {
    kind: PathKind,
    raw_path: &'a str,
    home_dir: &'a str,
    path: PathBuf,
    is_dir: bool,
}

impl<'a> CategorisedPath<'a> {
    fn from_path(raw_path: &'a str, home_dir: &'a str) -> Self {
        use PathKind::*;

        let is_dir = raw_path.ends_with('/');
        let path = PathBuf::from(raw_path);
        let path = match path.strip_prefix(home_dir) {
            Ok(path) => path.to_path_buf(),
            Err(_) => {
                let kind = if is_dir {
                    OutsideOfHomeDir
                } else {
                    OutsideOfHomeFile
                };

                return Self {
                    kind,
                    raw_path,
                    home_dir,
                    path,
                    is_dir,
                };
            }
        };

        let n_segments = path.iter().count();
        let kind = match (is_dir, n_segments) {
            (true, 0) => HomeDir,
            (true, 1) => TopLevelDir,
            (true, _) => SubDir,
            (false, 1) => HomeDirFile,
            (false, 2) => TopLevelDirFile,
            (false, _) => SubDirFile,
        };

        Self {
            kind,
            raw_path,
            home_dir,
            path,
            is_dir,
        }
    }

    fn requested_path_pattern(&self) -> TypedPathPattern {
        let pattern_type = if self.is_dir {
            PatternType::RequestedDirectory
        } else {
            PatternType::RequestedFile
        };
        let show_initially = !matches!(self.kind, PathKind::HomeDir | PathKind::HomeDirFile);

        TypedPathPattern::new(pattern_type, self.raw_path, show_initially)
    }

    fn top_level_dir_pattern(&self) -> TypedPathPattern {
        let top_level: PathBuf = self.path.iter().take(1).collect();

        TypedPathPattern::initial(
            PatternType::TopLevelDirectory,
            format!("{}/{}/**", self.home_dir, top_level.to_string_lossy()),
        )
    }

    fn containing_dir_pattern(&self) -> TypedPathPattern {
        let mut segments: Vec<_> = self.path.iter().collect();
        segments.pop();
        let pb: PathBuf = segments.into_iter().collect();

        TypedPathPattern::initial(
            PatternType::ContainingDirectory,
            format!("{}/{}/**", self.home_dir, pb.to_string_lossy()),
        )
    }

    fn dir_contents_pattern(&self) -> TypedPathPattern {
        TypedPathPattern::initial(
            PatternType::RequestedDirectoryContents,
            format!("{}**", self.raw_path),
        )
    }

    fn matching_extension_pattern(&self) -> Option<TypedPathPattern> {
        debug_assert!(!self.is_dir);
        match self.path.extension() {
            Some(ext) => {
                let ext = ext.to_string_lossy();
                Some(TypedPathPattern::after_more_options(
                    PatternType::MatchingFileExtension,
                    format!("{}/**/*.{ext}", self.home_dir),
                ))
            }
            _ => None,
        }
    }

    fn get_top_level_dir(&self) -> String {
        let top_level: PathBuf = self.path.iter().take(1).collect();
        top_level.to_string_lossy().into_owned().to_string()
    }

    fn get_file_name(&self) -> String {
        let file: PathBuf = self.path.iter().next_back().into_iter().collect();
        file.to_string_lossy().into_owned().to_string()
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum PatternType {
    RequestedDirectory,
    RequestedFile,
    TopLevelDirectory,
    ContainingDirectory,
    HomeDirectory,
    MatchingFileExtension,
    RequestedDirectoryContents,
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::snapd_client::{RawPrompt, TypedPrompt};
    use simple_test_case::test_case;
    use PathKind::*;

    const HOME_PROMPT: &str = r#"{
      "id": "C7OUCCDWCE6CC===",
      "timestamp": "2024-06-28T19:15:37.321782305Z",
      "snap": "firefox",
      "pid": 1234,
      "cgroup": "/user.slice/user-1000.slice/user@1000.service/app.slice/myapp.scope",
      "interface": "home",
      "constraints": {
        "path": "/home/ubuntu/Downloads/",
        "requested-permissions": [
          "read"
        ],
        "available-permissions": [
          "read",
          "write",
          "execute"
        ]
      }
    }"#;

    #[test]
    fn deserializing_a_home_prompt_works() {
        let raw: RawPrompt = serde_json::from_str(HOME_PROMPT).unwrap();
        assert_eq!(raw.interface, "home");

        let p: TypedPrompt = raw.try_into().unwrap();
        assert!(matches!(p, TypedPrompt::Home(_)));
    }

    #[test_case(&["read"], &["read", "write"]; "some not in available")]
    #[test_case(&["read"], &["write"]; "none in available")]
    #[test]
    fn invalid_reply_permissions_error(available: &[&str], requested: &[&str]) {
        let reply = PromptReply {
            constraints: HomeReplyConstraints {
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

    #[test_case("/home/user"; "default home")]
    #[test_case("/mnt"; "non standard home short")]
    #[test_case("/non/standard/home/user"; "non standard home long")]
    #[test]
    fn top_level_dir_pattern_works(home_dir: &str) {
        let full_path = format!("{home_dir}/Documents/notes/");
        let cpath = CategorisedPath::from_path(&full_path, home_dir);
        let patt = cpath.top_level_dir_pattern();
        assert_eq!(patt.path_pattern, format!("{home_dir}/Documents/**"));
    }

    #[test_case("/home/user"; "default home")]
    #[test_case("/mnt"; "non standard home short")]
    #[test_case("/non/standard/home/user"; "non standard home long")]
    #[test]
    fn containing_dir_pattern_works(home_dir: &str) {
        let full_path = format!("{home_dir}/Documents/notes/todo.md");
        let cpath = CategorisedPath::from_path(&full_path, home_dir);
        let patt = cpath.containing_dir_pattern();
        assert_eq!(patt.path_pattern, format!("{home_dir}/Documents/notes/**"));
    }

    #[test_case("/home/user"; "default home")]
    #[test_case("/mnt"; "non standard home short")]
    #[test_case("/non/standard/home/user"; "non standard home long")]
    #[test]
    fn dir_contents_pattern_works(home_dir: &str) {
        let full_path = format!("{home_dir}/Documents/notes/");
        let cpath = CategorisedPath::from_path(&full_path, home_dir);
        let patt = cpath.dir_contents_pattern();
        assert_eq!(patt.path_pattern, format!("{full_path}**"));
    }

    #[test_case("/home/user"; "default home")]
    #[test_case("/mnt"; "non standard home short")]
    #[test_case("/non/standard/home/user"; "non standard home long")]
    #[test]
    fn matching_extension_pattern_works(home_dir: &str) {
        let full_path = format!("{home_dir}/Documents/notes/todo.md");
        let cpath = CategorisedPath::from_path(&full_path, home_dir);
        let patt = cpath.matching_extension_pattern().unwrap();
        assert_eq!(patt.path_pattern, format!("{home_dir}/**/*.md"));
    }

    #[test_case("", HomeDir; "home dir")]
    #[test_case("Documents/", TopLevelDir; "top level dir")]
    #[test_case("Documents/notes/", SubDir; "nested dir")]
    #[test_case("foo.txt", HomeDirFile; "top level file")]
    #[test_case("Documents/foo.txt", TopLevelDirFile; "file in top level dir")]
    #[test_case("Documents/foo/bar.txt", SubDirFile; "nested file")]
    #[test]
    fn kind_works(path: &str, expected: PathKind) {
        for home_dir in ["/home/user", "/mnt", "/non/standard/home/user"] {
            let full_path = format!("{home_dir}/{path}");
            let cpath = CategorisedPath::from_path(&full_path, home_dir);
            assert_eq!(cpath.kind, expected, "home is {home_dir}");
        }
    }

    #[test_case(
        "/home/user/Pictures/nested/foo.jpeg",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::TopLevelDirectory, true),
            (PatternType::ContainingDirectory, true),
            (PatternType::RequestedFile, true),
            (PatternType::MatchingFileExtension, false)
        ];
        "file in sub-folder"
    )]
    #[test_case(
        "/home/user/Pictures/nested/foo",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::TopLevelDirectory, true),
            (PatternType::ContainingDirectory, true),
            (PatternType::RequestedFile, true),
        ];
        "file in sub-folder without extension"
    )]
    #[test_case(
        "/home/user/Downloads/foo.jpeg",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::TopLevelDirectory, true),
            (PatternType::RequestedFile, true),
            (PatternType::MatchingFileExtension, false)
        ];
        "file in top level folder"
    )]
    #[test_case(
        "/home/user/Downloads/foo",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::TopLevelDirectory, true),
            (PatternType::RequestedFile, true),
        ];
        "file in top level folder without extension"
    )]
    #[test_case(
        "/home/user/bar.zip",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::RequestedFile, false),
            (PatternType::MatchingFileExtension, false)
        ];
        "file in home folder"
    )]
    #[test_case(
        "/home/user/bar",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::RequestedFile, false),
        ];
        "file in home folder without extension"
    )]
    #[test_case(
        "/home/user/Downloads/stuff/",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::TopLevelDirectory, true),
            (PatternType::RequestedDirectoryContents, true),
            (PatternType::RequestedDirectory, true),
        ];
        "sub folder"
    )]
    #[test_case(
        "/home/user/Downloads/",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::TopLevelDirectory, true),
            (PatternType::RequestedDirectory, true),
        ];
        "top level folder"
    )]
    #[test_case(
        "/home/user/",
        1,
        &[
            (PatternType::HomeDirectory, false),
            (PatternType::RequestedDirectory, false),
        ];
        "home folder"
    )]
    #[test_case(
        "/mnt/abcd/foo/",
        1,
        &[
            (PatternType::RequestedDirectoryContents, true),
            (PatternType::RequestedDirectory, true),
        ];
        "folder outside of home"
    )]
    #[test_case(
        "/mnt/abcd/foo/bar.txt",
        1,
        &[
            (PatternType::ContainingDirectory, true),
            (PatternType::RequestedFile, true),
            (PatternType::MatchingFileExtension, false)
        ];
        "file outside of home"
    )]
    #[test_case(
        "/mnt/abcd/foo/bar",
        1,
        &[
            (PatternType::ContainingDirectory, true),
            (PatternType::RequestedFile, true),
        ];
        "file outside of home without extension"
    )]
    #[test]
    fn building_options_works(
        path: &str,
        initial_pattern_option: usize,
        expected: &[(PatternType, bool)],
    ) {
        for (full_path, home_dir) in [
            (path, "/home/user"),
            (&format!("/non/standard{path}"), "/non/standard/home/user"),
        ] {
            let p = PatternOptions::new(full_path, home_dir);
            assert_eq!(
                p.initial_pattern_option, initial_pattern_option,
                "initial pattern option with home_dir={home_dir}"
            );

            let options: Vec<(PatternType, bool)> = p
                .pattern_options
                .iter()
                .map(|pd| (pd.pattern_type, pd.show_initially))
                .collect();

            assert_eq!(
                options, expected,
                "options with default home_dir={home_dir}"
            );
        }
    }
}
