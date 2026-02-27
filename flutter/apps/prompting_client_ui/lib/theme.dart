import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

const kWindowWidth = 372.0;
const kDefaultWindowHeight = 230.0;
const kHomePromptWindowHeight = 690.0;
const defaultWindowSize = Size(kWindowWidth, kDefaultWindowHeight);
const homePromptWindowSize = Size(kWindowWidth, kHomePromptWindowHeight);

extension ThemeDataX on ThemeData {
  ThemeData customize() {
    return copyWith(
      extensions: [
        YaruToggleButtonThemeData(titleStyle: textTheme.bodyMedium),
      ],
    );
  }
}
