import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      (_) => UncontrolledProviderScope(
        container: container,
        child: const PromptPage(),
      ),
    );

    expect(find.text(tester.l10n.cameraPromptBody('firefox')), findsOneWidget);
    expect(
      find.text(tester.l10n.promptActionOptionAllowAlways),
      findsOneWidget,
    );
    expect(
      find.text(tester.l10n.promptActionOptionAllowUntilLogout),
      findsOneWidget,
    );
    expect(find.text(tester.l10n.promptActionOptionDenyOnce), findsOneWidget);
  });

  group('action buttons', () {
    for (final testCase in <({
      String name,
      String Function(AppLocalizations l10) label,
      PromptReply expectedReply,
    })>[
      (
        name: 'allow always',
        label: (l10) => l10.promptActionOptionAllowAlways,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.allow,
          lifespan: Lifespan.forever,
          permissions: {CameraPermission.access},
        ),
      ),
      (
        name: 'allow until logout',
        label: (l10) => l10.promptActionOptionAllowUntilLogout,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.allow,
          lifespan: Lifespan.session,
          permissions: {CameraPermission.access},
        ),
      ),
      (
        name: 'deny once',
        label: (l10) => l10.promptActionOptionDenyOnce,
        expectedReply: PromptReply.camera(
          promptId: 'promptId',
          action: Action.deny,
          lifespan: Lifespan.single,
          permissions: {CameraPermission.access},
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
          (_) => UncontrolledProviderScope(
            container: container,
            child: const PromptPage(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(testCase.label(tester.l10n)));
        await tester.pumpAndSettle();

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
      (_) => UncontrolledProviderScope(
        container: container,
        child: const PromptPage(),
      ),
    );

    await tester.tap(find.text(tester.l10n.promptActionOptionAllowAlways));
    await tester.pumpAndSettle();

    expect(find.text(expectedError.body(tester.l10n)), findsOneWidget);
    expect(find.text(expectedError.title(tester.l10n)), findsOneWidget);
  });
}
