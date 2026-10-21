// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Tieto povolenia môžete kedykoľvek zmeniť v <Centre zabezpečenia>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Nastaviť prístup pre $snap na:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Udeliť $snap prístup na $permission k:';
  }

  @override
  String get promptActionOptionAllow => 'Povoliť';

  @override
  String get promptActionOptionAllowAlways => 'Povoliť vždy';

  @override
  String get promptActionOptionAllowOnce => 'Povoliť raz';

  @override
  String get promptActionOptionDeny => 'Zamietnuť';

  @override
  String get promptActionOptionDenyOnce => 'Zamietnuť raz';

  @override
  String get promptActionOptionDenyAlways => 'Zamietnuť vždy';

  @override
  String get promptActionOptionDenyUntilLogout => 'Zamietnuť do odhlásenia';

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
  String get promptLifespanTitle => 'Trvanie';

  @override
  String get promptSaveAndContinue => 'Uložiť a pokračovať';

  @override
  String get promptTitle => 'Bezpečnostné upozornenie';

  @override
  String get homePatternInfo => '<Ďalšie informácie o vzoroch ciest>';

  @override
  String get homePatternTypeCustomPath => 'Vlastný vzor cesty';

  @override
  String get homeCustomPathSaveButton => 'Uložiť vlastnú cestu';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Vzor cesty sa musí začínať znakom /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Zhoduje sa s akýmkoľvek reťazcom znakov okrem /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Zhoduje sa s jedným znakom';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Rekurzívne sa zhoduje s nulou alebo viacerými priečinkami a súbormi';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Zhoduje sa s x alebo y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Umožňuje interpretovať špeciálne znaky ako obyčajné';

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
    return '$snap žiada o prístup na $permissions k $filename v priečinku $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap žiada o prístup na $permissions k vášmu domovskému priečinku.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap žiada o prístup na $permissions k $filename vo vašom domovskom priečinku.';
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
  String get homePromptMoreOptionsLabel => 'Ďalšie možnosti...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Ďalšie možnosti';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Navštíviť stránku v Centre aplikácií';

  @override
  String get homePromptMetaDataAppCenterButton => 'Otvoriť v Centre aplikácií';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Udeliť aj prístup na $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Povolenia';

  @override
  String get homePromptPermissionsRead => 'Čítanie';

  @override
  String get homePromptPermissionsReadOnly => 'Iba na čítanie';

  @override
  String get homePromptPermissionsWrite => 'Zapisovanie';

  @override
  String get homePromptPermissionsWriteOnly => 'Iba na zapisovanie';

  @override
  String get homePromptPermissionsExecute => 'Spúšťanie';

  @override
  String get homePromptPermissionsExecuteOnly => 'Iba na spúšťanie';

  @override
  String get homePromptErrorUnknownTitle => 'Niečo sa pokazilo';

  @override
  String cameraPromptBody(String snapName) {
    return 'Povoliť $snapName používať vaše kamery?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Povoliť $snapName používať vaše mikrofóny?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Udeliť $snapName prístup na $permissions k súborom?';
  }
}
