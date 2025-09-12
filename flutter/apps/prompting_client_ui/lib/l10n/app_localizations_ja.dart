// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get securityCenterInfo => 'これらのパーミッションは<セキュリティセンター>でいつでも変更できます';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return '$snap にアクセス権を設定:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '$snap に $permission アクセス権を設定:';
  }

  @override
  String get promptActionOptionAllow => '許可';

  @override
  String get promptActionOptionAllowAlways => '常に許可';

  @override
  String get promptActionOptionAllowOnce => '一度だけ許可';

  @override
  String get promptActionOptionDeny => '拒否';

  @override
  String get promptActionOptionDenyOnce => '一度だけ拒否';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'アクション';

  @override
  String get promptLifespanOptionForever => '常に';

  @override
  String get promptLifespanOptionSession => 'ログアウトまで';

  @override
  String get promptLifespanOptionSingle => '一度だけ';

  @override
  String get promptLifespanTitle => '期間';

  @override
  String get promptSaveAndContinue => '保存して続ける';

  @override
  String get promptTitle => 'セキュリティ通知';

  @override
  String get homePatternInfo => '<Learn about path patterns>';

  @override
  String get homePatternTypeCustomPath => 'Custom path pattern';

  @override
  String get homePatternTypeRequestedDirectory => 'The requested folder only';

  @override
  String get homePatternTypeRequestedFile => 'The requested file only';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Everything in the $topLevelDir folder';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Everything in the folder';

  @override
  String get homePatternTypeContainingDirectory => 'Everything in the folder';

  @override
  String get homePatternTypeHomeDirectory => 'Everything in the Home folder';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'All $fileExtension files';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap wants to get $permissions access to $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap wants to get $permissions access to the $foldername folder.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap wants to get $permissions access to $filename in the $foldername folder.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap wants to get $permissions access to your Home folder.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap wants to get $permissions access to $filename in your Home folder.';
  }

  @override
  String get homePromptMetaDataTitle => 'このアプリについて';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Published by $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Last updated on $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'More options...';

  @override
  String get homePromptMetaDataAppCenterLink => 'Visit App Center page';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Also give $permission access';
  }

  @override
  String get homePromptPermissionsTitle => 'パーミッション';

  @override
  String get homePromptPermissionsRead => 'Read';

  @override
  String get homePromptPermissionsWrite => 'Write';

  @override
  String get homePromptPermissionsExecute => 'Execute';

  @override
  String get homePromptErrorUnknownTitle => 'Something went wrong';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to access your microphone?';
  }
}
