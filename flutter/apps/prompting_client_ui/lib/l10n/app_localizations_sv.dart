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
    return 'Ge $snap $permission åtkomst till:';
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
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

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
  String get promptTitle => 'Säkerhetsnotifiering';

  @override
  String get homePatternInfo => '<Läs mer om sökvägsmönster>';

  @override
  String get homePatternTypeCustomPath => 'Anpassat sökvägsmönster';

  @override
  String get homeCustomPathSaveButton => 'Save custom path';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'The path pattern must start with /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Matches any string of characters except /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Matches a single character';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Matches zero or more folders and files recursively';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Matches either x or y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Escapes special characters to treat them as literals';

  @override
  String get homePatternTypeRequestedDirectory => 'Den begärda mappen endast';

  @override
  String get homePatternTypeRequestedFile => 'Den begärda filen endast';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Allt i $topLevelDir-mappen';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Allt i mappen';

  @override
  String get homePatternTypeContainingDirectory => 'Allt i mappen';

  @override
  String get homePatternTypeHomeDirectory => 'Allt i hemkatalogen';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Alla $fileExtension filer';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap vill få $permissions åtkomst till $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap vill få $permissions tillgång till $foldername mapp.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap vill få $permissions åtkomst till $filename i $foldername mappen.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap vill få $permissions till din hemmapp.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap vill få $permissions åtkomst till $filename i din hemmapp.';
  }

  @override
  String get homePromptMetaDataTitle => 'Om detta program';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Publicerad av $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'This publisher has a ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verified account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Senast uppdaterad på $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Mer alternativ...';

  @override
  String get homePromptMoreOptionsTileLabel => 'More options';

  @override
  String get homePromptMetaDataAppCenterLink => 'Visa Appcentral sida';

  @override
  String get homePromptMetaDataAppCenterButton => 'Open in App Center';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Också ge $permission tillgång';
  }

  @override
  String get homePromptPermissionsTitle => 'Behörigheter';

  @override
  String get homePromptPermissionsRead => 'Läs';

  @override
  String get homePromptPermissionsReadOnly => 'Read only';

  @override
  String get homePromptPermissionsWrite => 'Skriv';

  @override
  String get homePromptPermissionsWriteOnly => 'Write only';

  @override
  String get homePromptPermissionsExecute => 'Exekvera';

  @override
  String get homePromptPermissionsExecuteOnly => 'Execute only';

  @override
  String get homePromptErrorUnknownTitle => 'Någonting gick fel';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to use your cameras?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Allow $snapName to use your microphones?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Give $snapName $permissions access to files?';
  }
}
