import 'package:flutter/material.dart';

extension WidgetIterableExtension on Iterable<Widget> {
  List<Widget> withSpacing(double spacing) {
    return expand((item) sync* {
      yield SizedBox(width: spacing, height: spacing);
      yield item;
    }).skip(1).toList();
  }

  List<Widget> separatedBy(Widget separator) {
    return expand((item) sync* {
      yield separator;
      yield item;
    }).skip(1).toList();
  }
}
