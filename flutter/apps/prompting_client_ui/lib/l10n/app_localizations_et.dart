// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Sa võid alati neid õigusi muuta <Andmeturbekeskuses>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Luba „$snap“ paketile ligipääs:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Anna „$snap“ paketile „$permission“ õigus asukohas:';
  }

  @override
  String get promptActionOptionAllow => 'Luba';

  @override
  String get promptActionOptionAllowAlways => 'Luba alati';

  @override
  String get promptActionOptionAllowOnce => 'Luba üks kord';

  @override
  String get promptActionOptionDeny => 'Keela';

  @override
  String get promptActionOptionDenyOnce => 'Keela üks kord';

  @override
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Tegevus';

  @override
  String get promptLifespanOptionForever => 'Alatiseks';

  @override
  String get promptLifespanOptionSession => 'Kuni väljalogimiseni';

  @override
  String get promptLifespanOptionSingle => 'Vaid üheks korraks';

  @override
  String get promptLifespanTitle => 'Kestus';

  @override
  String get promptSaveAndContinue => 'Salvesta ja jätka';

  @override
  String get promptTitle => 'Andmeturbeteade';

  @override
  String get homePatternInfo => '<Lisateave mustrite kohta>';

  @override
  String get homePatternTypeCustomPath => 'Sinu kirjeldatud asukohamuster';

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
  String get homePatternTypeRequestedDirectory => 'Valid soovitud kaustas';

  @override
  String get homePatternTypeRequestedFile => 'Vaid soovitud faili osas';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Kõik „$topLevelDir“ kaustas';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Kõik kaustas';

  @override
  String get homePatternTypeContainingDirectory => 'Kõik kaustas';

  @override
  String get homePatternTypeHomeDirectory => 'Kõik kodukaustas';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Kõik $fileExtension-tüüpi failid';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '„$snap“ pakett soovib „$permissions“ õigusi asukohas „$path“';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '„$snap“ pakett soovib „$permissions“ õigusi kaustas „$foldername“.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '„$snap“ pakett soovib „$permissions“ õigusi ligipääsuks „$filename“ failile „$foldername“ kaustas.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '„$snap“ pakett soovib „$permissions“ õigusi sinu kodukaustas.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '„$snap“ pakett soovib „$permissions“ õigusi ligipääsuks „$filename“ failile sinu kodukaustas.';
  }

  @override
  String get homePromptMetaDataTitle => 'Selle rakenduse teave';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Avaldaja: $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'This publisher has a ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verified account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Viimati uuendatud: $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Lisavalikud...';

  @override
  String get homePromptMoreOptionsTileLabel => 'More options';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Vaata andmeid Rakendustekeskuses';

  @override
  String get homePromptMetaDataAppCenterButton => 'Open in App Center';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Luba ka „$permission“ õigused';
  }

  @override
  String get homePromptPermissionsTitle => 'Õigused';

  @override
  String get homePromptPermissionsRead => 'Lugemine';

  @override
  String get homePromptPermissionsWrite => 'Kirjutamine';

  @override
  String get homePromptPermissionsExecute => 'Käivitamine';

  @override
  String get homePromptErrorUnknownTitle => 'Midagi läks valesti';

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
