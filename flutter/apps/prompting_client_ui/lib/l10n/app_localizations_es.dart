// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Siempre puede cambiar estos permisos en el <Centro de seguridad>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Establecer acceso para $snap a:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Otorgar a $snap $permission acceso a:';
  }

  @override
  String get promptActionOptionAllow => 'Permitir';

  @override
  String get promptActionOptionAllowAlways => 'Permitir siempre';

  @override
  String get promptActionOptionAllowOnce => 'Permitir una vez';

  @override
  String get promptActionOptionDeny => 'Denegar';

  @override
  String get promptActionOptionDenyOnce => 'Denegar una vez';

  @override
  String get promptActionOptionDenyAlways => 'Denegar siempre';

  @override
  String get promptActionOptionDenyUntilLogout =>
      'Denegar hasta finalizar sesión';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Permitir hasta finalizar sesión';

  @override
  String get promptActionTitle => 'Acción';

  @override
  String get promptLifespanOptionForever => 'Siempre';

  @override
  String get promptLifespanOptionSession => 'Hasta finalizar sesión';

  @override
  String get promptLifespanOptionSingle => 'Una vez';

  @override
  String get promptLifespanTitle => 'Duración';

  @override
  String get promptSaveAndContinue => 'Guardar y continuar';

  @override
  String get promptTitle => 'Notificación de seguridad';

  @override
  String get homePatternInfo => '<Más información sobre los patrones de ruta>';

  @override
  String get homePatternTypeCustomPath => 'Patrón de ruta personalizado';

  @override
  String get homeCustomPathSaveButton => 'Guardar ruta personalizada';

  @override
  String get homeCustomPathMustStartWithSlash => 'La ruta debe comenzar por /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Encuentra cualquier cadena de caracteres salvo /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Encuentra un único carácter';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Encuentra cero o más archivos y carpetas de forma recursiva';

  @override
  String get homeCustomPathWildcardCurlyDescription =>
      'Encuentra tanto x como y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Trata los caracteres especiales como literales';

  @override
  String get homePatternTypeRequestedDirectory => 'Solo la carpeta solicitada';

  @override
  String get homePatternTypeRequestedFile => 'Solo el archivo solicitado';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Todo en la carpeta $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Todo en la carpeta';

  @override
  String get homePatternTypeContainingDirectory => 'Todo en la carpeta';

  @override
  String get homePatternTypeHomeDirectory => 'Todo en tu carpeta personal';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Todos los archivos $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap quiere obtener $permissions acceso a $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap quiere obtener $permissions acceso a la carpeta $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap quiere obtener $permissions acceso a $filename en la carpeta $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap quiere obtener $permissions acceso a su carpeta de inicio.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap quiere obtener $permissions acceso a $filename en su carpeta de inicio.';
  }

  @override
  String get homePromptMetaDataTitle => 'Acerca de esta aplicación';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publicado por $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix =>
      'Este editor cuenta con una ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'cuenta verificada';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Última actualización el $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Más opciones...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Más opciones';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Visita la página del Centro de aplicaciones';

  @override
  String get homePromptMetaDataAppCenterButton =>
      'Abrir en Centro de aplicaciones';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'También dar acceso a $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Permisos';

  @override
  String get homePromptPermissionsRead => 'Leer';

  @override
  String get homePromptPermissionsReadOnly => 'Solo lectura';

  @override
  String get homePromptPermissionsWrite => 'Escribir';

  @override
  String get homePromptPermissionsWriteOnly => 'Solo escritura';

  @override
  String get homePromptPermissionsExecute => 'Ejecutar';

  @override
  String get homePromptPermissionsExecuteOnly => 'Solo ejecución';

  @override
  String get homePromptErrorUnknownTitle => 'Algo ha ido mal';

  @override
  String cameraPromptBody(String snapName) {
    return '¿Permite que $snapName use sus cámaras?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return '¿Permite que $snapName use sus micrófonos?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return '¿Quiere otorgar acceso de $permissions a $snapName?';
  }
}
