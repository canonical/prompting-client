// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Vous pouvez toujours modifier ces permissions dans le <Centre de sécurité>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Définir l’accès concernant $snap à :';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Donner à $snap l’accès $permission à :';
  }

  @override
  String get promptActionOptionAllow => 'Autoriser';

  @override
  String get promptActionOptionAllowAlways => 'Autoriser toujours';

  @override
  String get promptActionOptionAllowOnce => 'Autoriser une fois';

  @override
  String get promptActionOptionDeny => 'Refuser';

  @override
  String get promptActionOptionDenyOnce => 'Refuser une seule fois';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Action';

  @override
  String get promptLifespanOptionForever => 'Toujours';

  @override
  String get promptLifespanOptionSession => 'Jusqu\'à déconnexion';

  @override
  String get promptLifespanOptionSingle => 'Une seule fois';

  @override
  String get promptLifespanTitle => 'Durée';

  @override
  String get promptSaveAndContinue => 'Enregistrer et continuer';

  @override
  String get promptTitle => 'Notification de sécurité';

  @override
  String get homePatternInfo => '<En savoir plus sur les patterns>';

  @override
  String get homePatternTypeCustomPath => 'Modèle de pattern personnalisé';

  @override
  String get homePatternTypeRequestedDirectory =>
      'Le dossier demandé seulement';

  @override
  String get homePatternTypeRequestedFile => 'Le fichier demandé seulement';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Tout dans le dossier $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Tout dans le dossier';

  @override
  String get homePatternTypeContainingDirectory => 'Tout dans le dossier';

  @override
  String get homePatternTypeHomeDirectory => 'Tout dans le dossier personnel';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Tous les fichiers $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap souhaite obtenir un accès $permissions à $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap veut obtenir l\'accès $permissions au dossier $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap souhaite obtenir un accès $permissions à $filename dans le dossier $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap souhaite obtenir un accès $permissions à votre dossier personnel.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap souhaite obtenir un accès $permissions à $filename dans votre dossier personnel.';
  }

  @override
  String get homePromptMetaDataTitle => 'À propos de cette application';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publié par $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Dernière mise à jour le $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Plus d’options…';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Visiter la page du Centre des applications';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Donner également l\'accès en $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Autorisations';

  @override
  String get homePromptPermissionsRead => 'Lire';

  @override
  String get homePromptPermissionsWrite => 'Écrire';

  @override
  String get homePromptPermissionsExecute => 'Exécuter';

  @override
  String get homePromptErrorUnknownTitle => 'Quelque chose a mal tourné';
}
