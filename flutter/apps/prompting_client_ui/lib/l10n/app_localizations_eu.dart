// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Baimen hauek edonoiz aldatzeko aukera duzu <Segurtasun zentroa> erabiliz';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Ezarri $snap aplikazioaren baimenak honako:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Eman $snap aplikazioari $permission baimena honako:';
  }

  @override
  String get promptActionOptionAllow => 'Baimendu';

  @override
  String get promptActionOptionAllowAlways => 'Baimendu beti';

  @override
  String get promptActionOptionAllowOnce => 'Baimendu behin';

  @override
  String get promptActionOptionDeny => 'Ukatu';

  @override
  String get promptActionOptionDenyOnce => 'Ukatu behin';

  @override
  String get promptActionOptionDenyAlways => 'Ukatu beti';

  @override
  String get promptActionOptionDenyUntilLogout => 'Ukatu saioa amaitu arte';

  @override
  String get promptActionOptionAllowUntilLogout => 'Baimendu saioa amaitu arte';

  @override
  String get promptActionTitle => 'Ekintza';

  @override
  String get promptLifespanOptionForever => 'Beti';

  @override
  String get promptLifespanOptionSession => 'Saioa amaitu arte';

  @override
  String get promptLifespanOptionSingle => 'Behin';

  @override
  String get promptLifespanTitle => 'Iraupena';

  @override
  String get promptSaveAndContinue => 'Gorde eta jarraitu';

  @override
  String get promptTitle => 'Segurtasun jakinarazpena';

  @override
  String get homePatternInfo => '<Informazio gehiago bideen patroiei buruz>';

  @override
  String get homePatternTypeCustomPath => 'Bide patroi pertsonalizatua';

  @override
  String get homeCustomPathSaveButton => 'Gorde bide pertsonalizatua';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Bide patroia / batekin hasi behar da';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Bat dator / ez beste edozein karaktere-katerekin';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Bat dator karaktere batekin';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Bat dator zero edo karpeta eta fitxategi gehiagorekin, errekurtsiboki';

  @override
  String get homeCustomPathWildcardCurlyDescription =>
      'Bat dator x edo y-rekin';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Karaktere bereziei ihes egiten die, literal gisa tratatuz';

  @override
  String get homePatternTypeRequestedDirectory => 'Eskatutako karpetan soilik';

  @override
  String get homePatternTypeRequestedFile => 'Eskatutako fitxategian soilik';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir karpetako eduki osoan';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Karpetako eduki osoan';

  @override
  String get homePatternTypeContainingDirectory => 'Karpetako eduki osoan';

  @override
  String get homePatternTypeHomeDirectory => 'Karpeta nagusiko eduki osoan';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return '$fileExtension fitxategi guztietan';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap aplikazioak $permissions baimena eskuratu nahi du honako: $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap aplikazioak $permissions baimena eskuratu nahi du $foldername karpetarako.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap aplikazioak $permissions baimena eskuratu nahi du $foldername karpetako $filename fitxategirako.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap aplikazioak $permissions baimena eskuratu nahi du karpeta nagusirako.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap aplikazioak $permissions baimena eskuratu nahi du karpeta nagusiko $filename fitxategirako.';
  }

  @override
  String get homePromptMetaDataTitle => 'Aplikazio honi buruz';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Argitaratzailea: $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Argitaratzaileak ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'egiaztatutako kontua';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Azken eguneratzea: $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Aukera gehiago...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Aukera gehiago';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Bisitatu Aplikazioen zentroaren orria';

  @override
  String get homePromptMetaDataAppCenterButton => 'Ireki Aplikazioen zentroan';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Eman $permission baimena ere';
  }

  @override
  String get homePromptPermissionsTitle => 'Baimenak';

  @override
  String get homePromptPermissionsRead => 'Irakurri';

  @override
  String get homePromptPermissionsReadOnly => 'Irakurri soilik';

  @override
  String get homePromptPermissionsWrite => 'Idatzi';

  @override
  String get homePromptPermissionsWriteOnly => 'Idatzi soilik';

  @override
  String get homePromptPermissionsExecute => 'Exekutatu';

  @override
  String get homePromptPermissionsExecuteOnly => 'Exekutatu soilik';

  @override
  String get homePromptErrorUnknownTitle => 'Zerbaitek huts egin du';

  @override
  String cameraPromptBody(String snapName) {
    return 'Baimendu $snapName aplikazioari kamerak erabiltzea?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Baimendu $snapName aplikazioari mikrofonoak erabiltzea?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Eman $snapName aplikazioari fitxategientzako $permissions baimena?';
  }
}
