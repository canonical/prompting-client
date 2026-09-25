// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get securityCenterInfo =>
      'תמיד אפשר לשנות את ההרשאות האלה ב<מרכז האבטחה>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'הגדרת גישה ל־$snap אל:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'להעניק ל־$snap גישת $permission אל:';
  }

  @override
  String get promptActionOptionAllow => 'לאפשר';

  @override
  String get promptActionOptionAllowAlways => 'לאפשר תמיד';

  @override
  String get promptActionOptionAllowOnce => 'לאפשר חד־פעמית';

  @override
  String get promptActionOptionDeny => 'לדחות';

  @override
  String get promptActionOptionDenyOnce => 'לדחות חד־פעמית';

  @override
  String get promptActionOptionDenyAlways => 'לדחות תמיד';

  @override
  String get promptActionOptionDenyUntilLogout => 'לדחות עד ליציאה';

  @override
  String get promptActionOptionAllowUntilLogout => 'לאפשר עד ליציאה מהמערכת';

  @override
  String get promptActionTitle => 'פעולה';

  @override
  String get promptLifespanOptionForever => 'תמיד';

  @override
  String get promptLifespanOptionSession => 'עד היציאה מהמערכת';

  @override
  String get promptLifespanOptionSingle => 'חד־פעמית';

  @override
  String get promptLifespanTitle => 'משך';

  @override
  String get promptSaveAndContinue => 'לשמור ולהמשיך';

  @override
  String get promptTitle => 'התראת אבטחה';

  @override
  String get homePatternInfo => '<מידע על תבניות נתיבים>';

  @override
  String get homePatternTypeCustomPath => 'תבנית נתיב מותאמת אישית';

  @override
  String get homeCustomPathSaveButton => 'לשמור נתיב מותאם אישית';

  @override
  String get homeCustomPathMustStartWithSlash => 'תבנית הנתיב חייבת להיפתח ב־/';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'לוכד כל מחרוזת של תווים למעט /';

  @override
  String get homeCustomPathWildcardQuestionDescription => 'לוכד תו יחיד';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'לוכד אפס תיקיות וקבצים או יותר באופן נסוג';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'לוכד את א׳ או ב׳';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'סולק תווים מיוחדים כדי להתייחס אליהם מפורשות';

  @override
  String get homePatternTypeRequestedDirectory => 'התיקייה המבוקשת בלבד';

  @override
  String get homePatternTypeRequestedFile => 'הקובץ המבוקש בלבד';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'הכול בתיקיית $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'הכול בתיקייה';

  @override
  String get homePatternTypeContainingDirectory => 'הכול בתיקייה';

  @override
  String get homePatternTypeHomeDirectory => 'הכול בתיקיית הבית';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'כל קובצי ה־$fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap רוצה לקבל גישת $permissions אל $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap רוצה לקבל גישת $permissions אל התיקייה $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap רוצה לקבל גישת $permissions אל הקובץ $filename שבתיקייה $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap רוצה לקבל גישת $permissions לתיקיית הבית שלך.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap רוצה לקבל גישת $permissions אל הקובץ $filename שבתיקיית הבית שלך.';
  }

  @override
  String get homePromptMetaDataTitle => 'על היישום הזה';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'פורסם על ידי $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'למפיץ הזה יש ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'חשבון מאומת';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'עדכון אחרון ב־$date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'אפשרויות נוספות…';

  @override
  String get homePromptMoreOptionsTileLabel => 'אפשרויות נוספות';

  @override
  String get homePromptMetaDataAppCenterLink => 'ביקור בעמוד מרכז היישומים';

  @override
  String get homePromptMetaDataAppCenterButton => 'פתיחה במרכז היישומים';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'להעניק גם גישת $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'הרשאות';

  @override
  String get homePromptPermissionsRead => 'קריאה';

  @override
  String get homePromptPermissionsReadOnly => 'קריאה בלבד';

  @override
  String get homePromptPermissionsWrite => 'כתיבה';

  @override
  String get homePromptPermissionsWriteOnly => 'כתיבה בלבד';

  @override
  String get homePromptPermissionsExecute => 'הפעלה';

  @override
  String get homePromptPermissionsExecuteOnly => 'הרצה בלבד';

  @override
  String get homePromptErrorUnknownTitle => 'משהו השתבש';

  @override
  String cameraPromptBody(String snapName) {
    return 'לאפשר ל־$snapName להשתמש במצלמות שלך?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'לאפשר ל־$snapName להשתמש במיקרופונים שלך?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'להעניק ל־$snapName גישת $permissions לקבצים?';
  }
}
