import 'package:flutter/widgets.dart';
import 'package:prompting_client_ui/l10n/app_localizations.dart';
import 'package:ubuntu_localizations/ubuntu_localizations.dart';

export 'package:prompting_client_ui/l10n/app_localizations.dart';
export 'package:ubuntu_localizations/ubuntu_localizations.dart';

final List<Locale> supportedLocales = {
  const Locale('en'),
  ...List.of(AppLocalizations.supportedLocales)..remove(const Locale('en')),
}.toList();

const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
  ...AppLocalizations.localizationsDelegates,
  ...GlobalUbuntuLocalizations.delegates,
];
