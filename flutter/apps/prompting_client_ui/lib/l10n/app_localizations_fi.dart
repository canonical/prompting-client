// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get securityCenterInfo => 'Voit muuttaa käyttöoikeuksia <Tietoturvakeskuksessa>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'Set access for $snap to:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return 'Anna sovellukselle $snap käyttöoikeus \"$permission\":';
  }

  @override
  String get promptActionOptionAllow => 'Salli';

  @override
  String get promptActionOptionAllowAlways => 'Salli aina';

  @override
  String get promptActionOptionAllowOnce => 'Salli kerran';

  @override
  String get promptActionOptionDeny => 'Estä';

  @override
  String get promptActionOptionDenyOnce => 'Estä kerran';

  @override
  String get promptActionTitle => 'Toiminto';

  @override
  String get promptLifespanOptionForever => 'Aina';

  @override
  String get promptLifespanOptionSession => 'Uloskirjautumiseen asti';

  @override
  String get promptLifespanOptionSingle => 'Kerran';

  @override
  String get promptLifespanTitle => 'Kesto';

  @override
  String get promptSaveAndContinue => 'Tallenna ja jatka';

  @override
  String get promptTitle => 'Tietoturvailmoitus';

  @override
  String get homePatternInfo => '<Learn about path patterns>';

  @override
  String get homePatternTypeCustomPath => 'Mukautettu polkukaava';

  @override
  String get homePatternTypeRequestedDirectory => 'Vain pyydetty kansio';

  @override
  String get homePatternTypeRequestedFile => 'Vain pyydetty tiedosto';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Kaikki kansiossa $topLevelDir';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Kaikki kansiossa';

  @override
  String get homePatternTypeContainingDirectory => 'Kaikki kansiossa';

  @override
  String get homePatternTypeHomeDirectory => 'Kaikki kotikansiossa';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Kaikki $fileExtension-tiedostot';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return '$snap wants to get $permissions access to $path';
  }

  @override
  String homePromptTopLevelDirBody(String snap, String permissions, String foldername) {
    return '$snap wants to get $permissions access to the $foldername folder.';
  }

  @override
  String homePromptTopLevelDirFileBody(String snap, String permissions, String filename, String foldername) {
    return '$snap haluaa saada $permissions pääsyn kohteeseen $filename kohteessa $foldername.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return '$snap wants to get $permissions access to your Home folder.';
  }

  @override
  String homePromptHomeDirFileBody(String snap, String permissions, String filename) {
    return '$snap haluaa saada $permissions pääsyn kohteeseen $filename kotikansiossasi.';
  }

  @override
  String get homePromptMetaDataTitle => 'Tietoja tästä sovelluksesta';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Julkaisija $publisher';
  }

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Viimeksi päivitetty $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'Lisää valintoja...';

  @override
  String get homePromptMetaDataAppCenterLink => 'Käy sovelluskeskuksen sivulla';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Anna myös käyttöoikeus \"$permission\"';
  }

  @override
  String get homePromptPermissionsTitle => 'Oikeudet';

  @override
  String get homePromptPermissionsRead => 'Lue';

  @override
  String get homePromptPermissionsWrite => 'Kirjoita';

  @override
  String get homePromptPermissionsExecute => 'Suorita';

  @override
  String get homePromptErrorUnknownTitle => 'Something went wrong';
}
