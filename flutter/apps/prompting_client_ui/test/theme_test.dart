import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompting_client_ui/theme.dart';
import 'package:yaru/yaru.dart';

void main() {
  group('font fallbacks', () {
    test('prefers the active CJK locale', () {
      for (final testCase in [
        (locale: const Locale('ja'), expected: 'Noto Sans CJK JP'),
        (locale: const Locale('ko'), expected: 'Noto Sans CJK KR'),
        (locale: const Locale('zh'), expected: 'Noto Sans CJK SC'),
        (locale: const Locale('zh', 'TW'), expected: 'Noto Sans CJK TC'),
        (locale: const Locale('zh', 'HK'), expected: 'Noto Sans CJK HK'),
        (
          locale: const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
          ),
          expected: 'Noto Sans CJK TC',
        ),
      ]) {
        final theme = yaruLight.customize(locale: testCase.locale);

        expect(
          theme.textTheme.bodyMedium!.fontFamilyFallback!.first,
          testCase.expected,
        );
      }
    });

    test('applies to Yaru component text styles', () {
      final theme = yaruLight.customize(locale: const Locale('ja'));
      final fallback = theme.textTheme.bodyMedium!.fontFamilyFallback;
      final inputTheme = theme.inputDecorationTheme;
      final dropdownInputTheme = theme.dropdownMenuTheme.inputDecorationTheme!;

      expect(
        _textStylesOf(theme.textTheme).map((style) => style.fontFamilyFallback),
        everyElement(fallback),
      );
      expect(
        _textStylesOf(
          theme.primaryTextTheme,
        ).map((style) => style.fontFamilyFallback),
        everyElement(fallback),
      );
      expect(theme.appBarTheme.titleTextStyle!.fontFamilyFallback, fallback);
      // yaru defines no list tile text styles, so there is nothing to apply
      // the fallback to; assert they are correct if it ever does.
      final listTileTextStyles = [
        theme.listTileTheme.titleTextStyle,
        theme.listTileTheme.subtitleTextStyle,
        theme.listTileTheme.leadingAndTrailingTextStyle,
      ].nonNulls;
      if (listTileTextStyles.isNotEmpty) {
        expect(
          listTileTextStyles.map((style) => style.fontFamilyFallback),
          everyElement(fallback),
        );
      }
      expect(theme.chipTheme.labelStyle!.fontFamilyFallback, fallback);
      expect(
        theme.chipTheme.secondaryLabelStyle!.fontFamilyFallback,
        fallback,
      );
      // yaru does not define a menu button text style, so there is nothing
      // to apply the fallback to; assert it is correct if it ever does.
      final menuTextStyle = theme.menuButtonTheme.style?.textStyle?.resolve({});
      if (menuTextStyle != null) {
        expect(menuTextStyle.fontFamilyFallback, fallback);
      }
      expect(
        theme.snackBarTheme.contentTextStyle!.fontFamilyFallback,
        fallback,
      );
      expect(
        _textStylesOf(inputTheme).map((style) => style.fontFamilyFallback),
        everyElement(fallback),
      );
      expect(
        _textStylesOf(
          dropdownInputTheme,
        ).map((style) => style.fontFamilyFallback),
        everyElement(fallback),
      );
    });
  });
}

Iterable<TextStyle> _textStylesOf(Object theme) => switch (theme) {
      TextTheme() => [
          theme.displayLarge!,
          theme.displayMedium!,
          theme.displaySmall!,
          theme.headlineLarge!,
          theme.headlineMedium!,
          theme.headlineSmall!,
          theme.titleLarge!,
          theme.titleMedium!,
          theme.titleSmall!,
          theme.bodyLarge!,
          theme.bodyMedium!,
          theme.bodySmall!,
          theme.labelLarge!,
          theme.labelMedium!,
          theme.labelSmall!,
        ],
      InputDecorationThemeData() => [
          theme.errorStyle!,
          theme.helperStyle!,
          theme.hintStyle!,
          theme.labelStyle!,
          theme.prefixStyle!,
          theme.suffixStyle!,
        ],
      _ => throw ArgumentError.value(theme),
    };
