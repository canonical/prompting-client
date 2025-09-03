// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get securityCenterInfo =>
      'You can always change these permissions in the <Security Center>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Set access for $snap to:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Give $snap $permission access to:';
  }

  @override
  String get promptActionOptionAllow => 'Allow';

  @override
  String get promptActionOptionAllowAlways => 'Allow always';

  @override
  String get promptActionOptionAllowOnce => 'Allow once';

  @override
  String get promptActionOptionDeny => 'Deny';

  @override
  String get promptActionOptionDenyOnce => 'Deny once';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Action';

  @override
  String get promptLifespanOptionForever => 'Always';

  @override
  String get promptLifespanOptionSession => 'Until logout';

  @override
  String get promptLifespanOptionSingle => 'Once';

  @override
  String get promptLifespanTitle => 'Duration';

  @override
  String get promptSaveAndContinue => 'Save and continue';

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
}
