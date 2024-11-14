import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

extension ThemeDataX on ThemeData {
  ThemeData customize() {
    return copyWith(
      extensions: [
        YaruToggleButtonThemeData(titleStyle: textTheme.bodyMedium),
      ],
    );
  }
}
