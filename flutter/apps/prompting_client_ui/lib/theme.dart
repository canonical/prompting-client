import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

const defaultWindowSize = Size(400, 230);
const homePromptWindowSize = Size(400, 670);

extension ThemeDataX on ThemeData {
  ThemeData customize() {
    return copyWith(
      extensions: [
        YaruToggleButtonThemeData(titleStyle: textTheme.bodyMedium),
      ],
    );
  }
}
