import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/theme.dart';
import 'package:prompting_client_ui/widgets/device_action_buttons.dart';
import 'package:yaru/yaru.dart';

void main() {
  testWidgets('action buttons fill the prompt width', (tester) async {
    const availableWidth = kWindowWidth - 2 * kPagePadding;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: yaruLight.customize(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SizedBox(
              width: availableWidth,
              child: DeviceActionButtons(
                onAction: ({required action, required lifespan}) async =>
                    PromptReplyResponse.success(),
              ),
            ),
          ),
        ),
      ),
    );

    final splitButtons = find.byType(YaruSplitButton);
    expect(splitButtons, findsNWidgets(2));

    for (var i = 0; i < 2; i++) {
      final splitButton = splitButtons.at(i);
      final dropdown = find.descendant(
        of: splitButton,
        matching: find.widgetWithIcon(FilledButton, YaruIcons.pan_down),
      );
      // The dropdown is the last thing in the split button's row, so its right
      // edge only reaches the full width if the main button expanded to fill
      // the space it was given.
      expect(
        tester.getBottomRight(dropdown).dx - tester.getTopLeft(splitButton).dx,
        availableWidth,
      );
    }
  });
}
