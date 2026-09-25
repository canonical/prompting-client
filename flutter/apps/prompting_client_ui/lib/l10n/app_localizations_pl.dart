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
  String get promptActionOptionDenyAlways => 'Odmawiaj zawsze';

  @override
  String get promptActionOptionDenyUntilLogout =>
      'Odmawiaj do momentu wylogowania';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Zezwalaj do momentu wylogowania';

  @override
  String get promptActionTitle => 'Czynność';

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
  String get homeCustomPathSaveButton => 'Zapisz ścieżkę niestandardową';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Wzór ścieżki musi zaczynać się od /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Dopasowuje dowolny ciąg znaków z wyjątkiem /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Dopasowuje pojedynczy znak';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Dopasowuje rekurencyjnie zero lub więcej katalogów i plików';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Dopasowuje x lub y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Uwalnia znaki specjalne od traktowania ich jako znaki dosłowne';

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
  String get homePromptMetaDataVerifiedAccountPrefix => 'Ten wydawca ma ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'zweryfikowane konto';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Ostatnio zaktualizowany dnia $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Więcej opcji...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Więcej opcji';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Odwiedź stronę Centrum oprogramowania';

  @override
  String get homePromptMetaDataAppCenterButton =>
      'Otwórz w Centrum oprogramowania';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Udziel także dostępu $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Uprawnienia';

  @override
  String get homePromptPermissionsRead => 'Odczyt';

  @override
  String get homePromptPermissionsReadOnly => 'Tylko do odczytu';

  @override
  String get homePromptPermissionsWrite => 'Zapis';

  @override
  String get homePromptPermissionsWriteOnly => 'Tylko do zapisu';

  @override
  String get homePromptPermissionsExecute => 'Wykonywanie';

  @override
  String get homePromptPermissionsExecuteOnly => 'Tylko do wykonywania';

  @override
  String get homePromptErrorUnknownTitle => 'Wystąpił problem';

  @override
  String cameraPromptBody(String snapName) {
    return 'Czy zezwolić programowi $snapName na używanie kamer?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Czy zezwolić programowi $snapName na używanie mikrofonów?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Czy udzielić programowi $snapName dostępu $permissions do plików?';
  }
}
