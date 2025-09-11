// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Occitan (`oc`).
class AppLocalizationsOc extends AppLocalizations {
  AppLocalizationsOc([String locale = 'oc']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Podètz totjorn cambiar aquestas permissions al <Centre de seguretat>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Definir l’accès per $snap a :';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Donar a $snap l’accès $permission a :';
  }

  @override
  String get promptActionOptionAllow => 'Autorizar';

  @override
  String get promptActionOptionAllowAlways => 'Totjorn autorizar';

  @override
  String get promptActionOptionAllowOnce => 'Autorizar un còp';

  @override
  String get promptActionOptionDeny => 'Refusar';

  @override
  String get promptActionOptionDenyOnce => 'Refusar un còp';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Accion';

  @override
  String get promptLifespanOptionForever => 'Totjorn';

  @override
  String get promptLifespanOptionSession => 'Fins la desconnexion';

  @override
  String get promptLifespanOptionSingle => 'Un còp';

  @override
  String get promptLifespanTitle => 'Durada';

  @override
  String get promptSaveAndContinue => 'Salvar e contunhar';

  @override
  String get promptTitle => 'Notificacion de seguretat';

  @override
  String get homePatternInfo => '<Ne saber mai tocant los motius>';

  @override
  String get homePatternTypeCustomPath => 'Modèl de motiu personalizat';

  @override
  String get homePatternTypeRequestedDirectory => 'Lo dossièr demandat sonque';

  @override
  String get homePatternTypeRequestedFile => 'Lo fichièr demandat sonque';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Tot dins lo dossièr $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Tot dins lo dossièr';

  @override
  String get homePatternTypeContainingDirectory => 'Tot dins lo dossièr';

  @override
  String get homePatternTypeHomeDirectory => 'Tot dins lo repertòri personal';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Totes los fichièrs $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap vòl obténer l\'accès $permissions a $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap vòl l\'acces $permissions al dossièr $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap vòl l\'accès $permissions a $filename dins lol dossièr $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap vòl l\'accès $permissions a vòstre repertòri personal.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap vòl l\'accès $permissions a $filename dins vòstre repertòri personal.';
  }

  @override
  String get homePromptMetaDataTitle => 'A prepaus d’aquesta aplicacion';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publicat per $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Darrièra mesa a jorn lo $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Mai d’opcions…';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Consultar la pagina del Centre d’aplicacions';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Donar tanben l’accès $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Autorizacions';

  @override
  String get homePromptPermissionsRead => 'Lectura';

  @override
  String get homePromptPermissionsWrite => 'Escritura';

  @override
  String get homePromptPermissionsExecute => 'Executar';

  @override
  String get homePromptErrorUnknownTitle => 'Quicòm a trucat';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to access your microphone?';
  }
}
