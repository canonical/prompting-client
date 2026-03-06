// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Te uprawnienia możesz zawsze zmienić w <Centrum zabezpieczeń>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Ustaw dostęp dla $snap na:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Udziel $snap dostępu $permission do:';
  }

  @override
  String get promptActionOptionAllow => 'Zezwól';

  @override
  String get promptActionOptionAllowAlways => 'Zezwalaj zawsze';

  @override
  String get promptActionOptionAllowOnce => 'Zezwól raz';

  @override
  String get promptActionOptionDeny => 'Odmów';

  @override
  String get promptActionOptionDenyOnce => 'Odmów raz';

  @override
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Działanie';

  @override
  String get promptLifespanOptionForever => 'Zawsze';

  @override
  String get promptLifespanOptionSession => 'Do czasu wylogowania';

  @override
  String get promptLifespanOptionSingle => 'Raz';

  @override
  String get promptLifespanTitle => 'Czas trwania';

  @override
  String get promptSaveAndContinue => 'Zapisz i kontynuuj';

  @override
  String get promptTitle => 'Powiadomienie o zabezpieczeniach';

  @override
  String get homePatternInfo => '<Dowiedz się więcej o wzorcach ścieżek>';

  @override
  String get homePatternTypeCustomPath => 'Niestandardowy wzorzec ścieżki';

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
  String get homePatternTypeRequestedDirectory => 'Tylko żądany katalog';

  @override
  String get homePatternTypeRequestedFile => 'Tylko żądany plik';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Wszystko w katalogu $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Wszystko w katalogu';

  @override
  String get homePatternTypeContainingDirectory => 'Wszystko w katalogu';

  @override
  String get homePatternTypeHomeDirectory => 'Wszystko w katalogu domowym';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Wszystkie pliki $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap chce uzyskać dostęp na poziomie $permissions do $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap chce uzyskać dostęp na poziomie $permissions do katalogu $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap chce uzyskać dostęp na poziomie $permissions do $filename w katalogu $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap chce uzyskać dostęp na poziomie $permissions do Twojego folderu domowego.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap chce uzyskać dostęp na poziomie $permissions do $filename w Twoim folderze domowym.';
  }

  @override
  String get homePromptMetaDataTitle => 'O tym programie';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Opublikowany przez $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'This publisher has a ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verified account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Ostatnio zaktualizowany dnia $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Więcej opcji...';

  @override
  String get homePromptMoreOptionsTileLabel => 'More options';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Odwiedź stronę Centrum oprogramowania';

  @override
  String get homePromptMetaDataAppCenterButton => 'Open in App Center';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Udziel także dostępu $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Uprawnienia';

  @override
  String get homePromptPermissionsRead => 'Odczyt';

  @override
  String get homePromptPermissionsReadOnly => 'Read only';

  @override
  String get homePromptPermissionsWrite => 'Zapis';

  @override
  String get homePromptPermissionsWriteOnly => 'Write only';

  @override
  String get homePromptPermissionsExecute => 'Wykonywanie';

  @override
  String get homePromptPermissionsExecuteOnly => 'Execute only';

  @override
  String get homePromptErrorUnknownTitle => 'Wystąpił problem';

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
