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
  String get promptActionOptionDenyAlways => '常に拒否';

  @override
  String get promptActionOptionDenyUntilLogout => 'ログアウトまで拒否';

  @override
  String get promptActionOptionAllowUntilLogout => 'ログアウトまで許可';

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
  String get homeCustomPathSaveButton => 'Save custom path';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'The path pattern must start with /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Matches any string of characters except /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Matches a single character';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Matches zero or more folders and files recursively';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Matches either x or y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Escapes special characters to treat them as literals';

  @override
  String get homePatternTypeRequestedDirectory => '要求されたフォルダーのみ';

  @override
  String get homePatternTypeRequestedFile => '要求されたファイルのみ';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir フォルダー以下すべて';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Everything in the folder';

  @override
  String get homePatternTypeContainingDirectory => 'Everything in the folder';

  @override
  String get homePatternTypeHomeDirectory => 'ホームフォルダー以下すべて';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return '$fileExtension ファイルすべて';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap が $path の $permissions アクセス権を求めています';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap が $foldername フォルダーの $permissions アクセス権を求めています。';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap が $foldername フォルダーにある $filename の $permissions アクセス権を求めています。';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap がホームフォルダーの $permissions アクセス権を求めています。';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap がホームフォルダーにある $filename の $permissions アクセス権を求めています。';
  }

  @override
  String get homePromptMetaDataTitle => 'このアプリについて';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return '$publisher によって公開';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'この発行者には ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => '認証済みアカウント';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '。';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return '最終更新日: $date';
  }

  @override
  String get homePromptMoreOptionsLabel => '詳細オプション...';

  @override
  String get homePromptMoreOptionsTileLabel => '詳細オプション';

  @override
  String get homePromptMetaDataAppCenterLink => 'アプリセンターのページを開く';

  @override
  String get homePromptMetaDataAppCenterButton => 'アプリセンターで開く';

  @override
  String homePromptSuggestedPermission(String permission) {
    return '$permissionアクセス権も与える';
  }

  @override
  String get homePromptPermissionsTitle => 'パーミッション';

  @override
  String get homePromptPermissionsRead => '読み取り';

  @override
  String get homePromptPermissionsReadOnly => '読み取りのみ';

  @override
  String get homePromptPermissionsWrite => '書き込み';

  @override
  String get homePromptPermissionsWriteOnly => '書き込みのみ';

  @override
  String get homePromptPermissionsExecute => '実行';

  @override
  String get homePromptPermissionsExecuteOnly => '実行のみ';

  @override
  String get homePromptErrorUnknownTitle => '問題が発生しました';

  @override
  String cameraPromptBody(String snapName) {
    return '$snapName にカメラの使用を許可しますか？';
  }

  @override
  String microphonePromptBody(String snapName) {
    return '$snapName にマイクの使用を許可しますか？';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return '$snapName にファイルの$permissionsを許可しますか？';
  }
}
