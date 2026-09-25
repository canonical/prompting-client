// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get securityCenterInfo =>
      'Ezeket a jogosultságokat bármikor megváltoztathatja a <Biztonsági központban>';

  @override
  String promptAccessMoreOptionsTitle(String snap) {
    return 'A(z) $snap snap-csomaghoz való hozzáférés beállítása erre:';
  }

  @override
  String promptAccessTitle(String snap, String permission) {
    return '$permission jogosultság adása a(z) $snap snap-csomagnak erre:';
  }

  @override
  String get promptActionOptionAllow => 'Engedélyezés';

  @override
  String get promptActionOptionAllowAlways => 'Engedélyezés mindig';

  @override
  String get promptActionOptionAllowOnce => 'Engedélyezés egyszer';

  @override
  String get promptActionOptionDeny => 'Tiltás';

  @override
  String get promptActionOptionDenyOnce => 'Tiltás egyszer';

  @override
  String get promptActionOptionDenyAlways => 'Tiltás mindig';

  @override
  String get promptActionOptionDenyUntilLogout => 'Tiltás a kijelentkezésig';

  @override
  String get promptActionOptionAllowUntilLogout =>
      'Engedélyezés a kijelentkezésig';

  @override
  String get promptActionTitle => 'Művelet';

  @override
  String get promptLifespanOptionForever => 'Mindig';

  @override
  String get promptLifespanOptionSession => 'Kijelentkezésig';

  @override
  String get promptLifespanOptionSingle => 'Egyszer';

  @override
  String get promptLifespanTitle => 'Időtartam';

  @override
  String get promptSaveAndContinue => 'Mentés és folytatás';

  @override
  String get promptTitle => 'Biztonsági értesítés';

  @override
  String get homePatternInfo => '<Tudjon meg többet az útvonalmintákról>';

  @override
  String get homePatternTypeCustomPath => 'Egyéni útvonalminta';

  @override
  String get homeCustomPathSaveButton => 'Egyéni útvonal mentése';

  @override
  String get homeCustomPathMustStartWithSlash =>
      'Az útvonalmintának „/” karakterrel kell kezdődnie';

  @override
  String get homeCustomPathWildcardStarDescription =>
      'A / kivételével bármely karakterekből álló karakterláncra illeszkedik';

  @override
  String get homeCustomPathWildcardQuestionDescription =>
      'Önálló karakterre illeszkedik';

  @override
  String get homeCustomPathWildcardDoubleStarDescription =>
      'Nulla vagy több mappára és fájlra illeszkedik rekurzívan';

  @override
  String get homeCustomPathWildcardCurlyDescription =>
      'Vagy x-re, vagy y-ra illeszkedik';

  @override
  String get homeCustomPathWildcardBackslashDescription =>
      'Elfedi a különleges karaktereket, hogy literálokként kezelje azokat';

  @override
  String get homePatternTypeRequestedDirectory => 'Csak a kért mappa';

  @override
  String get homePatternTypeRequestedFile => 'Csak a kért fájl';

  @override
  String homePatternTypeTopLevelDirectory(String topLevelDir) {
    return 'Minden a(z) $topLevelDir mappában';
  }

  @override
  String get homePatternTypeRequestedDirectoryContents => 'Minden a mappában';

  @override
  String get homePatternTypeContainingDirectory => 'Minden a mappában';

  @override
  String get homePatternTypeHomeDirectory => 'Minden a saját mappában';

  @override
  String homePatternTypeMatchingFileExtension(String fileExtension) {
    return 'Az összes $fileExtension fájl';
  }

  @override
  String homePromptDefaultBody(String snap, String permissions, String path) {
    return 'A(z) $snap snap-csomag $permissions hozzáférést szeretne kérni a(z) $path útvonalra';
  }

  @override
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername) {
    return 'A(z) $snap snap-csomag $permissions hozzáférést szeretne kérni a(z) $foldername mappára.';
  }

  @override
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername) {
    return 'A(z) $snap snap-csomag $permissions hozzáférést szeretne kérni a(z) $foldername mappában lévő $filename fájlra.';
  }

  @override
  String homePromptHomeDirBody(String snap, String permissions) {
    return 'A(z) $snap snap-csomag $permissions hozzáférést szeretne kérni az Ön saját mappájára.';
  }

  @override
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename) {
    return 'A(z) $snap snap-csomag $permissions hozzáférést szeretne kérni az Ön saját mappájában lévő $filename fájlra.';
  }

  @override
  String get homePromptMetaDataTitle => 'Az alkalmazás névjegye';

  @override
  String homePromptMetaDataPublishedBy(String publisher) {
    return 'Közzétette: $publisher';
  }

  @override
  String get homePromptMetaDataVerifiedAccountPrefix =>
      'Ez a közzétevő rendelkezik ';

  @override
  String get homePromptMetaDataVerifiedAccountLink => 'ellenőrzött fiókkal';

  @override
  String get homePromptMetaDataVerifiedAccountSuffix => '.';

  @override
  String homePromptMetaDataLastUpdated(String date) {
    return 'Utoljára frissítve: $date';
  }

  @override
  String get homePromptMoreOptionsLabel => 'További beállítások…';

  @override
  String get homePromptMoreOptionsTileLabel => 'További beállítások';

  @override
  String get homePromptMetaDataAppCenterLink =>
      'Az alkalmazásközpont oldalának meglátogatása';

  @override
  String get homePromptMetaDataAppCenterButton =>
      'Megnyitás az alkalmazásközpontban';

  @override
  String homePromptSuggestedPermission(String permission) {
    return 'Kapjon $permission hozzáférést is';
  }

  @override
  String get homePromptPermissionsTitle => 'Jogosultságok';

  @override
  String get homePromptPermissionsRead => 'Olvasás';

  @override
  String get homePromptPermissionsReadOnly => 'Csak olvasás';

  @override
  String get homePromptPermissionsWrite => 'Írás';

  @override
  String get homePromptPermissionsWriteOnly => 'Csak írás';

  @override
  String get homePromptPermissionsExecute => 'Végrehajtás';

  @override
  String get homePromptPermissionsExecuteOnly => 'Csak végrehajtás';

  @override
  String get homePromptErrorUnknownTitle => 'Valami tönkre ment';

  @override
  String cameraPromptBody(String snapName) {
    return 'Engedélyezi a(z) $snapName alkalmazásnak, hogy használja a kameráit?';
  }

  @override
  String microphonePromptBody(String snapName) {
    return 'Engedélyezi a(z) $snapName alkalmazásnak, hogy használja a mikrofonjait?';
  }

  @override
  String homePromptTitleQuestion(String snapName, String permissions) {
    return 'Ad a(z) $snapName alkalmazásnak $permissions hozzáférést a fájlokhoz?';
  }
}
