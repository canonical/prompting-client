import 'package:flutter/material.dart' hide Action;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/fake_prompting_client.dart';
import 'package:prompting_client_ui/l10n_x.dart';
import 'package:prompting_client_ui/main.dart' as app;
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_test/yaru_test.dart';

import '../test/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  YaruTestWindow.ensureInitialized();

  testWidgets('UI dry-run', (tester) async {
    await app.main(['--cgroup=123', '--dry-run']);
    await tester.pumpAndSettle();

    final fakeApparmorPromptingClient =
        getService<PromptingClient>() as FakeApparmorPromptingClient;
    fakeApparmorPromptingClient.onReply = (reply) => expect(
          reply,
          PromptReply.home(
            promptId: 'promptId',
            action: Action.deny,
            lifespan: Lifespan.forever,
            pathPattern: '/home/ubuntu/**/',
            permissions: {
              HomePermission.write,
              HomePermission.execute,
            },
          ),
        );

    // Navigate to metadata page
    await tester.tap(find.byIcon(YaruIcons.go_next).first);
    await tester.pumpAndSettle();
    expect(
      find.text(
        tester.l10n.homePromptMetaDataPublishedBy('Mozilla'),
        findRichText: true,
      ),
      findsOneWidget,
    );

    // Navigate back to standard page
    await tester.tap(find.byIcon(YaruIcons.go_previous));
    await tester.pumpAndSettle();

    // Navigate to more options page
    await tester.ensureVisibleAndTap(
      find.text(tester.l10n.homePromptMoreOptionsTileLabel),
    );
    await tester.pumpAndSettle();

    // Tap 'Custom path pattern' to navigate to custom path editor
    await tester.ensureVisibleAndTap(
      find.text(tester.l10n.homePatternTypeCustomPath).last,
    );
    await tester.pumpAndSettle();

    // Enter custom path
    await tester.enterText(find.byType(TextFormField), '/home/ubuntu/**/');

    // Save custom path
    await tester.ensureVisibleAndTap(
      find.text(tester.l10n.homeCustomPathSaveButton),
    );
    await tester.pumpAndSettle();

    // Toggle 'execute' permission via popup menu
    await tester.ensureVisibleAndTap(
      find.text(tester.l10n.homePromptPermissionsTitle),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(HomePermission.execute.localize(tester.l10n)),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    // Dismiss permissions popup
    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();

    // Deny always via split button menu
    await tester.tapSplitButtonMenuItem(
      tester.l10n.promptActionOptionDenyOnce,
      tester.l10n.promptActionOptionDenyAlways,
    );
    await tester.pumpAndSettle();
  });
}

extension on WidgetTester {
  Future<void> ensureVisibleAndTap(FinderBase<Element> finder) async {
    await ensureVisible(finder);
    await tap(finder);
  }
}
