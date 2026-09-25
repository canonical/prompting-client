// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Pode alterar sempre estas permissões no <Centro de Segurança>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Defina o acesso de $snap para:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Dar $snap $permission para aceder a:';
  }

  @override
  String get promptActionOptionAllow => 'Permitir';

  @override
  String get promptActionOptionAllowAlways => 'Permitir sempre';

  @override
  String get promptActionOptionAllowOnce => 'Permitir uma vez';

  @override
  String get promptActionOptionDeny => 'Negar';

  @override
  String get promptActionOptionDenyOnce => 'Negar uma vez';

  @override
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Ação';

  @override
  String get promptLifespanOptionForever => 'Sempre';

  @override
  String get promptLifespanOptionSession => 'Até terminar a sessão';

  @override
  String get promptLifespanOptionSingle => 'Uma vez';

  @override
  String get promptLifespanTitle => 'Duração';

  @override
  String get promptSaveAndContinue => 'Guardar e continuar';

  @override
  String get promptTitle => 'Notificação de segurança';

  @override
  String get homePatternInfo => '<Saiba sobre os padrões de caminho>';

  @override
  String get homePatternTypeCustomPath => 'Padrão de caminho personalizado';

  @override
  String get homeCustomPathSaveButton => 'Save custom path';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'The path pattern must start with /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Matches any string of characters except /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Matches a single character';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Matches zero or more folders and files recursively';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Matches either x or y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Escapes special characters to treat them as literals';

  @override
  String get homePatternTypeRequestedDirectory => 'The requested folder only';

  @override
  String get homePatternTypeRequestedFile => 'The requested file only';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Everything in the $topLevelDir folder';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Everything in the folder';

  @override
  String get homePatternTypeContainingDirectory => 'Everything in the folder';

  @override
  String get homePatternTypeHomeDirectory => 'Everything in the Home folder';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'All $fileExtension files';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap wants to get $permissions access to $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap wants to get $permissions access to the $foldername folder.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap wants to get $permissions access to $filename in the $foldername folder.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap wants to get $permissions access to your Home folder.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap wants to get $permissions access to $filename in your Home folder.';
  }

  @override
  String get homePromptMetaDataTitle => 'Sobre esta aplicação';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publicado por $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'This publisher has a ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verified account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Última atualização em $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Mais opções...';

  @override
  String get homePromptMoreOptionsTileLabel => 'More options';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Visite a página do \"Centro de Aplicações\"';

  @override
  String get homePromptMetaDataAppCenterButton => 'Open in App Center';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Also give $permission access';
  }

  @override
  String get homePromptPermissionsTitle => 'Permissões';

  @override
  String get homePromptPermissionsRead => 'Ler';

  @override
  String get homePromptPermissionsReadOnly => 'Read only';

  @override
  String get homePromptPermissionsWrite => 'Gravar';

  @override
  String get homePromptPermissionsWriteOnly => 'Write only';

  @override
  String get homePromptPermissionsExecute => 'Executar';

  @override
  String get homePromptPermissionsExecuteOnly => 'Execute only';

  @override
  String get homePromptErrorUnknownTitle => 'Ocorreu algo de errado';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to use your cameras?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to use your microphones?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Give $snapName $permissions access to files?';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get securityCenterInfo =>
      'Você sempre pode alterar essas permissões na <Central de Segurança>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Defina o acesso do $snap para:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Conceder a $snap acesso $permission a:';
  }

  @override
  String get promptActionOptionAllow => 'Permitir';

  @override
  String get promptActionOptionAllowAlways => 'Permitir sempre';

  @override
  String get promptActionOptionAllowOnce => 'Permitir uma vez';

  @override
  String get promptActionOptionDeny => 'Negar';

  @override
  String get promptActionOptionDenyOnce => 'Negar uma vez';

  @override
  String get promptActionOptionAllowUntilLogout => 'Permitir até o logout';

  @override
  String get promptActionTitle => 'Ação';

  @override
  String get promptLifespanOptionForever => 'Sempre';

  @override
  String get promptLifespanOptionSession => 'Até que você faça logout';

  @override
  String get promptLifespanOptionSingle => 'Uma vez';

  @override
  String get promptLifespanTitle => 'Duração';

  @override
  String get promptSaveAndContinue => 'Salvar e continuar';

  @override
  String get promptTitle => 'Notificação de segurança';

  @override
  String get homePatternInfo => '<Saiba mais sobre padrões de caminho>';

  @override
  String get homePatternTypeCustomPath => 'Padrão de caminho personalizado';

  @override
  String get homePatternTypeRequestedDirectory => 'Somente a pasta solicitada';

  @override
  String get homePatternTypeRequestedFile => 'Somente o arquivo solicitado';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Tudo na pasta $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Tudo na pasta';

  @override
  String get homePatternTypeContainingDirectory => 'Tudo na pasta';

  @override
  String get homePatternTypeHomeDirectory => 'Tudo na pasta Início';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Todos os arquivos $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap deseja obter acesso de $permissions à $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap quer obter acesso de $permissions à pasta $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap quer obter acesso de $permissions ao arquivo $filename na pasta $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap deseja obter acesso $permissions à sua pasta pessoal.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap deseja obter acesso de $permissions ao arquivo $filename na sua pasta pessoal.';
  }

  @override
  String get homePromptMetaDataTitle => 'Sobre este aplicativo';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publicado por $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Última atualização em $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Mais opções...';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Visite a página da Central de Aplicativos';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Também conceda acesso $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Permissões';

  @override
  String get homePromptPermissionsRead => 'Leia';

  @override
  String get homePromptPermissionsWrite => 'Escreva';

  @override
  String get homePromptPermissionsExecute => 'Execute';

  @override
  String get homePromptErrorUnknownTitle => 'Algo deu errado';

  @override
  String cameraPromptBody(String snapName) {
    return 'Permitir que $snapName acesse sua câmera?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Permitir que $snapName acesse seu microfone?';
  }
}
