// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Bu izinleri her zaman <Güvenlik Merkezi>\'nden değiştirebilirsiniz';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return '$snap için erişimi şu şekilde ayarlayın:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '$snap\'e $permission erişim izni verin:';
  }

  @override
  String get promptActionOptionAllow => 'İzin ver';

  @override
  String get promptActionOptionAllowAlways => 'Her zaman izin ver';

  @override
  String get promptActionOptionAllowOnce => 'Bir kez izin ver';

  @override
  String get promptActionOptionDeny => 'Reddet';

  @override
  String get promptActionOptionDenyOnce => 'Bir kez reddet';

  @override
  String get promptActionOptionDenyAlways => 'Deny always';

  @override
  String get promptActionOptionDenyUntilLogout => 'Deny until logout';

  @override
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Aksiyon';

  @override
  String get promptLifespanOptionForever => 'Her zaman';

  @override
  String get promptLifespanOptionSession => 'Çıkış yapana kadar';

  @override
  String get promptLifespanOptionSingle => 'Bir kez';

  @override
  String get promptLifespanTitle => 'Süre';

  @override
  String get promptSaveAndContinue => 'Kaydet ve devam et';

  @override
  String get promptTitle => 'Güvenlik bildirimleri';

  @override
  String get homePatternInfo => '<Yol desenleri hakkında bilgi edinin>';

  @override
  String get homePatternTypeCustomPath => 'Özel yol deseni';

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
  String get homePatternTypeRequestedDirectory => 'Yalnızca istenen klasör';

  @override
  String get homePatternTypeRequestedFile => 'Yalnızca istenen dosya';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return '$topLevelDir klasöründeki her şey';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Klasördeki her şey';

  @override
  String get homePatternTypeContainingDirectory => 'Klasördeki her şey';

  @override
  String get homePatternTypeHomeDirectory => 'Ana klasördeki her şey';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Tüm $fileExtension dosyaları';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap, $path yoluna $permissions erişimi elde etmek istiyor';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap, $foldername klasörüne $permissions erişimi almak istiyor.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap, $foldername klasöründeki $filename dosyasına $permissions erişimi almak istiyor.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap Ana klasörünüze $permissions erişimini almak istiyor.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap, Ana klasörünüzdeki $filename dosyasına $permissions erişimini almak istiyor.';
  }

  @override
  String get homePromptMetaDataTitle => 'Bu uygulama hakkında';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return '$publisher tarafından yayınlandı';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'This publisher has a ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'verified account';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Son güncelleme tarihi $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Daha fazla seçenek...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Daha fazla seçenek';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Uygulama Merkezi sayfasını ziyaret edin';

  @override
  String get homePromptMetaDataAppCenterButton => 'Uygulama Merkezi\'nde aç';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Ayrıca $permission erişimini de verin';
  }

  @override
  String get homePromptPermissionsTitle => 'İzinler';

  @override
  String get homePromptPermissionsRead => 'Okuma';

  @override
  String get homePromptPermissionsReadOnly => 'Salt okunur';

  @override
  String get homePromptPermissionsWrite => 'Yaz';

  @override
  String get homePromptPermissionsWriteOnly => 'Write only';

  @override
  String get homePromptPermissionsExecute => 'Çalıştır';

  @override
  String get homePromptPermissionsExecuteOnly => 'Execute only';

  @override
  String get homePromptErrorUnknownTitle => 'Bir şeyler ters gitti';

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
