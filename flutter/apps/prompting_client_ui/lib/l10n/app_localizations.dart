import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_bo.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_dz.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_eo.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_gl.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_is.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_km.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ku.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mk.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_my.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_nn.dart';
import 'app_localizations_oc.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_se.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ug.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('ar'),
    Locale('be'),
    Locale('bg'),
    Locale('bn'),
    Locale('bo'),
    Locale('bs'),
    Locale('ca'),
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('dz'),
    Locale('el'),
    Locale('en'),
    Locale('eo'),
    Locale('es'),
    Locale('et'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('ga'),
    Locale('gl'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('is'),
    Locale('it'),
    Locale('ja'),
    Locale('ka'),
    Locale('kk'),
    Locale('km'),
    Locale('kn'),
    Locale('ko'),
    Locale('ku'),
    Locale('lo'),
    Locale('lt'),
    Locale('lv'),
    Locale('mk'),
    Locale('ml'),
    Locale('mr'),
    Locale('my'),
    Locale('nb'),
    Locale('ne'),
    Locale('nl'),
    Locale('nn'),
    Locale('oc'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ro'),
    Locale('ru'),
    Locale('se'),
    Locale('si'),
    Locale('sk'),
    Locale('sl'),
    Locale('sq'),
    Locale('sr'),
    Locale('sv'),
    Locale('ta'),
    Locale('te'),
    Locale('tg'),
    Locale('th'),
    Locale('tl'),
    Locale('tr'),
    Locale('ug'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @securityCenterInfo.
  ///
  /// In en, this message translates to:
  /// **'You can always change these permissions in the <Security Center>'**
  String get securityCenterInfo;

  /// No description provided for @promptAccessMoreOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Set access for {snap} to:'**
  String promptAccessMoreOptionsTitle(String snap);

  /// No description provided for @promptAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Give {snap} {permission} access to:'**
  String promptAccessTitle(String snap, String permission);

  /// No description provided for @promptActionOptionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get promptActionOptionAllow;

  /// No description provided for @promptActionOptionAllowAlways.
  ///
  /// In en, this message translates to:
  /// **'Allow always'**
  String get promptActionOptionAllowAlways;

  /// No description provided for @promptActionOptionAllowOnce.
  ///
  /// In en, this message translates to:
  /// **'Allow once'**
  String get promptActionOptionAllowOnce;

  /// No description provided for @promptActionOptionDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get promptActionOptionDeny;

  /// No description provided for @promptActionOptionDenyOnce.
  ///
  /// In en, this message translates to:
  /// **'Deny once'**
  String get promptActionOptionDenyOnce;

  /// No description provided for @promptActionOptionAllowUntilLogout.
  ///
  /// In en, this message translates to:
  /// **'Allow until logout'**
  String get promptActionOptionAllowUntilLogout;

  /// No description provided for @promptActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get promptActionTitle;

  /// No description provided for @promptLifespanOptionForever.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get promptLifespanOptionForever;

  /// No description provided for @promptLifespanOptionSession.
  ///
  /// In en, this message translates to:
  /// **'Until logout'**
  String get promptLifespanOptionSession;

  /// No description provided for @promptLifespanOptionSingle.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get promptLifespanOptionSingle;

  /// No description provided for @promptLifespanTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get promptLifespanTitle;

  /// No description provided for @promptSaveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get promptSaveAndContinue;

  /// No description provided for @promptTitle.
  ///
  /// In en, this message translates to:
  /// **'Security notification'**
  String get promptTitle;

  /// No description provided for @homePatternInfo.
  ///
  /// In en, this message translates to:
  /// **'<Learn about path patterns>'**
  String get homePatternInfo;

  /// No description provided for @homePatternTypeCustomPath.
  ///
  /// In en, this message translates to:
  /// **'Custom path pattern'**
  String get homePatternTypeCustomPath;

  /// No description provided for @homePatternTypeRequestedDirectory.
  ///
  /// In en, this message translates to:
  /// **'The requested folder only'**
  String get homePatternTypeRequestedDirectory;

  /// No description provided for @homePatternTypeRequestedFile.
  ///
  /// In en, this message translates to:
  /// **'The requested file only'**
  String get homePatternTypeRequestedFile;

  /// No description provided for @homePatternTypeTopLevelDirectory.
  ///
  /// In en, this message translates to:
  /// **'Everything in the {topLevelDir} folder'**
  String homePatternTypeTopLevelDirectory(String topLevelDir);

  /// No description provided for @homePatternTypeRequestedDirectoryContents.
  ///
  /// In en, this message translates to:
  /// **'Everything in the folder'**
  String get homePatternTypeRequestedDirectoryContents;

  /// No description provided for @homePatternTypeContainingDirectory.
  ///
  /// In en, this message translates to:
  /// **'Everything in the folder'**
  String get homePatternTypeContainingDirectory;

  /// No description provided for @homePatternTypeHomeDirectory.
  ///
  /// In en, this message translates to:
  /// **'Everything in the Home folder'**
  String get homePatternTypeHomeDirectory;

  /// No description provided for @homePatternTypeMatchingFileExtension.
  ///
  /// In en, this message translates to:
  /// **'All {fileExtension} files'**
  String homePatternTypeMatchingFileExtension(String fileExtension);

  /// No description provided for @homePromptDefaultBody.
  ///
  /// In en, this message translates to:
  /// **'{snap} wants to get {permissions} access to {path}'**
  String homePromptDefaultBody(String snap, String permissions, String path);

  /// No description provided for @homePromptTopLevelDirBody.
  ///
  /// In en, this message translates to:
  /// **'{snap} wants to get {permissions} access to the {foldername} folder.'**
  String homePromptTopLevelDirBody(
      String snap, String permissions, String foldername);

  /// No description provided for @homePromptTopLevelDirFileBody.
  ///
  /// In en, this message translates to:
  /// **'{snap} wants to get {permissions} access to {filename} in the {foldername} folder.'**
  String homePromptTopLevelDirFileBody(
      String snap, String permissions, String filename, String foldername);

  /// No description provided for @homePromptHomeDirBody.
  ///
  /// In en, this message translates to:
  /// **'{snap} wants to get {permissions} access to your Home folder.'**
  String homePromptHomeDirBody(String snap, String permissions);

  /// No description provided for @homePromptHomeDirFileBody.
  ///
  /// In en, this message translates to:
  /// **'{snap} wants to get {permissions} access to {filename} in your Home folder.'**
  String homePromptHomeDirFileBody(
      String snap, String permissions, String filename);

  /// No description provided for @homePromptMetaDataTitle.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get homePromptMetaDataTitle;

  /// No description provided for @homePromptMetaDataPublishedBy.
  ///
  /// In en, this message translates to:
  /// **'Published by {publisher}'**
  String homePromptMetaDataPublishedBy(String publisher);

  /// No description provided for @homePromptMetaDataLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated on {date}'**
  String homePromptMetaDataLastUpdated(String date);

  /// No description provided for @homePromptMoreOptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'More options...'**
  String get homePromptMoreOptionsLabel;

  /// No description provided for @homePromptMetaDataAppCenterLink.
  ///
  /// In en, this message translates to:
  /// **'Visit App Center page'**
  String get homePromptMetaDataAppCenterLink;

  /// No description provided for @homePromptSuggestedPermission.
  ///
  /// In en, this message translates to:
  /// **'Also give {permission} access'**
  String homePromptSuggestedPermission(String permission);

  /// No description provided for @homePromptPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get homePromptPermissionsTitle;

  /// No description provided for @homePromptPermissionsRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get homePromptPermissionsRead;

  /// No description provided for @homePromptPermissionsWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get homePromptPermissionsWrite;

  /// No description provided for @homePromptPermissionsExecute.
  ///
  /// In en, this message translates to:
  /// **'Execute'**
  String get homePromptPermissionsExecute;

  /// No description provided for @homePromptErrorUnknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get homePromptErrorUnknownTitle;

  /// No description provided for @cameraPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Allow {snapName} to access your camera?'**
  String cameraPromptBody(String snapName);

  /// No description provided for @microphonePromptBody.
  ///
  /// In en, this message translates to:
  /// **'Allow {snapName} to access your microphone?'**
  String microphonePromptBody(String snapName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'am',
        'ar',
        'be',
        'bg',
        'bn',
        'bo',
        'bs',
        'ca',
        'cs',
        'cy',
        'da',
        'de',
        'dz',
        'el',
        'en',
        'eo',
        'es',
        'et',
        'eu',
        'fa',
        'fi',
        'fr',
        'ga',
        'gl',
        'gu',
        'he',
        'hi',
        'hr',
        'hu',
        'id',
        'is',
        'it',
        'ja',
        'ka',
        'kk',
        'km',
        'kn',
        'ko',
        'ku',
        'lo',
        'lt',
        'lv',
        'mk',
        'ml',
        'mr',
        'my',
        'nb',
        'ne',
        'nl',
        'nn',
        'oc',
        'pa',
        'pl',
        'pt',
        'ro',
        'ru',
        'se',
        'si',
        'sk',
        'sl',
        'sq',
        'sr',
        'sv',
        'ta',
        'te',
        'tg',
        'th',
        'tl',
        'tr',
        'ug',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'ar':
      return AppLocalizationsAr();
    case 'be':
      return AppLocalizationsBe();
    case 'bg':
      return AppLocalizationsBg();
    case 'bn':
      return AppLocalizationsBn();
    case 'bo':
      return AppLocalizationsBo();
    case 'bs':
      return AppLocalizationsBs();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'cy':
      return AppLocalizationsCy();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'dz':
      return AppLocalizationsDz();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'eo':
      return AppLocalizationsEo();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'eu':
      return AppLocalizationsEu();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'ga':
      return AppLocalizationsGa();
    case 'gl':
      return AppLocalizationsGl();
    case 'gu':
      return AppLocalizationsGu();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'is':
      return AppLocalizationsIs();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ka':
      return AppLocalizationsKa();
    case 'kk':
      return AppLocalizationsKk();
    case 'km':
      return AppLocalizationsKm();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ku':
      return AppLocalizationsKu();
    case 'lo':
      return AppLocalizationsLo();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'mk':
      return AppLocalizationsMk();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'my':
      return AppLocalizationsMy();
    case 'nb':
      return AppLocalizationsNb();
    case 'ne':
      return AppLocalizationsNe();
    case 'nl':
      return AppLocalizationsNl();
    case 'nn':
      return AppLocalizationsNn();
    case 'oc':
      return AppLocalizationsOc();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'se':
      return AppLocalizationsSe();
    case 'si':
      return AppLocalizationsSi();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sq':
      return AppLocalizationsSq();
    case 'sr':
      return AppLocalizationsSr();
    case 'sv':
      return AppLocalizationsSv();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'tg':
      return AppLocalizationsTg();
    case 'th':
      return AppLocalizationsTh();
    case 'tl':
      return AppLocalizationsTl();
    case 'tr':
      return AppLocalizationsTr();
    case 'ug':
      return AppLocalizationsUg();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
