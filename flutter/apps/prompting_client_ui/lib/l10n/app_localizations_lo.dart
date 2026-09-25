// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lao (`lo`).
class AppLocalizationsLo extends AppLocalizations {
  AppLocalizationsLo([String locale = 'lo']) : super(locale);

  @override
  String get securityCenterInfo =>
      'ທ່ານສາມາດປ່ຽນການອະນຸຍາດເຫຼົ່ານີ້ໄດ້ຕະຫຼອດເວລາໃນ <ສູນຄວາມປອດໄພ>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'ກຳນົດການເຂົ້າເຖິງສຳລັບ $snap ໄປທີ່:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'ໃຫ້ $snap ເຂົ້າເຖິງ $permission ຕໍ່:';
  }

  @override
  String get promptActionOptionAllow => 'ອະນຸຍາດ';

  @override
  String get promptActionOptionAllowAlways => 'ອະນຸຍາດຕະຫຼອດ';

  @override
  String get promptActionOptionAllowOnce => 'ອະນຸຍາດເທື່ອດຽວ';

  @override
  String get promptActionOptionDeny => 'ປະຕິເສດ';

  @override
  String get promptActionOptionDenyOnce => 'ປະຕິເສດເທື່ອດຽວ';

  @override
  String get promptActionOptionDenyAlways => 'ປະຕິເສດຕະຫຼອດ';

  @override
  String get promptActionOptionDenyUntilLogout => 'ປະຕິເສດຈົນກວ່າຈະອອກຈາກລະບົບ';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'ອະນຸຍາດຈົນກວ່າຈະອອກຈາກລະບົບ';

  @override
  String get promptActionTitle => 'ການກະທຳ';

  @override
  String get promptLifespanOptionForever => 'ຕະຫຼອດໄປ';

  @override
  String get promptLifespanOptionSession => 'ຈົນກວ່າຈະອອກຈາກລະບົບ';

  @override
  String get promptLifespanOptionSingle => 'ເທື່ອດຽວ';

  @override
  String get promptLifespanTitle => 'ໄລຍະເວລາ';

  @override
  String get promptSaveAndContinue => 'ບັນທຶກ ແລະ ສືບຕໍ່';

  @override
  String get promptTitle => 'ການແຈ້ງເຕືອນຄວາມປອດໄພ';

  @override
  String get homePatternInfo => '<ຮຽນຮູ້ກ່ຽວກັບຮູບແບບເສັ້ນທາງ>';

  @override
  String get homePatternTypeCustomPath => 'ຮູບແບບເສັ້ນທາງແບບກຳນົດເອງ';

  @override
  String get homeCustomPathSaveButton => 'ບັນທຶກເສັ້ນທາງແບບກຳນົດເອງ';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'ຮູບແບບເສັ້ນທາງຕ້ອງເລີ່ມຕົ້ນດ້ວຍ /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'ກົງກັບຂໍ້ຄວາມໃດໜຶ່ງ ຍົກເວັ້ນ /';

  @override
  String get homeCustomPathWildcardQuestionDescription => 'ກົງກັບຕົວອັກສອນດຽວ';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'ກົງກັບໂຟນເດີ ແລະ ໄຟລ໌ທັງໝົດແບບຊ້ອນກັນ';

  @override
  String get homeCustomPathWildcardCurlyDescription => 'ກົງກັບ x ຫຼື y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'ຍົກເວັ້ນຕົວອັກສອນພິເສດເພື່ອໃຫ້ຖືວ່າເປັນຕົວອັກສອນປົກກະຕິ';

  @override
  String get homePatternTypeRequestedDirectory => 'ໂຟນເດີທີ່ຮ້ອງຂໍເທົ່ານັ້ນ';

  @override
  String get homePatternTypeRequestedFile => 'ໄຟລ໌ທີ່ຮ້ອງຂໍເທົ່ານັ້ນ';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'ທຸກຢ່າງໃນໂຟນເດີ $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'ທຸກຢ່າງໃນໂຟນເດີ';

  @override
  String get homePatternTypeContainingDirectory => 'ທຸກຢ່າງໃນໂຟນເດີ';

  @override
  String get homePatternTypeHomeDirectory => 'ທຸກຢ່າງໃນໂຟນເດີ Home';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'ໄຟລ໌ $fileExtension ທັງໝົດ';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap ຕ້ອງການສິດເຂົ້າເຖິງ $permissions ຕໍ່ $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return '$snap ຕ້ອງການສິດເຂົ້າເຖິງ $permissions ຕໍ່ໂຟນເດີ $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return '$snap ຕ້ອງການສິດເຂົ້າເຖິງ $permissions ຕໍ່ $filename ໃນໂຟນເດີ $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap ຕ້ອງການສິດເຂົ້າເຖິງ $permissions ຕໍ່ໂຟນເດີ Home ຂອງທ່ານ.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return '$snap ຕ້ອງການສິດເຂົ້າເຖິງ $permissions ຕໍ່ $filename ໃນໂຟນເດີ Home ຂອງທ່ານ.';
  }

  @override
  String get homePromptMetaDataTitle => 'ກ່ຽວກັບແອັບນີ້';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'ເຜີຍແຜ່ໂດຍ $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'ຜູ້ເຜີຍແຜ່ນີ້ມີ ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'ບັນຊີທີ່ຜ່ານການຢືນຢັນ';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'ອັບເດດລ້າສຸດເມື່ອ $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'ຕົວເລືອກເພີ່ມເຕີມ...';

  @override
  String get homePromptMoreOptionsTileLabel => 'ຕົວເລືອກເພີ່ມເຕີມ';

  @override
  String get homePromptMetaDataAppCenterLink => 'ເຂົ້າຊົມໜ້າ App Center';

  @override
  String get homePromptMetaDataAppCenterButton => 'ເປີດໃນ App Center';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'ໃຫ້ສິດເຂົ້າເຖິງ $permission ນຳ';
  }

  @override
  String get homePromptPermissionsTitle => 'ການອະນຸຍາດ';

  @override
  String get homePromptPermissionsRead => 'ອ່ານ';

  @override
  String get homePromptPermissionsReadOnly => 'ອ່ານເທົ່ານັ້ນ';

  @override
  String get homePromptPermissionsWrite => 'ຂຽນ';

  @override
  String get homePromptPermissionsWriteOnly => 'ຂຽນເທົ່ານັ້ນ';

  @override
  String get homePromptPermissionsExecute => 'ດຳເນີນການ';

  @override
  String get homePromptPermissionsExecuteOnly => 'ດຳເນີນການເທົ່ານັ້ນ';

  @override
  String get homePromptErrorUnknownTitle => 'ມີບາງຢ່າງຜິດພາດ';

  @override
  String cameraPromptBody(String snapName) {
    return 'ອະນຸຍາດໃຫ້ $snapName ນຳໃຊ້ກ້ອງຂອງທ່ານບໍ?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'ອະນຸຍາດໃຫ້ $snapName ນຳໃຊ້ໄມໂຄຣໂຟນຂອງທ່ານບໍ?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'ໃຫ້ $snapName ເຂົ້າເຖິງ $permissions ຕໍ່ໄຟລ໌ບໍ່?';
  }
}
