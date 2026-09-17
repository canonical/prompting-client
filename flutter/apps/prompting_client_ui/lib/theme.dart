import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:yaru/yaru.dart';

const kWindowWidth = 372.0;
const kDefaultWindowHeight = 230.0;
const kHomePromptWindowHeight = 690.0;
const defaultWindowSize = Size(kWindowWidth, kDefaultWindowHeight);
const homePromptWindowSize = Size(kWindowWidth, kHomePromptWindowHeight);

const double kTileMinHeight = 56.0;
const double kTileHorizontalPadding = 16.0;
const double kTileInternalSpacing = 16.0;
const double kTileTitleLetterSpacing = 0.0;
const double kContentSpacing = 20.0;
const double kPagePadding = 24.0;
const double kHeaderPadding = 12.0;
const double kSnapIconDimension = 80.0;
const double kBackButtonSpacerWidth = 48.0;
const double kTrailingIconSize = 24.0;
const double kSmallIconSize = 16.0;
const double kSmallSpacing = 4.0;

// Resolves the preferred locale whose fonts should be prioritized in the
// fallback list, since Flutter has known issues with font detection on
// ARM64 (e.g. CJK glyphs failing to resolve).
Locale resolveFontLocale(List<Locale>? preferredLocales) {
  final resolvedLocale = basicLocaleListResolution(
    preferredLocales,
    supportedLocales,
  );
  return preferredLocales
          ?.where(
            (locale) => locale.languageCode == resolvedLocale.languageCode,
          )
          .firstOrNull ??
      resolvedLocale;
}

// Orders the Noto Sans CJK fallback fonts so that the variant matching the
// active locale comes first.
List<String> _cjkFallbackFor(Locale locale) {
  const simplifiedChinese = 'Noto Sans CJK SC';
  const traditionalChinese = 'Noto Sans CJK TC';
  const hongKongChinese = 'Noto Sans CJK HK';
  const japanese = 'Noto Sans CJK JP';
  const korean = 'Noto Sans CJK KR';

  return switch ((locale.languageCode, locale.scriptCode, locale.countryCode)) {
    ('ja', _, _) => const [
        japanese,
        simplifiedChinese,
        traditionalChinese,
        hongKongChinese,
        korean,
      ],
    ('ko', _, _) => const [
        korean,
        simplifiedChinese,
        traditionalChinese,
        hongKongChinese,
        japanese,
      ],
    ('zh', _, 'HK') => const [
        hongKongChinese,
        traditionalChinese,
        simplifiedChinese,
        japanese,
        korean,
      ],
    ('zh', 'Hant', _) || ('zh', _, 'TW') => const [
        traditionalChinese,
        hongKongChinese,
        simplifiedChinese,
        japanese,
        korean,
      ],
    _ => const [
        simplifiedChinese,
        traditionalChinese,
        hongKongChinese,
        japanese,
        korean,
      ],
  };
}

extension ThemeDataX on ThemeData {
  ThemeData customize({required Locale locale}) {
    final cjkFallback = _cjkFallbackFor(locale);

    // Rebuilds the style with the CJK fallback list. The styles in yaru's
    // text theme carry `package: 'yaru'`, which makes the fontFamilyFallback
    // getter prefix each family with 'packages/yaru/' and thus prevents the
    // system Noto CJK fonts from being found. `TextStyle.apply` preserves
    // the package, so the style is reconstructed without it instead, keeping
    // the (getter-resolved, explicit) font family.
    TextStyle? withFallback(TextStyle? style) => style == null
        ? null
        : TextStyle(
            inherit: style.inherit,
            color: style.color,
            backgroundColor: style.backgroundColor,
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            fontStyle: style.fontStyle,
            letterSpacing: style.letterSpacing,
            wordSpacing: style.wordSpacing,
            textBaseline: style.textBaseline,
            height: style.height,
            leadingDistribution: style.leadingDistribution,
            locale: style.locale,
            foreground: style.foreground,
            background: style.background,
            shadows: style.shadows,
            fontFeatures: style.fontFeatures,
            fontVariations: style.fontVariations,
            decoration: style.decoration,
            decorationColor: style.decorationColor,
            decorationStyle: style.decorationStyle,
            decorationThickness: style.decorationThickness,
            overflow: style.overflow,
            fontFamily: style.fontFamily,
            fontFamilyFallback: cjkFallback,
          );

    TextTheme withTextThemeFallback(TextTheme theme) => TextTheme(
          displayLarge: withFallback(theme.displayLarge),
          displayMedium: withFallback(theme.displayMedium),
          displaySmall: withFallback(theme.displaySmall),
          headlineLarge: withFallback(theme.headlineLarge),
          headlineMedium: withFallback(theme.headlineMedium),
          headlineSmall: withFallback(theme.headlineSmall),
          titleLarge: withFallback(theme.titleLarge),
          titleMedium: withFallback(theme.titleMedium),
          titleSmall: withFallback(theme.titleSmall),
          bodyLarge: withFallback(theme.bodyLarge),
          bodyMedium: withFallback(theme.bodyMedium),
          bodySmall: withFallback(theme.bodySmall),
          labelLarge: withFallback(theme.labelLarge),
          labelMedium: withFallback(theme.labelMedium),
          labelSmall: withFallback(theme.labelSmall),
        );

    InputDecorationThemeData withInputFallback(
      InputDecorationThemeData theme,
    ) =>
        theme.copyWith(
          labelStyle: withFallback(theme.labelStyle),
          floatingLabelStyle: withFallback(theme.floatingLabelStyle),
          helperStyle: withFallback(theme.helperStyle),
          hintStyle: withFallback(theme.hintStyle),
          errorStyle: withFallback(theme.errorStyle),
          prefixStyle: withFallback(theme.prefixStyle),
          suffixStyle: withFallback(theme.suffixStyle),
          counterStyle: withFallback(theme.counterStyle),
        );

    WidgetStateProperty<TextStyle?>? withStateFallback(
      WidgetStateProperty<TextStyle?>? style,
    ) =>
        style == null
            ? null
            : WidgetStateProperty.resolveWith(
                (states) => withFallback(style.resolve(states)),
              );

    return copyWith(
      textTheme: withTextThemeFallback(textTheme),
      primaryTextTheme: withTextThemeFallback(primaryTextTheme),
      appBarTheme: appBarTheme.copyWith(
        toolbarTextStyle: withFallback(appBarTheme.toolbarTextStyle),
        titleTextStyle: withFallback(appBarTheme.titleTextStyle),
      ),
      navigationRailTheme: navigationRailTheme.copyWith(
        selectedLabelTextStyle: withFallback(
          navigationRailTheme.selectedLabelTextStyle,
        ),
        unselectedLabelTextStyle: withFallback(
          navigationRailTheme.unselectedLabelTextStyle,
        ),
      ),
      listTileTheme: listTileTheme.copyWith(
        titleTextStyle: withFallback(listTileTheme.titleTextStyle),
        subtitleTextStyle: withFallback(listTileTheme.subtitleTextStyle),
        leadingAndTrailingTextStyle: withFallback(
          listTileTheme.leadingAndTrailingTextStyle,
        ),
      ),
      chipTheme: chipTheme.copyWith(
        labelStyle: withFallback(chipTheme.labelStyle),
        secondaryLabelStyle: withFallback(chipTheme.secondaryLabelStyle),
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: menuButtonTheme.style?.copyWith(
          textStyle: withStateFallback(menuButtonTheme.style?.textStyle),
        ),
      ),
      snackBarTheme: snackBarTheme.copyWith(
        contentTextStyle: withFallback(snackBarTheme.contentTextStyle),
      ),
      dropdownMenuTheme: dropdownMenuTheme.copyWith(
        textStyle: withFallback(dropdownMenuTheme.textStyle),
        inputDecorationTheme: dropdownMenuTheme.inputDecorationTheme == null
            ? null
            : withInputFallback(dropdownMenuTheme.inputDecorationTheme!),
      ),
      inputDecorationTheme: withInputFallback(inputDecorationTheme),
      extensions: [
        YaruToggleButtonThemeData(
          titleStyle: withFallback(textTheme.bodyMedium),
        ),
      ],
    );
  }
}
