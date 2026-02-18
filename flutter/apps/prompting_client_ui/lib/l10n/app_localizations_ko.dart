// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get securityCenterInfo => '부여한 권한은 언재든지 <보안 센터>에서 변경할 수 있습니다';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return '$snap 에 대한 권한 설정:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '$snap $permission에 대한 접근 권한 부여:';
  }

  @override
  String get promptActionOptionAllow => '허용';

  @override
  String get promptActionOptionAllowAlways => '항상 허용';

  @override
  String get promptActionOptionAllowOnce => '이번에만 허용';

  @override
  String get promptActionOptionDeny => '거부';

  @override
  String get promptActionOptionDenyOnce => '이번에만 거부';

  @override
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => '동작';

  @override
  String get promptLifespanOptionForever => '항상';

  @override
  String get promptLifespanOptionSession => '로그아웃하기 전까지';

  @override
  String get promptLifespanOptionSingle => '한 번만';

  @override
  String get promptLifespanTitle => '지속 시간';

  @override
  String get promptSaveAndContinue => '저장하고 계속하기';

  @override
  String get promptTitle => '보안 알림';

  @override
  String get homePatternInfo => '<경로 패턴에 대해 알아보기>';

  @override
  String get homePatternTypeCustomPath => '사용자 정의 경로 패턴';

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
  String get homePatternTypeRequestedDirectory => '요청한 폴더만';

  @override
  String get homePatternTypeRequestedFile => '요청한 파일만';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir 폴더 내 모든 것';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => '폴더 내 모든 것';

  @override
  String get homePatternTypeContainingDirectory => '폴더 내 모든 것';

  @override
  String get homePatternTypeHomeDirectory => '홈 폴더 내 모든 것';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return '모든 $fileExtension 파일';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap이 $path에 대한 $permissions 접근 권한을 요청합니다';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap이(가) $foldername 폴더에 대한 $permissions 접근 권한을 요청합니다.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap이 $foldername 폴더의 $filename에 대한 $permissions 접근 권한을 요청합니다.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap이 홈 폴더에 대한 $permissions 접근 권한을 요청합니다.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap이 홈 폴더의 $filename에 대한 $permissions 접근 권한을 요청합니다.';
  }

  @override
  String get homePromptMetaDataTitle => '이 앱 정보';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return '$publisher에서 배포함';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return '마지막으로 $date에 업데이트됨';
  }

  @override
  String get homePromptMoreOptionsLabel => '추가 옵션...';

  @override
  String get homePromptMoreOptionsTileLabel => 'More options';

  @override
  String get homePromptMetaDataAppCenterLink => 'App Center 페이지 방문';

  @override
  String homePromptSuggestedPermission(String permission) {
    return '$permission 접근 권한도 부여';
  }

  @override
  String get homePromptPermissionsTitle => '권한';

  @override
  String get homePromptPermissionsRead => '읽기';

  @override
  String get homePromptPermissionsWrite => '쓰기';

  @override
  String get homePromptPermissionsExecute => '실행';

  @override
  String get homePromptErrorUnknownTitle => '문제가 발생했습니다';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to access your microphone?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Give $snapName $permissions access to files?';
  }
}
