// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Вы всегда можете изменить эти разрешения в приложении <Центр безопасности>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Доступ для $snap:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Доступ на $permission для $snap:';
  }

  @override
  String get promptActionOptionAllow => 'Разрешить';

  @override
  String get promptActionOptionAllowAlways => 'Разрешать всегда';

  @override
  String get promptActionOptionAllowOnce => 'Разрешить один раз';

  @override
  String get promptActionOptionDeny => 'Отказать';

  @override
  String get promptActionOptionDenyOnce => 'Отказать один раз';

  @override
  String get promptActionOptionDenyAlways => 'Всегда отказывать';

  @override
  String get promptActionOptionDenyUntilLogout =>
      'Отказывать до выхода из системы';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Разрешить до выхода из системы';

  @override
  String get promptActionTitle => 'Действие';

  @override
  String get promptLifespanOptionForever => 'Всегда';

  @override
  String get promptLifespanOptionSession => 'До выхода из системы';

  @override
  String get promptLifespanOptionSingle => 'Один раз';

  @override
  String get promptLifespanTitle => 'Срок';

  @override
  String get promptSaveAndContinue => 'Сохранить и продолжить';

  @override
  String get promptTitle => 'Оповещение о безопасности';

  @override
  String get homePatternInfo => '<Узнать о шаблонах пути>';

  @override
  String get homePatternTypeCustomPath => 'Пользовательский шаблон пути';

  @override
  String get homeCustomPathSaveButton => 'Сохранить польз. путь';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Шаблон пути должен начинаться с /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Соответствует любой строке символов, кроме /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Соответствует одному символу';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Соответствует нулю или более папкам и файлам рекурсивно';

  @override
  String get homeCustomPathWildcardCurlyDescription =>
      'Соответствует либо x, либо y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Экранирует специальные символы, чтобы обрабатывать их как литералы';

  @override
  String get homePatternTypeRequestedDirectory => 'Только запрашиваемая папка';

  @override
  String get homePatternTypeRequestedFile => 'Только запрашиваемый файл';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Всё содержимое в папке $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Всё содержимое в папке';

  @override
  String get homePatternTypeContainingDirectory => 'Всё содержимое в папке';

  @override
  String get homePatternTypeHomeDirectory => 'Всё содержимое Домашней папки';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Все файлы $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap запрашивает разрешение на $permissions по пути $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap запрашивает разрешение на $permissions папки $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap запрашивает разрешение на $permissions файла $filename в папке $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap запрашивает разрешение на $permissions в вашей «Домашней папке».';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap запрашивает разрешение на $permissions файла $filename, расположенного в вашей «Домашней папке».';
  }

  @override
  String get homePromptMetaDataTitle => 'Об этом приложении';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Опубликовано $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Этот издатель имеет ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'проверенную уч. запись';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Последнее обновление от $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Другие параметры...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Другие параметры';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Открыть страницу в Центре приложений';

  @override
  String get homePromptMetaDataAppCenterButton => 'Открыть в Центре приложений';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Также дать доступ на $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Разрешения';

  @override
  String get homePromptPermissionsRead => 'Чтение';

  @override
  String get homePromptPermissionsReadOnly => 'Только чтение';

  @override
  String get homePromptPermissionsWrite => 'Запись';

  @override
  String get homePromptPermissionsWriteOnly => 'Только запись';

  @override
  String get homePromptPermissionsExecute => 'Выполнение';

  @override
  String get homePromptPermissionsExecuteOnly => 'Только выполнение';

  @override
  String get homePromptErrorUnknownTitle => 'Что-то пошло не так';

  @override
  String cameraPromptBody(String snapName) {
    return 'Разрешить $snapName использование камер?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Разрешить $snapName использование микрофонов?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Дать $snapName доступ на $permissions файлов?';
  }
}
