// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get securityCenterInfo => 'இந்த அனுமதிகளை நீங்கள் எப்போதும் <பாதுகாப்பு மையம்> இல் மாற்றலாம்';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return '$snap க்கு அணுகலை அமைக்கவும்:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '$snap $permission அணுகல் கொடுங்கள்:';
  }

  @override
  String get promptActionOptionAllow => 'இசைவு';

  @override
  String get promptActionOptionAllowAlways => 'எப்போதும் அனுமதிக்கவும்';

  @override
  String get promptActionOptionAllowOnce => 'ஒரு முறை அனுமதிக்கவும்';

  @override
  String get promptActionOptionDeny => 'மறுக்கவும்';

  @override
  String get promptActionOptionDenyOnce => 'ஒரு முறை மறுக்கவும்';

  @override
  String get promptActionTitle => 'செயல்';

  @override
  String get promptLifespanOptionForever => 'எப்போதும்';

  @override
  String get promptLifespanOptionSession => 'வெளியேறும் வரை';

  @override
  String get promptLifespanOptionSingle => 'ஒருமுறை';

  @override
  String get promptLifespanTitle => 'காலம்';

  @override
  String get promptSaveAndContinue => 'சேமித்து தொடரவும்';

  @override
  String get promptTitle => 'பாதுகாப்பு அறிவிப்பு';

  @override
  String get homePatternInfo => '<பாதை வடிவங்களைப் பற்றி அறிந்து கொள்ளுங்கள்>';

  @override
  String get homePatternTypeCustomPath => 'தனிப்பயன் பாதை முறை';

  @override
  String get homePatternTypeRequestedDirectory => 'கோரப்பட்ட கோப்புறை மட்டுமே';

  @override
  String get homePatternTypeRequestedFile => 'கோரப்பட்ட கோப்பு மட்டுமே';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir கோப்புறையில் உள்ள அனைத்தும்';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'கோப்புறையில் உள்ள அனைத்தும்';

  @override
  String get homePatternTypeContainingDirectory => 'கோப்புறையில் உள்ள அனைத்தும்';

  @override
  String get homePatternTypeHomeDirectory => 'வீட்டு கோப்புறையில் உள்ள அனைத்தும்';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'அனைத்து $fileExtension கோப்புகள்';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap wants to get $permissions access to $path';
  }

  @override
  String homePromptTopLevelDirBody(String snap, String permissions, String foldername) {
    return '$snap $permissions அணுகல் $foldername கோப்புறையைப் பெற விரும்புகிறது.';
  }

  @override
  String homePromptTopLevelDirFileBody(String snap, String permissions, String filename, String foldername) {
    return '$snap $permissions க்கு $filename அணுகல் $foldername கோப்புறையில் பெற விரும்புகிறது.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap உங்கள் வீட்டு கோப்புறையில் $permissions அணுகலைப் பெற விரும்புகிறது.';
  }

  @override
  String homePromptHomeDirFileBody(String snap, String permissions, String filename) {
    return '$snap wants to get $permissions access to $filename in your Home folder.';
  }

  @override
  String get homePromptMetaDataTitle => 'இந்த பயன்பாடு பற்றி';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return '$publisher ஆல் வெளியிடப்பட்டது';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'கடைசியாக $date இல் புதுப்பிக்கப்பட்டது';
  }

  @override
  String get homePromptMoreOptionsLabel => 'மேலும் விருப்பங்கள் ...';

  @override
  String get homePromptMetaDataAppCenterLink => 'பயன்பாட்டு மையப் பக்கத்தைப் பார்வையிடவும்';

  @override
  String homePromptSuggestedPermission(String permission) {
    return '$permission அணுகலையும் கொடுங்கள்';
  }

  @override
  String get homePromptPermissionsTitle => 'அனுமதிகள்';

  @override
  String get homePromptPermissionsRead => 'படிக்க';

  @override
  String get homePromptPermissionsWrite => 'எழுதுங்கள்';

  @override
  String get homePromptPermissionsExecute => 'செயல்படுத்தவும்';

  @override
  String get homePromptErrorUnknownTitle => 'ஏதோ தவறு நடந்தது';
}
