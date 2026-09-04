import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/theme.dart';
import 'package:prompting_client_ui/widgets/device_action_buttons.dart';
import 'package:yaru/yaru.dart';

/// Pumps the buttons with [width] to lay out in, inside a surface that is
/// exactly the prompt page around them.
///
/// Menu placement depends on where the buttons sit within the overlay, not just
/// on how wide they are, so the surface has to be the window rather than the
/// test default.
Future<void> _pumpButtons(WidgetTester tester, double width) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width + 2 * kPagePadding, 600);
  addTearDown(tester.view.reset);

  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: yaruLight.customize(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(kPagePadding),
            child: DeviceActionButtons(
              onAction: ({required action, required lifespan}) async =>
                  PromptReplyResponse.success(),
            ),
          ),
        ),
      ),
    ),
  );
}

Finder _dropdownOf(Finder splitButton) => find.descendant(
      of: splitButton,
      matching: find.widgetWithIcon(FilledButton, YaruIcons.pan_down),
    );

void main() {
  for (final layout in [
    (name: 'stacked', width: kWindowWidth - 2 * kPagePadding),
    (name: 'side by side', width: 800.0),
  ]) {
    for (final button in [
      (name: 'allow', index: 0),
      (name: 'deny', index: 1),
    ]) {
      testWidgets(
          'the ${button.name} menu opens under its own arrow when the buttons '
          'are ${layout.name}', (tester) async {
        await _pumpButtons(tester, layout.width);

        final dropdown =
            _dropdownOf(find.byType(YaruSplitButton).at(button.index));
        final arrow = tester.getRect(dropdown);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        final menu =
            tester.getRect(find.bySubtype<PopupMenuItem<dynamic>>().first);
        expect(menu.left, lessThanOrEqualTo(arrow.center.dx));
        expect(menu.right, greaterThanOrEqualTo(arrow.center.dx));
      });
    }
  }

  testWidgets('action buttons stack and fill the prompt width', (tester) async {
    const availableWidth = kWindowWidth - 2 * kPagePadding;
    await _pumpButtons(tester, availableWidth);

    final splitButtons = find.byType(YaruSplitButton);
    expect(splitButtons, findsNWidgets(2));

    for (var i = 0; i < 2; i++) {
      final splitButton = splitButtons.at(i);
      // The dropdown is the last thing in the split button's row, so its right
      // edge only reaches the full width if the main button expanded to fill
      // the space it was given.
      expect(
        tester.getBottomRight(_dropdownOf(splitButton)).dx -
            tester.getTopLeft(splitButton).dx,
        availableWidth,
      );
    }

    // Stacked, not side by side: the labels do not fit at half the width.
    expect(
      tester.getTopLeft(splitButtons.at(1)).dy,
      greaterThan(tester.getBottomLeft(splitButtons.at(0)).dy),
    );
  });

  testWidgets('action buttons share one row when both labels fit',
      (tester) async {
    // Wide enough that each button's half is bigger than its natural width even
    // with the test font, which is wider than the one the app ships with.
    const availableWidth = 800.0;
    const spacing = 16.0;
    await _pumpButtons(tester, availableWidth);

    final splitButtons = find.byType(YaruSplitButton);
    final allow = tester.getRect(splitButtons.at(0));
    final deny = tester.getRect(splitButtons.at(1));

    expect(allow.top, deny.top);
    expect(allow.width, deny.width);
    expect(allow.width, (availableWidth - spacing) / 2);
    expect(deny.left, allow.right + spacing);
    // Still expanded, so each dropdown sits at the right edge of its share.
    expect(
      tester.getBottomRight(_dropdownOf(splitButtons.at(0))).dx,
      allow.right,
    );
  });
}
