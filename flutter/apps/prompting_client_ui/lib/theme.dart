import 'package:flutter/material.dart';
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
const double kSnapIconDimension = 80.0;
const double kBackButtonSpacerWidth = 48.0;
const double kTrailingIconSize = 24.0;

extension ThemeDataX on ThemeData {
  ThemeData customize() {
    return copyWith(
      extensions: [
        YaruToggleButtonThemeData(titleStyle: textTheme.bodyMedium),
      ],
    );
  }
}
