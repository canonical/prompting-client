// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get securityCenterInfo => 'همیشه می‌توانید این اجازه‌ها را در «مرکز امنیت» تغییر دهید';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'تنظیم دسترسی برای $snap به:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'دادن دسترسی $permission$snap به:';
  }

  @override
  String get promptActionOptionAllow => 'اجازه';

  @override
  String get promptActionOptionAllowAlways => 'اجازه برای همیشه';

  @override
  String get promptActionOptionAllowOnce => 'اجازه برای یک بار';

  @override
  String get promptActionOptionDeny => 'رد';

  @override
  String get promptActionOptionDenyOnce => 'رد کردن برای یک بار';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'کنش';

  @override
  String get promptLifespanOptionForever => 'همیشه';

  @override
  String get promptLifespanOptionSession => 'تا خروج';

  @override
  String get promptLifespanOptionSingle => 'یک بار';

  @override
  String get promptLifespanTitle => 'مدّت';

  @override
  String get promptSaveAndContinue => 'ذخیره و ادامه';

  @override
  String get promptTitle => 'آگاهی امنیتی';

  @override
  String get homePatternInfo => '<آموزش بیش‌تر دربارهٔ الگوهای مسیر>';

  @override
  String get homePatternTypeCustomPath => 'الگوی مسیر سفارشی';

  @override
  String get homePatternTypeRequestedDirectory => 'فقط شاخهٔ درخواستی';

  @override
  String get homePatternTypeRequestedFile => 'فقط پروندهٔ درخواستی';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'همه‌چیز در شاخهٔ $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'هر چیزی در شاخه';

  @override
  String get homePatternTypeContainingDirectory => 'هر چیزی در شاخه';

  @override
  String get homePatternTypeHomeDirectory => 'همه‌چیز در شاخهٔ خانگی';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'همهٔ پرونده‌های $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap wants to get $permissions access to $path';
  }

  @override
  String homePromptTopLevelDirBody(String snap, String permissions, String foldername) {
    return '$snap wants to get $permissions access to the $foldername folder.';
  }

  @override
  String homePromptTopLevelDirFileBody(String snap, String permissions, String filename, String foldername) {
    return '$snap wants to get $permissions access to $filename in the $foldername folder.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap wants to get $permissions access to your Home folder.';
  }

  @override
  String homePromptHomeDirFileBody(String snap, String permissions, String filename) {
    return '$snap wants to get $permissions access to $filename in your Home folder.';
  }

  @override
  String get homePromptMetaDataTitle => 'دربارهٔ این کاره';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'منتشر شده به دست $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'آخرین به‌روز رسانی در $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'گزینه‌های بیش‌تر…';

  @override
  String get homePromptMetaDataAppCenterLink => 'دیدن صفحهٔ مرکز کاره';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'همچنین دادن دسترسی $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'اجازه‌ها';

  @override
  String get homePromptPermissionsRead => 'خواندن';

  @override
  String get homePromptPermissionsWrite => 'نوشتن';

  @override
  String get homePromptPermissionsExecute => 'اجرا';

  @override
  String get homePromptErrorUnknownTitle => 'Something went wrong';
}
