// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Anda selalu dapat mengubah izin ini di <Security Center>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Atur akses untuk $snap ke:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Beri $snap akses $permission ke:';
  }

  @override
  String get promptActionOptionAllow => 'Izinkan';

  @override
  String get promptActionOptionAllowAlways => 'Selalu izinkan';

  @override
  String get promptActionOptionAllowOnce => 'Izinkan sekali';

  @override
  String get promptActionOptionDeny => 'Tolak';

  @override
  String get promptActionOptionDenyOnce => 'Tolak sekali';

  @override
  String get promptActionOptionDenyAlways => 'Selalu tolak';

  @override
  String get promptActionOptionDenyUntilLogout => 'Tolak hingga keluar';

  @override
  String get promptActionOptionAllowUntilLogout => 'Izinkan hingga keluar';

  @override
  String get promptActionTitle => 'Tindakan';

  @override
  String get promptLifespanOptionForever => 'Selalu';

  @override
  String get promptLifespanOptionSession => 'Hingga keluar';

  @override
  String get promptLifespanOptionSingle => 'Sekali';

  @override
  String get promptLifespanTitle => 'Durasi';

  @override
  String get promptSaveAndContinue => 'Simpan dan lanjutkan';

  @override
  String get promptTitle => 'Notifikasi keamanan';

  @override
  String get homePatternInfo => '<Pelajari tentang pola path>';

  @override
  String get homePatternTypeCustomPath => 'Pola jalur kustom';

  @override
  String get homeCustomPathSaveButton => 'Simpan jalur kustom';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Pola jalur harus dimulai dengan /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Cocok dengan sembarang string karakter kecuali /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Cocok dengan satu karakter';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Cocok dengan nol atau lebih folder dan file secara rekursif';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'Cocok dengan x atau y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Meng-escape karakter khusus agar diperlakukan sebagai literal';

  @override
  String get homePatternTypeRequestedDirectory => 'Hanya folder yang diminta';

  @override
  String get homePatternTypeRequestedFile => 'Hanya file yang diminta';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Semua yang ada di folder $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Semua yang ada di folder';

  @override
  String get homePatternTypeContainingDirectory => 'Semua yang ada di folder';

  @override
  String get homePatternTypeHomeDirectory => 'Semua yang ada di folder Home';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Semua file $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap ingin mendapatkan akses $permissions ke $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap ingin mendapatkan akses $permissions ke folder $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap ingin mendapatkan akses $permissions ke $filename di folder $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap ingin mendapatkan akses $permissions ke folder Home Anda.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap ingin mendapatkan akses $permissions ke $filename di folder Home Anda.';
  }

  @override
  String get homePromptMetaDataTitle => 'Tentang aplikasi ini';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Diterbitkan oleh $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix =>
      'Penerbit ini memiliki ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'akun terverifikasi';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Terakhir diperbarui pada $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Opsi lainnya...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Opsi lainnya';

  @override
  String get homePromptMetaDataAppCenterLink => 'Kunjungi halaman App Center';

  @override
  String get homePromptMetaDataAppCenterButton => 'Buka di App Center';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Juga beri akses $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Izin';

  @override
  String get homePromptPermissionsRead => 'Baca';

  @override
  String get homePromptPermissionsReadOnly => 'Hanya baca';

  @override
  String get homePromptPermissionsWrite => 'Tulis';

  @override
  String get homePromptPermissionsWriteOnly => 'Hanya tulis';

  @override
  String get homePromptPermissionsExecute => 'Jalankan';

  @override
  String get homePromptPermissionsExecuteOnly => 'Hanya jalankan';

  @override
  String get homePromptErrorUnknownTitle => 'Terjadi kesalahan';

  @override
  String cameraPromptBody(String snapName) {
    return 'Izinkan $snapName menggunakan kamera Anda?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Izinkan $snapName menggunakan mikrofon Anda?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Beri $snapName akses $permissions ke file?';
  }
}
