// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get securityCenterInfo =>
      'ನೀವು ಯಾವಾಗಲೂ ಈ ಅನುಮತಿಗಳನ್ನು <ಭದ್ರತಾ ಕೇಂದ್ರ> ದಲ್ಲಿ ಬದಲಾಯಿಸಬಹುದು';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return '$snap ಗೆ ಪ್ರವೇಶವನ್ನು ಹೊಂದಿಸಿ:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'ಇದಕ್ಕೆ $snap $permission ಪ್ರವೇಶವನ್ನು ನೀಡಿ:';
  }

  @override
  String get promptActionOptionAllow => 'ಅನುಮತಿಸಿ';

  @override
  String get promptActionOptionAllowAlways => 'ಯಾವಾಗಲೂ ಅನುಮತಿಸಿ';

  @override
  String get promptActionOptionAllowOnce => 'ಒಮ್ಮೆ ಅನುಮತಿಸಿ';

  @override
  String get promptActionOptionDeny => 'ನಿರಾಕರಿಸು';

  @override
  String get promptActionOptionDenyOnce => 'ಒಮ್ಮೆ ನಿರಾಕರಿಸಿ';

  @override
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'ಲಾಗ್‌ಔಟ್ ಆಗುವವರೆಗೆ ಅನುಮತಿಸಿ';

  @override
  String get promptActionTitle => 'ಕ್ರಿಯೆ';

  @override
  String get promptLifespanOptionForever => 'ಯಾವಾಗಲೂ';

  @override
  String get promptLifespanOptionSession => 'ಲಾಗ್‌ಔಟ್ ಆಗುವವರೆಗೆ';

  @override
  String get promptLifespanOptionSingle => 'ಒಮ್ಮೆ';

  @override
  String get promptLifespanTitle => 'ಅವಧಿ';

  @override
  String get promptSaveAndContinue => 'ಉಳಿಸಿ ಮತ್ತು ಮುಂದುವರಿಸಿ';

  @override
  String get promptTitle => 'ಭದ್ರತಾ ಅಧಿಸೂಚನೆ';

  @override
  String get homePatternInfo => '<ಮಾರ್ಗದ ಮಾದರಿಗಳ ಬಗ್ಗೆ ತಿಳಿಯಿರಿ>';

  @override
  String get homePatternTypeCustomPath => 'ಕಸ್ಟಮ್ ಮಾರ್ಗದ ಮಾದರಿ';

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
  String get homePatternTypeRequestedDirectory => 'ವಿನಂತಿಸಿದ ಫೋಲ್ಡರ್ ಮಾತ್ರ';

  @override
  String get homePatternTypeRequestedFile => 'ವಿನಂತಿಸಿದ ಫೈಲ್ ಮಾತ್ರ';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir ಫೋಲ್ಡರ್‌ನಲ್ಲಿರುವ ಎಲ್ಲವೂ';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'ಫೋಲ್ಡರ್‌ನಲ್ಲಿರುವ ಎಲ್ಲವೂ';

  @override
  String get homePatternTypeContainingDirectory => 'ಫೋಲ್ಡರ್‌ನಲ್ಲಿರುವ ಎಲ್ಲವೂ';

  @override
  String get homePatternTypeHomeDirectory => 'ಹೋಮ್ ಫೋಲ್ಡರ್‌ನಲ್ಲಿರುವ ಎಲ್ಲವೂ';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'ಎಲ್ಲಾ $fileExtension ಫೈಲ್‌ಗಳು';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap $path ಗೆ $permissions ಪ್ರವೇಶವನ್ನು ಪಡೆಯಲು ಬಯಸುತ್ತದೆ';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$foldername ಫೋಲ್ಡರ್‌ಗೆ $permissions ಪ್ರವೇಶವನ್ನು ಪಡೆಯಲು $snap ಬಯಸುತ್ತದೆ.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$foldername ಫೋಲ್ಡರ್‌ನಲ್ಲಿ $filename ಗೆ $permissions ಪ್ರವೇಶವನ್ನು ಪಡೆಯಲು $snap ಬಯಸುತ್ತದೆ.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return 'ನಿಮ್ಮ ಹೋಮ್ ಫೋಲ್ಡರ್‌ಗೆ $permissions ಪ್ರವೇಶವನ್ನು ಪಡೆಯಲು $snap ಬಯಸುತ್ತದೆ.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return 'ನಿಮ್ಮ ಹೋಮ್ ಫೋಲ್ಡರ್‌ನಲ್ಲಿ $filename ಗೆ $permissions ಪ್ರವೇಶವನ್ನು ಪಡೆಯಲು $snap ಬಯಸುತ್ತದೆ.';
  }

  @override
  String get homePromptMetaDataTitle => 'ಈ ಅಪ್ಲಿಕೇಶನ್ ಬಗ್ಗೆ';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'ಪ್ರಕಟಿಸಿದವರು $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'This publisher has a ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verified account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return '$date ರಂದು ಕೊನೆಯದಾಗಿ ನವೀಕರಿಸಲಾಗಿದೆ';
  }

  @override
  String get homePromptMoreOptionsLabel => 'ಹೆಚ್ಚಿನ ಆಯ್ಕೆಗಳು...';

  @override
  String get homePromptMoreOptionsTileLabel => 'More options';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'ಅಪ್ಲಿಕೇಶನ್ ಕೇಂದ್ರ ಪುಟಕ್ಕೆ ಭೇಟಿ ನೀಡಿ';

  @override
  String get homePromptMetaDataAppCenterButton => 'Open in App Center';

  @override
  String homePromptSuggestedPermission(String permission) {
    return '$permission ಪ್ರವೇಶವನ್ನು ಸಹ ನೀಡಿ';
  }

  @override
  String get homePromptPermissionsTitle => 'ಅನುಮತಿಗಳು';

  @override
  String get homePromptPermissionsRead => 'ಓದು';

  @override
  String get homePromptPermissionsReadOnly => 'Read only';

  @override
  String get homePromptPermissionsWrite => 'ಬರೆಯಿರಿ';

  @override
  String get homePromptPermissionsWriteOnly => 'Write only';

  @override
  String get homePromptPermissionsExecute => 'ಕಾರ್ಯಗತಗೊಳಿಸಿ';

  @override
  String get homePromptPermissionsExecuteOnly => 'Execute only';

  @override
  String get homePromptErrorUnknownTitle => 'ಏನೋ ತಪ್ಪಾಗಿದೆ';

  @override
  String cameraPromptBody(String snapName) {
    return 'ನಿಮ್ಮ ಕ್ಯಾಮರಾವನ್ನು ಪ್ರವೇಶಿಸಲು $snapName ಗೆ ಅನುಮತಿಸುವುದೇ?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'ನಿಮ್ಮ ಮೈಕ್ರೋಫೋನ್ ಅನ್ನು ಪ್ರವೇಶಿಸಲು $snapName ಗೆ ಅನುಮತಿಸುವುದೇ?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Give $snapName $permissions access to files?';
  }
}
