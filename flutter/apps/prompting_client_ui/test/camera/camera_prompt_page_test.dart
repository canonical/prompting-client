import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/camera/camera_prompt_error.dart';
import 'package:prompting_client_ui/pages/prompt_page.dart';

import '../test_utils.dart';

void main() {
  final testDetails = mockPromptDetailsCamera(
    promptId: 'promptId',
    snapName: 'firefox',
    publisher: 'Mozilla',
    updatedAt: DateTime(2024),
    storeUrl: 'snap://firefox',
  );

  testWidgets('display camera prompt', (tester) async {
    final container = createContainer();
    registerMockPromptDetails(promptDetails: testDetails);
    registerMockAppArmorPromptingClient(
      promptDetails: testDetails,
      replyResponse: PromptReplyResponse.success(),
    );
    await tester.pumpApp(
      (_) => const PromptPage(),
      container: container,
    );

    expect(find.text(tester.l10n.cameraPromptBody('firefox')), findsOneWidget);
    expect(
      find.text(tester.l10n.promptActionOptionAllowAlways),
      findsOneWidget,
    );
    expect(find.text(tester.l10n.promptActionOptionDenyOnce), findsOneWidget);
  });

  group('action buttons', () {
    for (final testCase in <({
      String name,
      String Function(AppLocalizations l10) label,
      String Function(AppLocalizations l10)? splitButtonParent,
      PromptReply expectedReply,
    })>[
      (
        name: 'allow always',
        label: (l10) => l10.promptActionOptionAllowAlways,
        splitButtonParent: null,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.allow,
          lifespan: Lifespan.forever,
          permissions: {DevicePermission.access},
        ),
      ),
      (
        name: 'allow until logout',
        label: (l10) => l10.promptActionOptionAllowUntilLogout,
        splitButtonParent: (l10) => l10.promptActionOptionAllowAlways,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.allow,
          lifespan: Lifespan.session,
          permissions: {DevicePermission.access},
        ),
      ),
      (
        name: 'allow once',
        label: (l10) => l10.promptActionOptionAllowOnce,
        splitButtonParent: (l10) => l10.promptActionOptionAllowAlways,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.allow,
          lifespan: Lifespan.single,
          permissions: {DevicePermission.access},
        ),
      ),
      (
        name: 'deny once',
        label: (l10) => l10.promptActionOptionDenyOnce,
        splitButtonParent: null,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.deny,
          lifespan: Lifespan.single,
          permissions: {DevicePermission.access},
        ),
      ),
      (
        name: 'deny always',
        label: (l10) => l10.promptActionOptionDenyAlways,
        splitButtonParent: (l10) => l10.promptActionOptionDenyOnce,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.deny,
          lifespan: Lifespan.forever,
          permissions: {DevicePermission.access},
        ),
      ),
      (
        name: 'deny until logout',
        label: (l10) => l10.promptActionOptionDenyUntilLogout,
        splitButtonParent: (l10) => l10.promptActionOptionDenyOnce,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.deny,
          lifespan: Lifespan.session,
          permissions: {DevicePermission.access},
        ),
      ),
    ]) {
      testWidgets(testCase.name, (tester) async {
        final container = createContainer();
        registerMockPromptDetails(promptDetails: testDetails);
        final client = registerMockAppArmorPromptingClient(
          promptDetails: testDetails,
          replyResponse: PromptReplyResponse.success(),
        );
        await tester.pumpApp(
          (_) => const PromptPage(),
          container: container,
        );
        await tester.pumpAndSettle();

        if (testCase.splitButtonParent != null) {
          await tester.tapSplitButtonMenuItem(
            testCase.splitButtonParent!(tester.l10n),
            testCase.label(tester.l10n),
          );
        } else {
          await tester.tap(find.text(testCase.label(tester.l10n)));
          await tester.pumpAndSettle();
        }

        verify(
          client.replyToPrompt(testCase.expectedReply),
        ).called(1);
      });
    }
  });

  testWidgets('show error message', (tester) async {
    final container = createContainer();
    final expectedError = CameraPromptErrorUnknown('Test error message');
    registerMockPromptDetails(promptDetails: testDetails);
    registerMockAppArmorPromptingClient(
      promptDetails: testDetails,
      replyResponse:
          PromptReplyResponse.unknown(message: expectedError.message),
    );
    await tester.pumpApp(
      (_) => const PromptPage(),
      container: container,
    );

    await tester.tap(find.text(tester.l10n.promptActionOptionAllowAlways));
    await tester.pumpAndSettle();

    expect(find.text(expectedError.body(tester.l10n)), findsOneWidget);
    expect(find.text(expectedError.title(tester.l10n)), findsOneWidget);
  });
}
