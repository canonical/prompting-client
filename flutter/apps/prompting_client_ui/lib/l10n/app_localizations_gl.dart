// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Galician (`gl`).
class AppLocalizationsGl extends AppLocalizations {
  AppLocalizationsGl([String locale = 'gl']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Sempre podes mudar estes permisos no <Centro de seguranza>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Establecer acceso para $snap a:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Dalle a $snap $permission acceso a:';
  }

  @override
  String get promptActionOptionAllow => 'Permitir';

  @override
  String get promptActionOptionAllowAlways => 'Permitir sempre';

  @override
  String get promptActionOptionAllowOnce => 'Permitir unha vez';

  @override
  String get promptActionOptionDeny => 'Negar';

  @override
  String get promptActionOptionDenyOnce => 'Negar unha vez';

  @override
  String get promptActionOptionDenyAlways => 'Negar sempre';

  @override
  String get promptActionOptionDenyUntilLogout => 'Negar ata pechar sesión';

  @override
  String get promptActionOptionAllowUntilLogout => 'Permitir ata pechar sesión';

  @override
  String get promptActionTitle => 'Acción';

  @override
  String get promptLifespanOptionForever => 'Sempre';

  @override
  String get promptLifespanOptionSession => 'Ata pechar sesión';

  @override
  String get promptLifespanOptionSingle => 'Unha vez';

  @override
  String get promptLifespanTitle => 'Duración';

  @override
  String get promptSaveAndContinue => 'Gardar e continuar';

  @override
  String get promptTitle => 'Notificación de seguranza';

  @override
  String get homePatternInfo => '<Saber máis sobre os patróns de ruta>';

  @override
  String get homePatternTypeCustomPath => 'Patrón de ruta personalizado';

  @override
  String get homeCustomPathSaveButton => 'Gardar ruta personalizada';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'O patrón de ruta debe comezar con /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Coincide con calqueira cadea de caracteres excepto /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Coincide con un só caracter';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Coincide con cero ou máis cartafoles e arquivos recursivamente';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Coincide con x ou y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Escapa os caracteres especiais para tratalos como literais';

  @override
  String get homePatternTypeRequestedDirectory => 'Só o cartafol solicitado';

  @override
  String get homePatternTypeRequestedFile => 'Só o ficheiro solicitado';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Todo o contido do cartafol $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Todo no cartafol';

  @override
  String get homePatternTypeContainingDirectory => 'Todo no cartafol';

  @override
  String get homePatternTypeHomeDirectory => 'Todo no Cartafol persoal';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Todos os ficheiros $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap quere obter acceso $permissions a $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap quere obter acceso $permissions ao cartafol $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap quere obter acceso $permissions a $filename no cartafol $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap quere obter acceso $permissions ao Cartafol persoal.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap quere obter acceso $permissions a $filename no teu Cartafol persoal.';
  }

  @override
  String get homePromptMetaDataTitle => 'Sobre a aplicación';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publicado por $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Este editor ten un ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'conta verificada';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Última actualización o $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Máis opcións...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Máis opcións';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Visita a páxina do Centro de Aplicacións';

  @override
  String get homePromptMetaDataAppCenterButton =>
      'Abrir no Centro de Aplicacións';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Tamén dar acceso $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Permisos';

  @override
  String get homePromptPermissionsRead => 'Ler';

  @override
  String get homePromptPermissionsReadOnly => 'Só lectura';

  @override
  String get homePromptPermissionsWrite => 'Escribir';

  @override
  String get homePromptPermissionsWriteOnly => 'Só escritura';

  @override
  String get homePromptPermissionsExecute => 'Executar';

  @override
  String get homePromptPermissionsExecuteOnly => 'Executa só';

  @override
  String get homePromptErrorUnknownTitle => 'Algo fallou';

  @override
  String cameraPromptBody(String snapName) {
    return 'Permitir que $snapName use a túa cámara?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Queres permitir que $snapName use o teu micrófono?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Queres darlle a $snapName $permissions acceso aos ficheiros?';
  }
}
