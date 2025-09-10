// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Irish (`ga`).
class AppLocalizationsGa extends AppLocalizations {
  AppLocalizationsGa([String locale = 'ga']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Is féidir leat na ceadanna seo a athrú i gcónaí sa <Lárionad Slándála>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Socraigh rochtain le haghaidh $snap chuig:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Tabhair rochtain do $snap $permission ar:';
  }

  @override
  String get promptActionOptionAllow => 'Ceadaigh';

  @override
  String get promptActionOptionAllowAlways => 'Ceadaigh i gcónaí';

  @override
  String get promptActionOptionAllowOnce => 'Ceadaigh uair amháin';

  @override
  String get promptActionOptionDeny => 'Diúltaigh';

  @override
  String get promptActionOptionDenyOnce => 'Séanadh uair amháin';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Gníomh';

  @override
  String get promptLifespanOptionForever => 'I gcónaí';

  @override
  String get promptLifespanOptionSession => 'Go dtí logáil amach';

  @override
  String get promptLifespanOptionSingle => 'Uair amháin';

  @override
  String get promptLifespanTitle => 'Fad';

  @override
  String get promptSaveAndContinue => 'Sábháil agus lean ar aghaidh';

  @override
  String get promptTitle => 'Fógra slándála';

  @override
  String get homePatternInfo => '<Foghlaim faoi phatrúin cosán>';

  @override
  String get homePatternTypeCustomPath => 'Patrún cosán saincheaptha';

  @override
  String get homePatternTypeRequestedDirectory => 'An fillteán iarrtha amháin';

  @override
  String get homePatternTypeRequestedFile => 'An comhad iarrtha amháin';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Gach rud san fhillteán $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Gach rud san fhillteán';

  @override
  String get homePatternTypeContainingDirectory => 'Gach rud san fhillteán';

  @override
  String get homePatternTypeHomeDirectory => 'Gach rud san fhillteán Baile';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Gach comhad $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return 'Ba mhaith le $snap rochtain a fháil ar $permissions ar $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return 'Ba mhaith le $snap rochtain a fháil ar $permissions ar an bhfillteán $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return 'Tá $snap ag iarraidh $permissions rochtain a fháil ar $filename san fhillteán $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return 'Tá $snap ag iarraidh $permissions a rochtain ar d\'fhillteán Baile.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return 'Tá $snap ag iarraidh rochtain a fháil ar $permissions ar $filename i d\'fhillteán Baile.';
  }

  @override
  String get homePromptMetaDataTitle => 'Maidir leis an aip seo';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Arna fhoilsiú ag $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Nuashonraithe ar $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Tuilleadh roghanna...';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Tabhair cuairt ar leathanach App Centre';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Tabhair rochtain $permission freisin';
  }

  @override
  String get homePromptPermissionsTitle => 'Ceadanna';

  @override
  String get homePromptPermissionsRead => 'Léigh';

  @override
  String get homePromptPermissionsWrite => 'Scríobh';

  @override
  String get homePromptPermissionsExecute => 'Rith';

  @override
  String get homePromptErrorUnknownTitle => 'Chuaigh rud éigin mícheart';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }
}
