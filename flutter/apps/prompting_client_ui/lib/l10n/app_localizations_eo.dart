// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Esperanto (`eo`).
class AppLocalizationsEo extends AppLocalizations {
  AppLocalizationsEo([String locale = 'eo']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Vi povas iam ajn ŝanĝi tiujn permesojn en la «Sekureca Centro»';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Permesi al $snap:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Doni al $snap permeson $permission la jenon:';
  }

  @override
  String get promptActionOptionAllow => 'Permesi';

  @override
  String get promptActionOptionAllowAlways => 'Permesi ĉiam';

  @override
  String get promptActionOptionAllowOnce => 'Permesi unu fojon';

  @override
  String get promptActionOptionDeny => 'Malpermesi';

  @override
  String get promptActionOptionDenyOnce => 'Malpermesi unu fojon';

  @override
  String get promptActionOptionDenyAlways => 'Malpermesi ĉiam';

  @override
  String get promptActionOptionDenyUntilLogout => 'Malpermesi ĝis adiaŭo';

  @override
  String get promptActionOptionAllowUntilLogout => 'Permesi ĝis adiaŭo';

  @override
  String get promptActionTitle => 'Ago';

  @override
  String get promptLifespanOptionForever => 'Ĉiam';

  @override
  String get promptLifespanOptionSession => 'Ĝis adiaŭo';

  @override
  String get promptLifespanOptionSingle => 'Unu fojon';

  @override
  String get promptLifespanTitle => 'Daŭro';

  @override
  String get promptSaveAndContinue => 'Konservi kaj daŭrigi';

  @override
  String get promptTitle => 'Sciigo pri sekureco';

  @override
  String get homePatternInfo => '<Lerni pli pri dosierlokaj ŝablonoj>';

  @override
  String get homePatternTypeCustomPath => 'Propra dosierloka ŝablono';

  @override
  String get homeCustomPathSaveButton => 'Konservi propran dosiervojon';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'La dosiervojo devas komenciĝi per /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Kongruas kun ajna sinsekvo de skribsignoj krom /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Kongruas kun ajna unuopa skribsigno';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Kongruas kun nul aŭ pli da dosierujoj kaj dosieroj rikure';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Kongruas kun aŭ x aŭ y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Eskapigas speciajan signojn, igante ilin traktiĝi kiel laŭliteraĵoj';

  @override
  String get homePatternTypeRequestedDirectory => 'Nur la petata dosierujo';

  @override
  String get homePatternTypeRequestedFile => 'Nur la petata dosiero';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Ĉio en la dosierujo $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Ĉio en la dosierujo';

  @override
  String get homePatternTypeContainingDirectory => 'Ĉio en la dosierujo';

  @override
  String get homePatternTypeHomeDirectory => 'Ĉio en la hejma dosierujo';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Ĉiuj $fileExtension-dosieroj';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap volas havi permeson $permissions $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap volas havi permeson $permissions la dosierujon $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap volas havi permeson $permissions la dosieron $filename en la dosierujo $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap volas havi permeson $permissions vian hejman dosierujon.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap volas havi permeson $permissions la dosieron $filename en via hejma dosierujo.';
  }

  @override
  String get homePromptMetaDataTitle => 'Pri ĉi tiu programo';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Eldonita de $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix =>
      'Ĉi tiu eldonanto havas ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'konfirmitan konton';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Laste ĝisdatigita je $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Pli da opcioj…';

  @override
  String get homePromptMoreOptionsTileLabel => 'Pliaj opcioj';

  @override
  String get homePromptMetaDataAppCenterLink => 'Viziti paĝon ĉe App Center';

  @override
  String get homePromptMetaDataAppCenterButton => 'Malfermi per Programcentro';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Ankaŭ permesi $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Permesoj';

  @override
  String get homePromptPermissionsRead => 'legi';

  @override
  String get homePromptPermissionsReadOnly => 'Nur legi';

  @override
  String get homePromptPermissionsWrite => 'Skribi';

  @override
  String get homePromptPermissionsWriteOnly => 'Nur skribi';

  @override
  String get homePromptPermissionsExecute => 'Ruli';

  @override
  String get homePromptPermissionsExecuteOnly => 'Nur ruli';

  @override
  String get homePromptErrorUnknownTitle => 'Io fiaskis';

  @override
  String cameraPromptBody(String snapName) {
    return 'Ĉu permesi al $snapName uzi viajn kameraojn?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Ĉu permesi al $snapName uzi viajn mikrofonojn?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Ĉu permesi al $snapName $permissions dosierojn?';
  }
}
