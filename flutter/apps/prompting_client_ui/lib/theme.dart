import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

/// The prompt is a fixed-width dialog; only its height follows its content.
/// Keep in sync with the default size in linux/my_application.cc.
const kWindowWidth = 382.0;

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

extension ThemeDataX on ThemeData {
  ThemeData customize() {
    return copyWith(
      extensions: [
        YaruToggleButtonThemeData(titleStyle: textTheme.bodyMedium),
      ],
    );
  }
}
