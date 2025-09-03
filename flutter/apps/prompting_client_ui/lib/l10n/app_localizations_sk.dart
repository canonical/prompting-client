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
    return 'Nastaviť prístup pre $snap na:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Udeľte $snap na $permission prístup k:';
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
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Akcia';

  @override
  String get promptLifespanOptionForever => 'Vždy';

  @override
  String get promptLifespanOptionSession => 'Do ukončenia';

  @override
  String get promptLifespanOptionSingle => 'Raz';

  @override
  String get promptLifespanTitle => 'Doba trvania';

  @override
  String get promptSaveAndContinue => 'Uložiť a pokračovať';

  @override
  String get promptTitle => 'Bezpečnostné upozornenie';

  @override
  String get homePatternInfo => '<Ďalšie informácie o formátoch ciest>';

  @override
  String get homePatternTypeCustomPath => 'Vlastný formát cesty';

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
  String get homePatternTypeHomeDirectory => 'Všetko v priečinku Domov';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Všetky súbory $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap chce získať na $permissions prístup k $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap chce získať na $permissions prístup k priečinku $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap chce získať na $permissions prístup k $filename v priečinku $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap chce získať na $permissions prístup k priečinku Domov.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap chce získať na $permissions prístup k $filename v priečinku Domov.';
  }

  @override
  String get homePromptMetaDataTitle => 'O tejto aplikácii';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Vydal $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Posledná aktualizácia $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Viac možností...';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Navštíviť stránku Centra aplikácií';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Udeliť prístup aj na $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Oprávnenia';

  @override
  String get homePromptPermissionsRead => 'Čítanie';

  @override
  String get homePromptPermissionsWrite => 'Zápis';

  @override
  String get homePromptPermissionsExecute => 'Spúšťanie';

  @override
  String get homePromptErrorUnknownTitle => 'Niečo sa pokazilo';
}
