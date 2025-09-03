// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get securityCenterInfo => 'Du kan altid ændre disse rettigheder i <Sikkerhedscenteret>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Angiv adgang for $snap til:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Giv $snap $permission-adgang til:';
  }

  @override
  String get promptActionOptionAllow => 'Tillad';

  @override
  String get promptActionOptionAllowAlways => 'Tillad altid';

  @override
  String get promptActionOptionAllowOnce => 'Tillad én gang';

  @override
  String get promptActionOptionDeny => 'Nægt';

  @override
  String get promptActionOptionDenyOnce => 'Nægt denne gang';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Handling';

  @override
  String get promptLifespanOptionForever => 'Altid';

  @override
  String get promptLifespanOptionSession => 'Indtil der logges ud';

  @override
  String get promptLifespanOptionSingle => 'Én gang';

  @override
  String get promptLifespanTitle => 'Varighed';

  @override
  String get promptSaveAndContinue => 'Gem og fortsæt';

  @override
  String get promptTitle => 'Sikkerhedsunderretning';

  @override
  String get homePatternInfo => '<Læs om stimønstre>';

  @override
  String get homePatternTypeCustomPath => 'Tilpasset stimønster';

  @override
  String get homePatternTypeRequestedDirectory => 'Kun den ønskede mappe';

  @override
  String get homePatternTypeRequestedFile => 'Kun den ønskede fil';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Alt i $topLevelDir-mappen';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Alt i mappen';

  @override
  String get homePatternTypeContainingDirectory => 'Alt i mappen';

  @override
  String get homePatternTypeHomeDirectory => 'Alt i hjemmemappen';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Alle $fileExtension-filer';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap wants to get $permissions access to $path';
  }

  @override
  String homePromptTopLevelDirBody(String snap, String permissions, String foldername) {
    return '$snap wants to get $permissions access to the $foldername folder.';
  }

  @override
  String homePromptTopLevelDirFileBody(String snap, String permissions, String filename, String foldername) {
    return '$snap wants to get $permissions access to $filename in the $foldername folder.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap wants to get $permissions access to your Home folder.';
  }

  @override
  String homePromptHomeDirFileBody(String snap, String permissions, String filename) {
    return '$snap wants to get $permissions access to $filename in your Home folder.';
  }

  @override
  String get homePromptMetaDataTitle => 'Om dette program';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Udgivet af $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Senest opdateret $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Flere muligheder …';

  @override
  String get homePromptMetaDataAppCenterLink => 'Besøg Appcenter-siden';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Giv også $permission-adgang';
  }

  @override
  String get homePromptPermissionsTitle => 'Rettigheder';

  @override
  String get homePromptPermissionsRead => 'Læse';

  @override
  String get homePromptPermissionsWrite => 'Skrive';

  @override
  String get homePromptPermissionsExecute => 'Kørsel';

  @override
  String get homePromptErrorUnknownTitle => 'Something went wrong';
}
