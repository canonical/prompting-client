// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Sie können diese Berechtigungen jederzeit im <Sicherheitszentrum> ändern';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Zugriff für $snap festlegen auf:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '$snap den Zugriff $permission geben zu:';
  }

  @override
  String get promptActionOptionAllow => 'Erlauben';

  @override
  String get promptActionOptionAllowAlways => 'Immer zulassen';

  @override
  String get promptActionOptionAllowOnce => 'Einmal zulassen';

  @override
  String get promptActionOptionDeny => 'Verweigern';

  @override
  String get promptActionOptionDenyOnce => 'Einmal verweigern';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Aktion';

  @override
  String get promptLifespanOptionForever => 'Immer';

  @override
  String get promptLifespanOptionSession => 'Bis zur Abmeldung';

  @override
  String get promptLifespanOptionSingle => 'Einmal';

  @override
  String get promptLifespanTitle => 'Dauer';

  @override
  String get promptSaveAndContinue => 'Speichern und fortfahren';

  @override
  String get promptTitle => 'Sicherheitsbenachrichtigung';

  @override
  String get homePatternInfo => '<Etwas über Pfadmuster erfahren>';

  @override
  String get homePatternTypeCustomPath => 'Benutzerdefiniertes Pfadmuster';

  @override
  String get homePatternTypeRequestedDirectory => 'Nur der angeforderte Ordner';

  @override
  String get homePatternTypeRequestedFile => 'Nur die angeforderte Datei';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Alles im Ordner $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Alles im Ordner';

  @override
  String get homePatternTypeContainingDirectory => 'Alles im Ordner';

  @override
  String get homePatternTypeHomeDirectory => 'Alles im Benutzerordner';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Alle $fileExtension-Dateien';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap möchte Zugriff zum $permissions auf $path erhalten';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap möchte Zugriff zum $permissions auf Ordner $foldername erhalten.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap möchte Zugriff zum $permissions auf $filename im Ordner $foldername erhalten.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap möchte Zugriff zum $permissions auf Ihren Benutzerordner erhalten.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap möchte Zugriff zum $permissions auf $filename in Ihrem Benutzerordner erhalten.';
  }

  @override
  String get homePromptMetaDataTitle => 'Über diese App';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Herausgegeben von $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Zuletzt aktualisiert am $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Weitere Optionen ...';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Seite des App-Zentrums besuchen';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Auch Zugriff für $permission geben';
  }

  @override
  String get homePromptPermissionsTitle => 'Berechtigungen';

  @override
  String get homePromptPermissionsRead => 'Lesen';

  @override
  String get homePromptPermissionsWrite => 'Schreiben';

  @override
  String get homePromptPermissionsExecute => 'Ausführen';

  @override
  String get homePromptErrorUnknownTitle => 'Etwas ist schiefgelaufen';

  @override
  String cameraPromptBody(String snapName) {
    return 'Allow $snapName to access your camera?';
  }
}
