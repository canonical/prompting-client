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
    return 'Mengatur akses untuk $snap ke:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Berikan akses $permission $snap ke:';
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
  String get promptActionOptionAllowUntilLogout => 'Allow until logout';

  @override
  String get promptActionTitle => 'Aksi';

  @override
  String get promptLifespanOptionForever => 'Selalu';

  @override
  String get promptLifespanOptionSession => 'Sampai log keluar';

  @override
  String get promptLifespanOptionSingle => 'Sekali';

  @override
  String get promptLifespanTitle => 'Durasi';

  @override
  String get promptSaveAndContinue => 'Simpan dan lanjutkan';

  @override
  String get promptTitle => 'Pemberitahuan keamanan';

  @override
  String get homePatternInfo => '<Pelajari tentang pola path>';

  @override
  String get homePatternTypeCustomPath => 'Pola path ubahan';

  @override
  String get homePatternTypeRequestedDirectory => 'Hanya folder yang diminta';

  @override
  String get homePatternTypeRequestedFile => 'Hanya berkas yang diminta';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Semua dalam folder $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Semua dalam folder';

  @override
  String get homePatternTypeContainingDirectory => 'Semua dalam folder';

  @override
  String get homePatternTypeHomeDirectory => 'Semua dalam folder Rumah';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Semua berkas $fileExtension';
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
    return '$snap ingin mendapatkan akses $permissions ke $filename dalam folder $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap ingin mendapatkan akses $permissions ke folder Rumah Anda.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap ingin mendapatkan akses $permissions ke $filename di folder Rumah Anda.';
  }

  @override
  String get homePromptMetaDataTitle => 'Tentang aplikasi ini';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Dipublikasikan oleh $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Terakhir diperbarui pada $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Opsi tambahan...';

  @override
  String get homePromptMetaDataAppCenterLink => 'Kunjungi halaman Pusat App';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Berikan juga akses $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Izin';

  @override
  String get homePromptPermissionsRead => 'Baca';

  @override
  String get homePromptPermissionsWrite => 'Tulis';

  @override
  String get homePromptPermissionsExecute => 'Jalankan';

  @override
  String get homePromptErrorUnknownTitle => 'Ada yang tidak beres';
}
