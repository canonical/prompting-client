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
  String get promptActionOptionDenyAlways => 'Altijd afwijzen';

  @override
  String get promptActionOptionDenyUntilLogout => 'Afwijzen tot uitloggen';

  @override
  String get promptActionOptionAllowUntilLogout => 'Toestaan tot uitloggen';

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
  String get homeCustomPathSaveButton => 'Aangepast pad opslaan';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Het padpatroon moet met een / beginnen';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Komt overeen met elke reeks tekens, behalve /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Komt overeen met één enkel teken';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Komt recursief overeen met nul of meer mappen en bestanden';

  @override
  String get homeCustomPathWildcardCurlyDescription =>
      'Komt overeen met x of y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Ontsnapt speciale tekens om hen als normale tekens te beschouwen';

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
    return '$snap wil $permissions toegang krijgen tot uw thuismap.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap wil $permissions toegang krijgen tot $filename in uw thuismap.';
  }

  @override
  String get homePromptMetaDataTitle => 'Over deze app';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Uitgegeven door $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix =>
      'Deze ontwikkelaar heeft een ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'Geverifieerd account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Laatst bijgewerkt op $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Meer opties…';

  @override
  String get homePromptMoreOptionsTileLabel => 'Meer opties';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Pagina met App-centrale bezoeken';

  @override
  String get homePromptMetaDataAppCenterButton => 'Openen in Appcentrum';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Geef ook $permission toegang';
  }

  @override
  String get homePromptPermissionsTitle => 'Machtigingen';

  @override
  String get homePromptPermissionsRead => 'Lezen';

  @override
  String get homePromptPermissionsReadOnly => 'Enkel te lezen';

  @override
  String get homePromptPermissionsWrite => 'Schrijven';

  @override
  String get homePromptPermissionsWriteOnly => 'Enkel naar te schrijven';

  @override
  String get homePromptPermissionsExecute => 'Uitvoeren';

  @override
  String get homePromptPermissionsExecuteOnly => 'Enkel uit te voeren';

  @override
  String get homePromptErrorUnknownTitle => 'Er is iets misgegaan';

  @override
  String cameraPromptBody(String snapName) {
    return 'Toestaan dat $snapName toegang krijgt tot uw camera\'s?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Toestaan dat $snapName toegang krijgt tot uw microfonen?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Toestaan dat $snapName $permissions toegang krijgt tot bestanden?';
  }
}
