// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get securityCenterInfo =>
      'ამ წვდომების შეცვლა ყოველთვის შეგიძლიათ <უსაფრთხოების ცენტრიდან>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'წვდომები $snap-სთვის:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '$snap-სთვის $permission-ის მინიჭება:';
  }

  @override
  String get promptActionOptionAllow => 'დაშვება';

  @override
  String get promptActionOptionAllowAlways => 'ყოველთვის დაშვება';

  @override
  String get promptActionOptionAllowOnce => 'ერთხელ დაშვება';

  @override
  String get promptActionOptionDeny => 'აკრძალვა';

  @override
  String get promptActionOptionDenyOnce => 'ერთხელ აკრძალვა';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'ქმედება';

  @override
  String get promptLifespanOptionForever => 'ყოველთვის';

  @override
  String get promptLifespanOptionSession => 'სისტემიდან გასვლამდე';

  @override
  String get promptLifespanOptionSingle => 'ერთხელ';

  @override
  String get promptLifespanTitle => 'ხანგრძლივობა';

  @override
  String get promptSaveAndContinue => 'შენახვა და გაგრძელება';

  @override
  String get promptTitle => 'უსაფრთხოების გაფრთხილება';

  @override
  String get homePatternInfo => '<გაიგეთ მეტი ბილიკის ნიმუშების შესახებ>';

  @override
  String get homePatternTypeCustomPath => 'მორგებული ბილიკის ნიმუში';

  @override
  String get homePatternTypeRequestedDirectory => 'მხოლოდ მოთხოვნილი საქაღალდე';

  @override
  String get homePatternTypeRequestedFile => 'მხოლოდ მოთხოვნილი ფაილი';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'ყველაფერი საქაღალდეში $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'ყველაფერი საქაღალდეში';

  @override
  String get homePatternTypeContainingDirectory => 'ყველაფერი საქაღალდეში';

  @override
  String get homePatternTypeHomeDirectory => 'ყველაფერი საწყის საქაღალდეში';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'ყველა $fileExtension ფაილი';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap-ს სჭირდება $permissions წვდომა ბილიკთან $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap-ს სჭირდება $permissions წვდომა საქაღალდესთან $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap-ს სჭირდება წვდომა $permissions ფაილტან $filename საქაღალდეში $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap-ს სჭირდება წვდომა $permissions თქვენს საწყის საქაღალდესთან.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap-ს სჭირდება $permissions წვდომა ფაილთან $filename თქვენს საწყის საქაღალდეში.';
  }

  @override
  String get homePromptMetaDataTitle => 'ამ აპის შესახებ';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'გამომცემელი: $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'ბოლო განახლების დრო: $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'მეტი პარამეტრი...';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'აპების ცენტრის გვერდზე გადასვლა';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'ასევე მიეცემა წვდომა $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'წვდომები';

  @override
  String get homePromptPermissionsRead => 'წაკითხვა';

  @override
  String get homePromptPermissionsWrite => 'ჩაწერა';

  @override
  String get homePromptPermissionsExecute => 'გაშვება';

  @override
  String get homePromptErrorUnknownTitle => 'რაღაც არასწორია';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to access your microphone?';
  }
}
