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
Future<void> _pumpButtons(WidgetTester tester, double width) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width + 2 * kPagePadding, 600);
  addTearDown(tester.view.reset);

  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: yaruLight.customize(
          locale: resolveFontLocale(tester.platformDispatcher.locales),
        ),
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

  testWidgets('menus match the width of the button that opened them',
      (tester) async {
    const availableWidth = kWindowWidth - 2 * kPagePadding;
    await _pumpButtons(tester, availableWidth);
    // The bar reports the allotted width after the frame that laid the
    // buttons out, so give the rebuild it triggers a frame of its own.
    await tester.pump();

    final splitButtons = find.byType(YaruSplitButton);
    await tester.tap(_dropdownOf(splitButtons.at(1)));
    await tester.pumpAndSettle();

    final deny = tester.getRect(splitButtons.at(1));
    final menu = tester.getRect(
      find.descendant(
        of: find.byType(CustomSingleChildLayout),
        matching: find.byType(Material),
      ),
    );

    expect(menu.left, deny.left);
    expect(menu.width, deny.width);
    expect(menu.top, deny.bottom);
  });
}
