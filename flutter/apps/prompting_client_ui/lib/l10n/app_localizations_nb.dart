// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

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
  String get promptActionOptionAllow => 'Tillat';

  @override
  String get promptActionOptionAllowAlways => 'Alltid tillat';

  @override
  String get promptActionOptionAllowOnce => 'Allow once';

  @override
  String get promptActionOptionDeny => 'Nekt';

  @override
  String get promptActionOptionDenyOnce => 'Nekt én gang';

  @override
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Handling';

  @override
  String get promptLifespanOptionForever => 'Alltid';

  @override
  String get promptLifespanOptionSession => 'Til utlogging';

  @override
  String get promptLifespanOptionSingle => 'Én gang';

  @override
  String get promptLifespanTitle => 'Varighet';

  @override
  String get promptSaveAndContinue => 'Lagre og fortsett';

  @override
  String get promptTitle => 'Security notification';

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
  String get homePatternTypeRequestedDirectory => 'The requested folder only';

  @override
  String get homePatternTypeRequestedFile => 'The requested file only';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Everything in the $topLevelDir folder';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Alt i mappen';

  @override
  String get homePatternTypeContainingDirectory => 'Alt i mappen';

  @override
  String get homePatternTypeHomeDirectory => 'Alt i hjemmemappen';

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
  String get homePromptMetaDataTitle => 'Om dette programmet';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Published by $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Last updated on $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Flere alternativer …';

  @override
  String get homePromptMoreOptionsTileLabel => 'More options';

  @override
  String get homePromptMetaDataAppCenterLink => 'Visit App Center page';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Also give $permission access';
  }

  @override
  String get homePromptPermissionsTitle => 'Tilganger';

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

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Give $snapName $permissions access to files?';
  }
}
