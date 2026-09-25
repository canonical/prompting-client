// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Šiuos leidimus bet kada galite pakeisti <Saugumo Centre>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Leisti $snap prieiti prie:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Suteikti $snap leidimą $permission prie:';
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
  String get promptActionOptionDenyAlways => 'Drausti visada';

  @override
  String get promptActionOptionDenyUntilLogout =>
      'Drausti kol esate prisijungęs';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Leisti kol esate prisijungęs';

  @override
  String get promptActionTitle => 'Veiksmas';

  @override
  String get promptLifespanOptionForever => 'Visada';

  @override
  String get promptLifespanOptionSession => 'Iki atsijungimo';

  @override
  String get promptLifespanOptionSingle => 'Šį kartą';

  @override
  String get promptLifespanTitle => 'Trukmė';

  @override
  String get promptSaveAndContinue => 'Įrašyti ir tęsti';

  @override
  String get promptTitle => 'Saugos pranešimas';

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
  String get homePatternTypeRequestedDirectory => 'Tik nurodytą aplanką';

  @override
  String get homePatternTypeRequestedFile => 'Tik nurodytą failą';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Viską $topLevelDir aplanke';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Viską aplanke';

  @override
  String get homePatternTypeContainingDirectory => 'Viską aplanke';

  @override
  String get homePatternTypeHomeDirectory => 'Viską asmeniniame (Home) aplanke';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Visus $fileExtension failus';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap prašo $permissions prieigos prie $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap prašo $permissions prieigos prie aplanko $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap“ prašo $permissions prieigos prie failo $filename esančio aplanke $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap prašo $permissions prieigos prie jūsų Asmeninio (Home) aplanko.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap“ prašo $permissions prieigos prie failo $filename jūsų Asmeniniame (Home) aplanke.';
  }

  @override
  String get homePromptMetaDataTitle => 'Apie šią programą';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Published by $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'This publisher has a ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verified account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Last updated on $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Daugiau pasirinkimų...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Daugiau pasirinkimų';

  @override
  String get homePromptMetaDataAppCenterLink => 'Visit App Center page';

  @override
  String get homePromptMetaDataAppCenterButton => 'Atverti „Programų centre“';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Also give $permission access';
  }

  @override
  String get homePromptPermissionsTitle => 'Leidimai';

  @override
  String get homePromptPermissionsRead => 'Skaityti';

  @override
  String get homePromptPermissionsReadOnly => 'Tik skaityti';

  @override
  String get homePromptPermissionsWrite => 'Rašyti';

  @override
  String get homePromptPermissionsWriteOnly => 'Tik Rašyti';

  @override
  String get homePromptPermissionsExecute => 'Vykdyti';

  @override
  String get homePromptPermissionsExecuteOnly => 'Tik Vykdyti';

  @override
  String get homePromptErrorUnknownTitle => 'Iškilo problema';

  @override
  String cameraPromptBody(String snapName) {
    return 'Leisti „$snapName“ naudoti šio įrenginio kameras?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Leisti „$snapName“ naudoti šio įrenginio mikrofonus?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Suteikti $snapName galimybę $permissions failus?';
  }
}
