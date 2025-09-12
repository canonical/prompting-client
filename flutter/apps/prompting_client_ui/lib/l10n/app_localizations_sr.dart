// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Увек можете променити ова овлашћења у <Security Center>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Поставите приступ за $snap на:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Дајте $snap приступ $permission на:';
  }

  @override
  String get promptActionOptionAllow => 'Дозволи';

  @override
  String get promptActionOptionAllowAlways => 'Увек дозволи';

  @override
  String get promptActionOptionAllowOnce => 'Дозволи једном';

  @override
  String get promptActionOptionDeny => 'Одбиј';

  @override
  String get promptActionOptionDenyOnce => 'Одбиј једном';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Акција';

  @override
  String get promptLifespanOptionForever => 'Увек';

  @override
  String get promptLifespanOptionSession => 'До одјаве';

  @override
  String get promptLifespanOptionSingle => 'Једном';

  @override
  String get promptLifespanTitle => 'Трајање';

  @override
  String get promptSaveAndContinue => 'Сачувај и настави';

  @override
  String get promptTitle => 'Безбедносно обавештење';

  @override
  String get homePatternInfo => '<Сазнајте више о обрасцима путања>';

  @override
  String get homePatternTypeCustomPath => 'Прилагођени образац путање';

  @override
  String get homePatternTypeRequestedDirectory => 'Само тражени фолдер';

  @override
  String get homePatternTypeRequestedFile => 'Само тражени фајл';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Све у $topLevelDir фолдеру';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Све у фолдеру';

  @override
  String get homePatternTypeContainingDirectory => 'Све у фолдеру';

  @override
  String get homePatternTypeHomeDirectory => 'Све у Home фолдеру';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Сви фајлови са екстензијом $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap жели да добије $permissions приступ до $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap жели да добије $permissions приступ до фасцикле $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap жели да добије $permissions приступ до $filename у фасцикли $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap жели да добије $permissions приступ до ваше почетне фасцикле.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap жели да добије $permissions приступ до $filename у вашој почетној фасцикли.';
  }

  @override
  String get homePromptMetaDataTitle => 'О овој апликацији';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Објавио $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Последњи пут ажурирано $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Више опција...';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Посетите страницу App Center-а';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Такође дај $permission приступ';
  }

  @override
  String get homePromptPermissionsTitle => 'Овлашћења';

  @override
  String get homePromptPermissionsRead => 'Читање';

  @override
  String get homePromptPermissionsWrite => 'Писање';

  @override
  String get homePromptPermissionsExecute => 'Извршавање';

  @override
  String get homePromptErrorUnknownTitle => 'Нешто је пошло наопако';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to access your microphone?';
  }
}
