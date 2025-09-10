// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get securityCenterInfo =>
      'You can always change these permissions in the <Security Center>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Leisti $snap prieiti prie:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Give $snap $permission access to:';
  }

  @override
  String get promptActionOptionAllow => 'Leisti';

  @override
  String get promptActionOptionAllowAlways => 'Visada leisti';

  @override
  String get promptActionOptionAllowOnce => 'Leisti tik šįkart';

  @override
  String get promptActionOptionDeny => 'Drausti';

  @override
  String get promptActionOptionDenyOnce => 'Drausti tik šįkart';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Veiksmas';

  @override
  String get promptLifespanOptionForever => 'Visada';

  @override
  String get promptLifespanOptionSession => 'Until logout';

  @override
  String get promptLifespanOptionSingle => 'Šį kartą';

  @override
  String get promptLifespanTitle => 'Trukmė';

  @override
  String get promptSaveAndContinue => 'Įrašyti ir tęsti';

  @override
  String get promptTitle => 'Security notification';

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
  String get homePromptMetaDataTitle => 'About this app';

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
  String get homePromptPermissionsTitle => 'Permissions';

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
}
