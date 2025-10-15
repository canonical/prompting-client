import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

const defaultWindowSize = Size(560, 200);

extension ThemeDataX on ThemeData {
  ThemeData customize() {
    return copyWith(
      extensions: [
        YaruToggleButtonThemeData(titleStyle: textTheme.bodyMedium),
      ],
    );
  }
}
