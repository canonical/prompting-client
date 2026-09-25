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
    return 'Nastavit přístup pro aplikaci $snap na:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Poskytnout aplikaci $snap přístup $permission k:';
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
  String get promptActionOptionDenyOnce => 'Pro teď zamítnout';

  @override
  String get promptActionOptionDenyAlways => 'Vždy zamítnout';

  @override
  String get promptActionOptionDenyUntilLogout => 'Zamítnout do odhlášení';

  @override
  String get promptActionOptionAllowUntilLogout => 'Povolit až do odhlášení';

  @override
  String get promptActionTitle => 'Činnost';

  @override
  String get promptLifespanOptionForever => 'Vždy';

  @override
  String get promptLifespanOptionSession => 'Do odhlášení';

  @override
  String get promptLifespanOptionSingle => 'Jednorázově';

  @override
  String get promptLifespanTitle => 'Trvání';

  @override
  String get promptSaveAndContinue => 'Uložit a pokračovat';

  @override
  String get promptTitle => 'Bezpečnostní upozornění';

  @override
  String get homePatternInfo => '<Další informace o vzorech popisů umístění>';

  @override
  String get homePatternTypeCustomPath =>
      'Uživatelsky určený vzor popisu umístění';

  @override
  String get homeCustomPathSaveButton => 'Uložit uživatelsky určené umístění';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Vzor popisu umístění musí začínat znakem /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Odpovídá libovolnému řetězci znaků kromě /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Odpovídá jednomu znaku';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Odpovídá žádné nebo více rekurzivním složkám a souborům';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Odpovídá buď x, nebo y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Řídí speciální znaky a zachází s nimi jako s literály';

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
    return 'Aplikace $snap chce získat přístup $permissions k $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return 'Aplikace $snap chce získat přístup $permissions ke složce $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return 'Aplikace $snap chce získat přístup $permissions k $filename ve složce $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return 'Aplikace $snap chce získat přístup $permissions k vaší domovské složce.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return 'Aplikace $snap chce získat přístup $permissions k $filename ve vaší domovské složce.';
  }

  @override
  String get homePromptMetaDataTitle => 'O této aplikaci';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publikoval $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Tento vydavatel má ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'ověřený účet';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Poslední aktualizace $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Více možností…';

  @override
  String get homePromptMoreOptionsTileLabel => 'Více možností';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Navštivte stránku Centra aplikací';

  @override
  String get homePromptMetaDataAppCenterButton => 'Otevřít v Centru aplikací';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Poskytnout také přístup k $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Oprávnění';

  @override
  String get homePromptPermissionsRead => 'Číst';

  @override
  String get homePromptPermissionsReadOnly => 'Pouze čtení';

  @override
  String get homePromptPermissionsWrite => 'Zapisovat';

  @override
  String get homePromptPermissionsWriteOnly => 'Pouze zápis';

  @override
  String get homePromptPermissionsExecute => 'Spouštět';

  @override
  String get homePromptPermissionsExecuteOnly => 'Pouze spouštění';

  @override
  String get homePromptErrorUnknownTitle => 'Něco se nepovedlo';

  @override
  String cameraPromptBody(String snapName) {
    return 'Umožnit aplikaci $snapName používat vaše kamery?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Umožnit aplikaci $snapName používat vaše mikrofony?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Poskytnout aplikaci $snapName přístup $permissions k souborům?';
  }
}
