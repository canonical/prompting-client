import 'package:flutter/material.dart';

/// A MaterialPageRoute that ensures the background color is properly maintained
/// during page transitions.
class ThemedPageRoute<T> extends MaterialPageRoute<T> {
  ThemedPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: super.buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      ),
    );
  }
}
