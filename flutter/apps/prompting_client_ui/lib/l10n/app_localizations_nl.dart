// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Je kunt deze machtigingen altijd wijzigen in het <Beveiligingscentrum>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Toegang voor $snap instellen op:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Geef $snap $permission toegang tot:';
  }

  @override
  String get promptActionOptionAllow => 'Toestaan';

  @override
  String get promptActionOptionAllowAlways => 'Altijd toestaan';

  @override
  String get promptActionOptionAllowOnce => 'Eenmaal toestaan';

  @override
  String get promptActionOptionDeny => 'Weigeren';

  @override
  String get promptActionOptionDenyOnce => 'Eenmaal weigeren';

  @override
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Actie';

  @override
  String get promptLifespanOptionForever => 'Altijd';

  @override
  String get promptLifespanOptionSession => 'Tot afmelding';

  @override
  String get promptLifespanOptionSingle => 'Eenmaal';

  @override
  String get promptLifespanTitle => 'Duur';

  @override
  String get promptSaveAndContinue => 'Opslaan en verdergaan';

  @override
  String get promptTitle => 'Beveiligingsmededeling';

  @override
  String get homePatternInfo => '<Meer informatie over padpatronen>';

  @override
  String get homePatternTypeCustomPath => 'Aangepast padpatroon';

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
  String get homePatternTypeRequestedDirectory => 'Alleen de gevraagde map';

  @override
  String get homePatternTypeRequestedFile => 'Alleen het gevraagde bestand';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Alles in de map $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Alles in de map';

  @override
  String get homePatternTypeContainingDirectory => 'Alles in de map';

  @override
  String get homePatternTypeHomeDirectory => 'Alles in de thuismap';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Alle $fileExtension-bestanden';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap wil $permissions toegang krijgen tot $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap wil $permissions toegang krijgen tot de map $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap wil $permissions toegang krijgen tot $filename in de map $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap wil $permissions toegang krijgen tot jouw thuismap.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap wil $permissions toegang krijgen tot $filename in jouw thuismap.';
  }

  @override
  String get homePromptMetaDataTitle => 'Over deze app';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Uitgegeven door $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'This publisher has a ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verified account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Laatst bijgewerkt op $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Meer opties…';

  @override
  String get homePromptMoreOptionsTileLabel => 'More options';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Pagina met App-centrale bezoeken';

  @override
  String get homePromptMetaDataAppCenterButton => 'Open in App Center';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Geef ook $permission toegang';
  }

  @override
  String get homePromptPermissionsTitle => 'Machtigingen';

  @override
  String get homePromptPermissionsRead => 'Lezen';

  @override
  String get homePromptPermissionsWrite => 'Schrijven';

  @override
  String get homePromptPermissionsExecute => 'Uitvoeren';

  @override
  String get homePromptErrorUnknownTitle => 'Er is iets misgegaan';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to use your cameras?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to use your microphones?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Give $snapName $permissions access to files?';
  }
}
