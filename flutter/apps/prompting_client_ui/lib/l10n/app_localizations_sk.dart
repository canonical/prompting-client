// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Tieto oprávnenia môžete kedykoľvek zmeniť v <Centre zabezpečenia>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Nastaviť prístup pre $snap:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Udeliť $snap $permission prístup k:';
  }

  @override
  String get promptActionOptionAllow => 'Povoliť';

  @override
  String get promptActionOptionAllowAlways => 'Vždy povoliť';

  @override
  String get promptActionOptionAllowOnce => 'Raz povoliť';

  @override
  String get promptActionOptionDeny => 'Odmietnuť';

  @override
  String get promptActionOptionDenyOnce => 'Raz odmietnuť';

  @override
  String get promptActionOptionDenyAlways => 'Vždy odmietnuť';

  @override
  String get promptActionOptionDenyUntilLogout => 'Odmietnuť do odhlásenia';

  @override
  String get promptActionOptionAllowUntilLogout => 'Povoliť do odhlásenia';

  @override
  String get promptActionTitle => 'Akcia';

  @override
  String get promptLifespanOptionForever => 'Vždy';

  @override
  String get promptLifespanOptionSession => 'Do odhlásenia';

  @override
  String get promptLifespanOptionSingle => 'Raz';

  @override
  String get promptLifespanTitle => 'Doba trvania';

  @override
  String get promptSaveAndContinue => 'Uložiť a pokračovať';

  @override
  String get promptTitle => 'Bezpečnostné upozornenie';

  @override
  String get homePatternInfo => '<Zistiť viac o vzoroch ciest>';

  @override
  String get homePatternTypeCustomPath => 'Vlastný vzor cesty';

  @override
  String get homeCustomPathSaveButton => 'Uložiť vlastnú cestu';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Vzor cesty musí začínať znakom /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Zodpovedá ľubovoľnému reťazcu znakov okrem /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Zodpovedá jednému znaku';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Zodpovedá nule alebo viacerým priečinkom a súborom rekurzívne';

  @override
  String get homeCustomPathWildcardCurlyDescription =>
      'Zodpovedá buď x alebo y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Zruší špeciálny význam znakov, aby sa považovali za bežný text';

  @override
  String get homePatternTypeRequestedDirectory => 'Iba požadovaný priečinok';

  @override
  String get homePatternTypeRequestedFile => 'Iba požadovaný súbor';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Všetko v priečinku $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Všetko v priečinku';

  @override
  String get homePatternTypeContainingDirectory => 'Všetko v priečinku';

  @override
  String get homePatternTypeHomeDirectory => 'Všetko v domovskom priečinku';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Všetky súbory $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap žiada o prístup na $permissions k $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap žiada o prístup na $permissions k priečinku $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap žiada o prístup na $permissions k súboru $filename v priečinku $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap žiada o prístup na $permissions k domovskému priečinku.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap žiada o prístup na $permissions k súboru $filename v domovskom priečinku.';
  }

  @override
  String get homePromptMetaDataTitle => 'O tejto aplikácii';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Vydavateľ $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Tento vydavateľ má ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'overený účet';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Posledná aktualizácia $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Viac možností...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Viac možností';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Navštíviť stránku Centra aplikácií';

  @override
  String get homePromptMetaDataAppCenterButton => 'Otvoriť v Centre aplikácií';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Udeliť prístup aj na $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Oprávnenia';

  @override
  String get homePromptPermissionsRead => 'Čítanie';

  @override
  String get homePromptPermissionsReadOnly => 'Iba na čítanie';

  @override
  String get homePromptPermissionsWrite => 'Zápis';

  @override
  String get homePromptPermissionsWriteOnly => 'Iba na zápis';

  @override
  String get homePromptPermissionsExecute => 'Spúšťanie';

  @override
  String get homePromptPermissionsExecuteOnly => 'Iba na spúšťanie';

  @override
  String get homePromptErrorUnknownTitle => 'Niečo sa pokazilo';

  @override
  String cameraPromptBody(String snapName) {
    return 'Povoliť $snapName prístup ku kamerám?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Povoliť $snapName prístup k mikrofónom?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Udeliť $snapName prístup na $permissions k súborom?';
  }
}
