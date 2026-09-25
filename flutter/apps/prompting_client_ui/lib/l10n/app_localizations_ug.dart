// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uighur Uyghur (`ug`).
class AppLocalizationsUg extends AppLocalizations {
  AppLocalizationsUg([String locale = 'ug']) : super(locale);

  @override
  String get securityCenterInfo =>
      'سىز بۇ ئىجازەتلەرنى خالىغان ۋاقىتتا ‹بىخەتەرلىك مەركىزى› دىن ئۆزگەرتەلەيسىز';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return '$snap ئىجازىتىنى تەڭشەيدۇ:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '$snap غا $permission ئىجازىتى بېرىلىدۇ:';
  }

  @override
  String get promptActionOptionAllow => 'يول قوي';

  @override
  String get promptActionOptionAllowAlways => 'ھەمىشە يول قوي';

  @override
  String get promptActionOptionAllowOnce => 'بىر قېتىم يول قوي';

  @override
  String get promptActionOptionDeny => 'رەت قىل';

  @override
  String get promptActionOptionDenyOnce => 'بىر قېتىم رەت قىل';

  @override
  String get promptActionOptionDenyAlways => 'ھەمىشە رەت قىل';

  @override
  String get promptActionOptionDenyUntilLogout => 'تىزىمدىن چىقمىغۇچە رەت قىل';

  @override
  String get promptActionOptionAllowUntilLogout => 'تىزىمدىن چىققۇچە يول قوي';

  @override
  String get promptActionTitle => 'مەشغۇلات';

  @override
  String get promptLifespanOptionForever => 'ھەمىشە';

  @override
  String get promptLifespanOptionSession => 'تىزىمدىن چىققۇچە';

  @override
  String get promptLifespanOptionSingle => 'بىر قېتىم';

  @override
  String get promptLifespanTitle => 'مۇددىتى';

  @override
  String get promptSaveAndContinue => 'ساقلاپ داۋاملاشتۇر';

  @override
  String get promptTitle => 'بىخەتەرلىك ئۇقتۇرۇشى';

  @override
  String get homePatternInfo => '‹يول ئەندىزىسى ھەققىدىكى بىلىم›';

  @override
  String get homePatternTypeCustomPath => 'ئىختىيارى يول ئەندىزىسى';

  @override
  String get homeCustomPathSaveButton => 'ئىختىيارى يولنى ساقلا';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'يول ئەندىزىسى چوقۇم / بىلەن باشلىنىدۇ';

  @override
  String get homeCustomPathWildcardStarDescription =>
      '/ دىن باشقا ھەر قانداق ھەرپ تىزىقى ماس كېلىدۇ';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'يەككە ھەرپ ماس كېلىدۇ';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'نۆل ياكى تېخىمۇ كۆپ قىسقۇچ ۋە ھۆججەتنى قايتا-قايتا ماسلاشتۇرىدۇ';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'x ياكى y غا ماس كېلىدۇ';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'ئۇلارغا يېزىق سۈپىتىدە مۇئامىلە قىلىش ئۈچۈن ئالاھىدە ھەرپنىڭ مەنىسى ئۆزگىرىدۇ';

  @override
  String get homePatternTypeRequestedDirectory => 'ئىلتىماس قىلىنغان قىسقۇچلا';

  @override
  String get homePatternTypeRequestedFile => 'ئىلتىماس قىلىنغان ھۆججەتلا';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir قىسقۇچتىكى ھەممىسى';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'قىسقۇچتىكى ھەممىسى';

  @override
  String get homePatternTypeContainingDirectory => 'قىسقۇچتىكى ھەممىسى';

  @override
  String get homePatternTypeHomeDirectory => 'باش قىسقۇچتىكى ھەممىسى';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return '$fileExtension ھۆججەتنىڭ ھەممىسى';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap نىڭ ئېرىشمەكچى بولغىنى $path نىڭ $permissions ئىجازىتى';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap نىڭ ئېرىشمەكچى بولغىنى $foldername قىسقۇچنىڭ $permissions ئىجازىتى.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap نىڭ ئېرىشمەكچى بولغىنى $foldername قىسقۇچتىكى $filename نىڭ $permissions ئىجازىتى.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap نىڭ ئېرىشمەكچى بولغىنى باش قىسقۇچنىڭ $permissions ئىجازىتى.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap نىڭ ئېرىشمەكچى بولغىنى باش قىسقۇچتىكى $filename نىڭ $permissions ئىجازىتى.';
  }

  @override
  String get homePromptMetaDataTitle => 'بۇ ئەپ ھەققىدە';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'تارقاتقۇچى $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'بۇ تارقاتقۇچى ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'دەلىللەنگەن ھېساب';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'ئاخىرقى قېتىم يېڭىلانغان ۋاقىت $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'تېخىمۇ كۆپ تاللانما…';

  @override
  String get homePromptMoreOptionsTileLabel => 'تېخىمۇ كۆپ تاللانما';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'ئەپ مەركىزى بېتىنى زىيارەت قىلىڭ';

  @override
  String get homePromptMetaDataAppCenterButton => 'ئەپ مەركىزىدە ئاچ';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'يەنە $permission ئىجازىتى بېرىدۇ';
  }

  @override
  String get homePromptPermissionsTitle => 'ئىجازەت';

  @override
  String get homePromptPermissionsRead => 'ئوقۇش';

  @override
  String get homePromptPermissionsReadOnly => 'ئوقۇشقىلا';

  @override
  String get homePromptPermissionsWrite => 'يېزىش';

  @override
  String get homePromptPermissionsWriteOnly => 'يېزىشقىلا';

  @override
  String get homePromptPermissionsExecute => 'ئىجرا قىلىش';

  @override
  String get homePromptPermissionsExecuteOnly => 'ئىجرا قىلىشقىلا';

  @override
  String get homePromptErrorUnknownTitle => 'كاشىلا كۆرۈلدى';

  @override
  String cameraPromptBody(String snapName) {
    return '$snapName نىڭ كامېرايىڭىزنى ئىشلىتىشىگە يول قويامسىز؟';
  }

  @override
  String microphonePromptBody(String snapName) {
    return '$snapName نىڭ مىكروفونلىرىڭىزنى ئىشلىتىشىگە يول قويامسىز؟';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return '$snapName نىڭ ھۆججەتنى زىيارەت قىلىشىغا $permissions ئىجازەت بېرەمدۇ؟';
  }
}
