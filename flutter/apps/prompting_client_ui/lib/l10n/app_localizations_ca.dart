// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Sempre podeu canviar aquests permisos al <Centre de seguretat>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Estableix l\'accés per a $snap a:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Atorga a $snap accés de $permission a:';
  }

  @override
  String get promptActionOptionAllow => 'Permet';

  @override
  String get promptActionOptionAllowAlways => 'Permet sempre';

  @override
  String get promptActionOptionAllowOnce => 'Permet un cop';

  @override
  String get promptActionOptionDeny => 'Denega';

  @override
  String get promptActionOptionDenyOnce => 'Denega un cop';

  @override
  String get promptActionOptionDenyAlways => 'Denega sempre';

  @override
  String get promptActionOptionDenyUntilLogout =>
      'Denega fins al tancament de la sessió';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Permet fins al tancament de la sessió';

  @override
  String get promptActionTitle => 'Acció';

  @override
  String get promptLifespanOptionForever => 'Sempre';

  @override
  String get promptLifespanOptionSession => 'Fins que es tanqui la sessió';

  @override
  String get promptLifespanOptionSingle => 'Un cop';

  @override
  String get promptLifespanTitle => 'Duració';

  @override
  String get promptSaveAndContinue => 'Desa i continua';

  @override
  String get promptTitle => 'Notificació de seguretat';

  @override
  String get homePatternInfo => '<Apreneu més sobre els patrons de camins>';

  @override
  String get homePatternTypeCustomPath => 'Patró personalitzat de camí';

  @override
  String get homeCustomPathSaveButton => 'Desa el camí personalitzat';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'El patró del camí ha de començar amb /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Concorda totes les cadenes de caràcters excepte /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Concorda amb un caràcter únic';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Concorda amb zero o més carpetes i fitxers recursivament';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Concorda amb x o y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Tracta els caràcters especials com a literals';

  @override
  String get homePatternTypeRequestedDirectory =>
      'Sols la carpeta sol·licitada';

  @override
  String get homePatternTypeRequestedFile => 'Sols el fitxer sol·licitat';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Tot a la carpeta $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Tot a la carpeta';

  @override
  String get homePatternTypeContainingDirectory => 'Tot a la carpeta';

  @override
  String get homePatternTypeHomeDirectory => 'Tota a la carpeta personal';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Tots els fitxers $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap vol obtenir accés de $permissions per a $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap vol obtenir accés de $permissions per a la carpeta $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap vol obtenir accés de $permissions per a $filename a la carpeta $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap vol obtenir accés de $permissions a la vostra carpeta de inici.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap vol obtenir accés de $permissions per a $filename a la vostra carpeta d\'inici.';
  }

  @override
  String get homePromptMetaDataTitle => 'Quant a aquesta aplicació';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publicat per $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Aquest editor té un ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'compte verificat';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Última actualització el $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Més opcions...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Més opcions';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Visita la pàgina del Centre d\'aplicacions';

  @override
  String get homePromptMetaDataAppCenterButton =>
      'Obre al Centre d\'aplicacions';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'També dona accés de $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Permisos';

  @override
  String get homePromptPermissionsRead => 'Lectura';

  @override
  String get homePromptPermissionsReadOnly => 'Sols lectura';

  @override
  String get homePromptPermissionsWrite => 'Escriptura';

  @override
  String get homePromptPermissionsWriteOnly => 'Sols escriptura';

  @override
  String get homePromptPermissionsExecute => 'Execució';

  @override
  String get homePromptPermissionsExecuteOnly => 'Sols execució';

  @override
  String get homePromptErrorUnknownTitle => 'Alguna cosa ha fallat';

  @override
  String cameraPromptBody(String snapName) {
    return 'Voleu permetre a $snapName fer servir la càmera?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Voleu permetre a $snapName fer servir els micròfons?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Voleu donar a $snapName permissos de $permissions als fitxers?';
  }
}
