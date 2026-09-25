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
  String get promptActionOptionDenyAlways => 'ყოველთვის აკრძალვა';

  @override
  String get promptActionOptionDenyUntilLogout => 'აკრძალვა გასვლამდე';

  @override
  String get promptActionOptionAllowUntilLogout => 'დაშვება გასვლამდე';

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
  String get homeCustomPathSaveButton => 'მორგებული ბილიკის შენახვა';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'ბილიკის ნიმუში უნდა იწყებოდეს სიმბოლოთი /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'ემთხვევა სიმბოლოების ნებისმიერ სტრიქონს, /-ის გარდა';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'ემთხვევა ერთ სიმბოლოს';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'ახდენს ნული, ან მეტი საქაღალდისა და ფაილის დამთხვევას რეკურსიულად';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'ემთხვევა x-ს, ან y-ს';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'გადაამუშავებს სპეციალურ სიმბოლოებს ასოებად';

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
  String get homePromptMetaDataVerifiedAccountPrefix => 'ამ გამომცემელს აქვს ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'გადამოწმებული ანგარიში';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'ბოლო განახლების დრო: $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'მეტი პარამეტრი...';

  @override
  String get homePromptMoreOptionsTileLabel => 'მეტი პარამეტრი';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'აპების ცენტრის გვერდზე გადასვლა';

  @override
  String get homePromptMetaDataAppCenterButton => 'გახსნა აპების ცენტრში';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'ასევე მიეცემა წვდომა $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'წვდომები';

  @override
  String get homePromptPermissionsRead => 'წაკითხვა';

  @override
  String get homePromptPermissionsReadOnly => 'მხოლოდ წაკითხვადი';

  @override
  String get homePromptPermissionsWrite => 'ჩაწერა';

  @override
  String get homePromptPermissionsWriteOnly => 'მხოლოდ ჩაწერადი';

  @override
  String get homePromptPermissionsExecute => 'გაშვება';

  @override
  String get homePromptPermissionsExecuteOnly => 'მხოლოდ გაშვებადი';

  @override
  String get homePromptErrorUnknownTitle => 'რაღაც არასწორია';

  @override
  String cameraPromptBody(String snapName) {
    return 'დაუშვებთ, $snapName-მა გამოიყენოს თქვენი კამერა?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'დაუშვებთ, $snapName-მა გამოიყენოს თქვენი მიკროფონი?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'მიეცეს $snapName $permissions წვდომა ფაილებზე?';
  }
}
