// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Tato oprávnění můžete kdykoli změnit v <Centru zabezpečení>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Nastavit přístup pro $snap na:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Poskytnout $snap $permission přístup k:';
  }

  @override
  String get promptActionOptionAllow => 'Povolit';

  @override
  String get promptActionOptionAllowAlways => 'Vždy povolit';

  @override
  String get promptActionOptionAllowOnce => 'Povolit jednou';

  @override
  String get promptActionOptionDeny => 'Zamítnout';

  @override
  String get promptActionOptionDenyOnce => 'Jednou zamítnout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Činnost';

  @override
  String get promptLifespanOptionForever => 'Vždy';

  @override
  String get promptLifespanOptionSession => 'Do odhlášení';

  @override
  String get promptLifespanOptionSingle => 'Jednou';

  @override
  String get promptLifespanTitle => 'Trvání';

  @override
  String get promptSaveAndContinue => 'Uložit a pokračovat';

  @override
  String get promptTitle => 'Bezpečnostní upozornění';

  @override
  String get homePatternInfo => '<Další informace o vzorech cest>';

  @override
  String get homePatternTypeCustomPath => 'Vlastní vzor cesty';

  @override
  String get homePatternTypeRequestedDirectory => 'Pouze požadovaná složka';

  @override
  String get homePatternTypeRequestedFile => 'Pouze požadovaný soubor';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Vše ve složce $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Vše ve složce';

  @override
  String get homePatternTypeContainingDirectory => 'Vše ve složce';

  @override
  String get homePatternTypeHomeDirectory => 'Vše v domovské složce';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Všechny soubory $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap chce získat $permissions přístup k $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap chce získat $permissions přístup ke složce $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap chce získat $permissions přístup k $filename ve složce $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap chce získat $permissions přístup k vaší domovské složce.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap chce získat $permissions přístup k $filename ve vaší domovské složce.';
  }

  @override
  String get homePromptMetaDataTitle => 'O této aplikaci';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publikoval $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Poslední aktualizace $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Více možností…';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Navštivte stránku Centra aplikací';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Poskytnout také přístup k $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Oprávnění';

  @override
  String get homePromptPermissionsRead => 'Číst';

  @override
  String get homePromptPermissionsWrite => 'Zapisovat';

  @override
  String get homePromptPermissionsExecute => 'Spouštět';

  @override
  String get homePromptErrorUnknownTitle => 'Něco se nepovedlo';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }
}
