// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Ви завжди можете змінити ці дозволи в <Центрі безпеки>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Налаштувати доступ для $snap на:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Надати $snap доступ на $permission:';
  }

  @override
  String get promptActionOptionAllow => 'Дозволити';

  @override
  String get promptActionOptionAllowAlways => 'Завжди дозволяти';

  @override
  String get promptActionOptionAllowOnce => 'Дозволити один раз';

  @override
  String get promptActionOptionDeny => 'Відмовити';

  @override
  String get promptActionOptionDenyOnce => 'Відмовити один раз';

  @override
  String get promptActionOptionDenyAlways => 'Завжди забороняти';

  @override
  String get promptActionOptionDenyUntilLogout =>
      'Заборонити до виходу з системи';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Дозволити до виходу з системи';

  @override
  String get promptActionTitle => 'Дія';

  @override
  String get promptLifespanOptionForever => 'Завжди';

  @override
  String get promptLifespanOptionSession => 'До виходу з системи';

  @override
  String get promptLifespanOptionSingle => 'Один раз';

  @override
  String get promptLifespanTitle => 'Тривалість';

  @override
  String get promptSaveAndContinue => 'Зберегти та продовжити';

  @override
  String get promptTitle => 'Сповіщення безпеки';

  @override
  String get homePatternInfo => '<Докладніше про шаблони шляху>';

  @override
  String get homePatternTypeCustomPath => 'Користувацький шаблон шляху';

  @override
  String get homeCustomPathSaveButton => 'Зберегти користувацький шлях';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Шаблон шляху має починатись з /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Збігається з будь-яким рядком символів, окрім /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Збігається з одним символом';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Рекурсивно знаходить нуль або більше тек та файлів';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Збігається з x, або y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Використовується для екранування спеціальних символів для обробки їх як літералів';

  @override
  String get homePatternTypeRequestedDirectory => 'Лише запитувана тека';

  @override
  String get homePatternTypeRequestedFile => 'Лише запитуваний файл';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Усе в теці $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Усе в теці';

  @override
  String get homePatternTypeContainingDirectory => 'Усе в теці';

  @override
  String get homePatternTypeHomeDirectory => 'Усе в теці Домівка';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Усі файли $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap хоче отримати дозвіл $permissions на доступ до $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap хоче отримати дозвіл $permissions до теки $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap хоче отримати дозвіл $permissions до $filename у теці $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap хоче отримати дозвіл $permissions до вашої домашньої теки.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap хоче отримати доступ $permissions до $filename у вашій домашній теці.';
  }

  @override
  String get homePromptMetaDataTitle => 'Про цей застосунок';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Опубліковано $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Цей видавець має ';

  @override
  String get homePromptMetaDataVerifiedAccountLink =>
      'підтверджений обліковий запис';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Востаннє оновлено $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Інші опції...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Інші опції';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Відвідати сторінку Центру застосунків';

  @override
  String get homePromptMetaDataAppCenterButton =>
      'Відкрити у Центрі програмного забезпечення';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Також надати доступ на $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Дозволи';

  @override
  String get homePromptPermissionsRead => 'Читання';

  @override
  String get homePromptPermissionsReadOnly => 'Тільки читання';

  @override
  String get homePromptPermissionsWrite => 'Запис';

  @override
  String get homePromptPermissionsWriteOnly => 'Тільки запис';

  @override
  String get homePromptPermissionsExecute => 'Виконання';

  @override
  String get homePromptPermissionsExecuteOnly => 'Тільки виконання';

  @override
  String get homePromptErrorUnknownTitle => 'Щось пішло не за планом';

  @override
  String cameraPromptBody(String snapName) {
    return 'Дозволити $snapName використовувати вашу камеру?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Дозволити $snapName використовувати ваш мікрофон?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Надати $snapName $permissions доступ до файлів?';
  }
}
