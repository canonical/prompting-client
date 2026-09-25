// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Du kan alltid ändra dessa behörigheter i <Säkerhetscenter>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Ställ in åtkomst för $snap till:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Ge $snap $permission-åtkomst till:';
  }

  @override
  String get promptActionOptionAllow => 'Tillåt';

  @override
  String get promptActionOptionAllowAlways => 'Tillåt alltid';

  @override
  String get promptActionOptionAllowOnce => 'Tillåt en gång';

  @override
  String get promptActionOptionDeny => 'Neka';

  @override
  String get promptActionOptionDenyOnce => 'Neka en gång';

  @override
  String get promptActionOptionDenyAlways => 'Neka alltid';

  @override
  String get promptActionOptionDenyUntilLogout => 'Neka till nästa utloggning';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Tillåt fram till utloggning';

  @override
  String get promptActionTitle => 'Åtgärd';

  @override
  String get promptLifespanOptionForever => 'Alltid';

  @override
  String get promptLifespanOptionSession => 'Tills utloggning';

  @override
  String get promptLifespanOptionSingle => 'En gång';

  @override
  String get promptLifespanTitle => 'Varaktighet';

  @override
  String get promptSaveAndContinue => 'Spara och fortsätt';

  @override
  String get promptTitle => 'Säkerhetsavisering';

  @override
  String get homePatternInfo => '<Läs mer om sökvägsmönster>';

  @override
  String get homePatternTypeCustomPath => 'Anpassat sökvägsmönster';

  @override
  String get homeCustomPathSaveButton => 'Spara egen sökväg';

  @override
  String get homeCustomPathMustStartWithSlash => 'Sökvägen måste inledas med /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Matchar alla teckensträngar förutom /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Matchar enstaka tecken';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Matchar noll eller flera mappar och filer rekursivt';

  @override
  String get homeCustomPathWildcardCurlyDescription =>
      'Matchar antingen x eller y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Gör undantag för specialtecken och behandlar dem som vanlig text';

  @override
  String get homePatternTypeRequestedDirectory => 'Endast begärd mapp';

  @override
  String get homePatternTypeRequestedFile => 'Endast begärd fil';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Allting i $topLevelDir-mappen';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Allting i mappen';

  @override
  String get homePatternTypeContainingDirectory => 'Allting i mappen';

  @override
  String get homePatternTypeHomeDirectory => 'Allting i hemkatalogen';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Alla $fileExtension-filer';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap vill få $permissions-åtkomst till $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap vill få $permissions-åtkomst till mappen $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap vill få $permissions-åtkomst till $filename i mappen $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap vill få $permissions-åtkomst till din hemmapp.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap vill få $permissions-åtkomst till $filename i din hemmapp.';
  }

  @override
  String get homePromptMetaDataTitle => 'Om detta program';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publicerad av $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Utgivaren har ett ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verifierat konto';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Senast uppdaterad $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Fler alternativ...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Fler alternativ';

  @override
  String get homePromptMetaDataAppCenterLink => 'Visa Appcentral-sidan';

  @override
  String get homePromptMetaDataAppCenterButton => 'Öppna i Appcentralen';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Ge också $permission-åtkomst';
  }

  @override
  String get homePromptPermissionsTitle => 'Behörigheter';

  @override
  String get homePromptPermissionsRead => 'Läs';

  @override
  String get homePromptPermissionsReadOnly => 'Läs endast';

  @override
  String get homePromptPermissionsWrite => 'Skriv';

  @override
  String get homePromptPermissionsWriteOnly => 'Skriv endast';

  @override
  String get homePromptPermissionsExecute => 'Exekvera';

  @override
  String get homePromptPermissionsExecuteOnly => 'Exekvera endast';

  @override
  String get homePromptErrorUnknownTitle => 'Någonting gick fel';

  @override
  String cameraPromptBody(String snapName) {
    return 'Tillåt $snapName att använda dina kameror?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Tillåt $snapName att använda dina mikrofoner?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Ge $snapName åtkomstnivå $permissions till filer?';
  }
}
