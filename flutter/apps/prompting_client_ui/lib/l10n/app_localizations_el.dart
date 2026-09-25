// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Μπορείτε ανά πάσα στιγμή να αλλάξετε αυτά τα δικαιώματα στο <Κέντρο Ασφάλειας>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Ορίστε την πρόσβαση για το $snap σε:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Παραχωρήστε στο $snap πρόσβαση $permission σε:';
  }

  @override
  String get promptActionOptionAllow => 'Να επιτρέπεται';

  @override
  String get promptActionOptionAllowAlways => 'Να επιτρέπεται πάντα';

  @override
  String get promptActionOptionAllowOnce => 'Να επιτραπεί μία φορά';

  @override
  String get promptActionOptionDeny => 'Να μην επιτρέπεται';

  @override
  String get promptActionOptionDenyOnce => 'Να μην επιτραπεί μία φορά';

  @override
  String get promptActionOptionDenyAlways => 'Να μην επιτρέπεται ποτέ';

  @override
  String get promptActionOptionDenyUntilLogout =>
      'Να μην επιτρέπεται μέχρι την αποσύνδεση';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Να επιτρέπεται μέχρι την αποσύνδεση';

  @override
  String get promptActionTitle => 'Ενέργεια';

  @override
  String get promptLifespanOptionForever => 'Πάντα';

  @override
  String get promptLifespanOptionSession => 'Μέχρι την αποσύνδεση';

  @override
  String get promptLifespanOptionSingle => 'Μια φόρα';

  @override
  String get promptLifespanTitle => 'Διάρκεια';

  @override
  String get promptSaveAndContinue => 'Αποθήκευση και συνέχεια';

  @override
  String get promptTitle => 'Ειδοποίηση ασφάλειας';

  @override
  String get homePatternInfo => '<Μάθετε για τα μοτίβα διαδρομών>';

  @override
  String get homePatternTypeCustomPath => 'Προσαρμοσμένο μοτίβο διαδρομής';

  @override
  String get homeCustomPathSaveButton => 'Αποθήκευση προσαρμοσμένης διαδρομής';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Το μοτίβο διαδρομής πρέπει να ξεκινάει με /';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'Ταιριάζει οποιαδήποτε συμβολοσειρά χαρακτήρων εκτός από /';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Ταιριάζει έναν μόνο χαρακτήρα';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Ταιριάζει μηδέν ή περισσότερους φακέλους και αρχεία αναδρομικά';

  @override
  String get homeCustomPathWildcardCurlyDescription =>
      'Ταιριάζει είτε στο x είτε στο y';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Διαφεύγει τους ειδικούς χαρακτήρες για να τους χειριστεί ως κυριολεκτικούς';

  @override
  String get homePatternTypeRequestedDirectory => 'Μόνο ο φάκελος που ζητήθηκε';

  @override
  String get homePatternTypeRequestedFile => 'Μόνο το αρχείο που ζητήθηκε';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Όλα τα περιεχόμενα στον φάκελο $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents =>
      'Όλα τα περιεχόμενα στον φάκελο';

  @override
  String get homePatternTypeContainingDirectory =>
      'Όλα τα περιεχόμενα στον φάκελο';

  @override
  String get homePatternTypeHomeDirectory =>
      'Όλα τα περιεχόμενα στον Προσωπικό σας φάκελο';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Όλα τα αρχεία $fileExtension';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return 'Το πακέτο $snap θέλει να αποκτήσει πρόσβαση $permissions στο $path';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return 'Το πακέτο $snap θέλει να αποκτήσει πρόσβαση $permissions στον φάκελο $foldername.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return 'Το πακέτο $snap θέλει να αποκτήσει πρόσβαση $permissions στο αρχείο $filename στον φάκελο $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return 'Το πακέτο $snap θέλει να αποκτήσει πρόσβαση $permissions στον Προσωπικό σας φάκελο (Home).';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return 'Το πακέτο $snap θέλει να αποκτήσει πρόσβαση $permissions στο αρχείο $filename στον Προσωπικό σας φάκελο.';
  }

  @override
  String get homePromptMetaDataTitle => 'Σχετικά με αυτήν την εφαρμογή';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Εκδόθηκε από $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix => 'Αυτός ο εκδότης έχει ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'επαληθευμένο λογαριασμό';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Τελευταία ενημέρωση στις $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Περισσότερες επιλογές...';

  @override
  String get homePromptMoreOptionsTileLabel => 'Περισσότερες επιλογές';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Επισκεφτείτε τη σελίδα του Κέντρου Εφαρμογών';

  @override
  String get homePromptMetaDataAppCenterButton =>
      'Άνοιγμα στο Κέντρο Εφαρμογών';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Επίσης παροχή πρόσβασης $permission';
  }

  @override
  String get homePromptPermissionsTitle => 'Δικαιώματα';

  @override
  String get homePromptPermissionsRead => 'Ανάγνωση';

  @override
  String get homePromptPermissionsReadOnly => 'Μόνο ανάγνωση';

  @override
  String get homePromptPermissionsWrite => 'Εγγραφή';

  @override
  String get homePromptPermissionsWriteOnly => 'Μόνο εγγραφή';

  @override
  String get homePromptPermissionsExecute => 'Εκτέλεση';

  @override
  String get homePromptPermissionsExecuteOnly => 'Μόνο εκτέλεση';

  @override
  String get homePromptErrorUnknownTitle => 'Κάτι πήγε στραβά';

  @override
  String cameraPromptBody(String snapName) {
    return 'Να επιτρέπεται στο $snapName να χρησιμοποιεί τις κάμερές σας;';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Να επιτρέπεται στο $snapName να χρησιμοποιεί τα μικρόφωνά σας;';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Να δοθεί στο $snapName πρόσβαση $permissions σε αρχεία;';
  }
}
