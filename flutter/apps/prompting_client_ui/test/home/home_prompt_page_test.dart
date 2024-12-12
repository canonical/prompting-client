import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/l10n_x.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_error.dart';
import 'package:prompting_client_ui/pages/prompt_page.dart';
import 'package:yaru_test/yaru_test.dart';

import '../test_utils.dart';

void main() {
  final testDetails = mockPromptDetailsHome(
    promptId: 'promptId',
    snapName: 'firefox',
    publisher: 'Mozilla',
    updatedAt: DateTime(2024),
    storeUrl: 'snap://firefox',
    requestedPath: '/home/ubuntu/Downloads/file.txt',
    homeDir: '/home/ubuntu',
    requestedPermissions: {HomePermission.read},
    availablePermissions: {
      HomePermission.read,
      HomePermission.write,
      HomePermission.execute,
    },
    suggestedPermissions: {HomePermission.read},
    patternOptions: {
      PatternOption(
        homePatternType: HomePatternType.topLevelDirectory,
        pathPattern: '/home/ubuntu/Downloads/**',
        showInitially: true,
      ),
    },
  );
  setUpAll(YaruTestWindow.ensureInitialized);

  group('display prompt details', () {
    for (final testCase in <({
      String name,
      String requestedPath,
      Set<PatternOption> options,
      EnrichedPathKind enrichedPathKind,
    })>[
      (
        name: 'file in subfolder',
        requestedPath: '/home/user/Pictures/nested/foo.jpeg',
        enrichedPathKind: EnrichedPathKind.subDirFile(),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.topLevelDirectory,
            pathPattern: '/home/user/Pictures/**',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.containingDirectory,
            pathPattern: '/home/user/Pictures/nested/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedFile,
            pathPattern: '/home/user/Pictures/nested/foo.jpeg',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.matchingFileExtension,
            pathPattern: '/home/user/Pictures/nested/*.jpeg',
          ),
        },
      ),
      (
        name: 'file in subfolder without extension',
        requestedPath: '/home/user/Pictures/nested/foo',
        enrichedPathKind: EnrichedPathKind.subDirFile(),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.topLevelDirectory,
            pathPattern: '/home/user/Pictures/**',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.containingDirectory,
            pathPattern: '/home/user/Pictures/nested/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedFile,
            pathPattern: '/home/user/Pictures/nested/foo',
            showInitially: true,
          ),
        },
      ),
      (
        name: 'file in top level folder',
        requestedPath: '/home/user/Downloads/foo.jpeg',
        enrichedPathKind: EnrichedPathKind.topLevelDirFile(
          filename: 'foo.jpeg',
          dirname: 'Downloads',
        ),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.topLevelDirectory,
            pathPattern: '/home/user/Downloads/**',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedFile,
            pathPattern: '/home/user/Downloads/foo.jpeg',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.matchingFileExtension,
            pathPattern: '/home/user/Downloads/*.jpeg',
          ),
        },
      ),
      (
        name: 'file in top level folder without extension',
        requestedPath: '/home/user/Downloads/foo',
        enrichedPathKind: EnrichedPathKind.topLevelDirFile(
          filename: 'foo',
          dirname: 'Downloads',
        ),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.topLevelDirectory,
            pathPattern: '/home/user/Downloads/**',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedFile,
            pathPattern: '/home/user/Downloads/foo',
            showInitially: true,
          ),
        },
      ),
      (
        name: 'file in home folder',
        requestedPath: '/home/user/foo.jpeg',
        enrichedPathKind: EnrichedPathKind.homeDirFile(filename: 'foo.jpeg'),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedFile,
            pathPattern: '/home/user/foo.jpeg',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.matchingFileExtension,
            pathPattern: '/home/user/*.jpeg',
          ),
        },
      ),
      (
        name: 'file in home folder without extension',
        requestedPath: '/home/user/foo',
        enrichedPathKind: EnrichedPathKind.homeDirFile(filename: 'foo'),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedFile,
            pathPattern: '/home/user/foo',
            showInitially: true,
          ),
        },
      ),
      (
        name: 'sub folder',
        requestedPath: '/home/user/Downloads/stuff/',
        enrichedPathKind: EnrichedPathKind.subDir(),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.topLevelDirectory,
            pathPattern: '/home/user/Downloads/**',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedDirectoryContents,
            pathPattern: '/home/user/Downloads/stuff/**',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedDirectory,
            pathPattern: '/home/user/Downloads/stuff/',
            showInitially: true,
          ),
        },
      ),
      (
        name: 'top level folder',
        requestedPath: '/home/user/Downloads/',
        enrichedPathKind: EnrichedPathKind.topLevelDir(dirname: 'Downloads'),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.topLevelDirectory,
            pathPattern: '/home/user/Downloads/**',
            showInitially: true,
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedDirectory,
            pathPattern: '/home/user/Downloads/',
            showInitially: true,
          ),
        },
      ),
      (
        name: 'top level folder',
        requestedPath: '/home/user/',
        enrichedPathKind: EnrichedPathKind.homeDir(),
        options: {
          PatternOption(
            homePatternType: HomePatternType.homeDirectory,
            pathPattern: '/home/user/**',
          ),
          PatternOption(
            homePatternType: HomePatternType.requestedDirectory,
            pathPattern: '/home/user/',
          ),
        },
      ),
    ]) {
      testWidgets(testCase.name, (tester) async {
        final container = createContainer();
        registerMockPromptDetails(
          promptDetails: testDetails.copyWith(
            requestedPath: testCase.requestedPath,
            patternOptions: testCase.options,
            enrichedPathKind: testCase.enrichedPathKind,
          ),
        );
        await tester.pumpApp(
          (_) => UncontrolledProviderScope(
            container: container,
            child: const PromptPage(),
          ),
        );

        testCase.enrichedPathKind.when(
          homeDir: () {
            expect(
              find.text(
                tester.l10n.homePromptHomeDirBody(
                  'firefox',
                  HomePermission.read.localize(tester.l10n).toLowerCase(),
                ),
              ),
              findsOneWidget,
            );
          },
          homeDirFile: (filename) {
            expect(
              find.text(
                tester.l10n.homePromptHomeDirFileBody(
                  'firefox',
                  HomePermission.read.localize(tester.l10n).toLowerCase(),
                  filename,
                ),
              ),
              findsOneWidget,
            );
          },
          topLevelDir: (dirname) {
            expect(
              find.text(
                tester.l10n.homePromptTopLevelDirBody(
                  'firefox',
                  HomePermission.read.localize(tester.l10n).toLowerCase(),
                  dirname,
                ),
              ),
              findsOneWidget,
            );
          },
          topLevelDirFile: (dirname, filename) {
            expect(
              find.text(
                tester.l10n.homePromptTopLevelDirFileBody(
                  'firefox',
                  HomePermission.read.localize(tester.l10n).toLowerCase(),
                  filename,
                  dirname,
                ),
              ),
              findsOneWidget,
            );
          },
          subDir: () {
            expect(
              find.text(
                tester.l10n.homePromptDefaultBody(
                  'firefox',
                  HomePermission.read.localize(tester.l10n).toLowerCase(),
                  testCase.requestedPath,
                ),
              ),
              findsOneWidget,
            );
          },
          subDirFile: () {
            expect(
              find.text(
                tester.l10n.homePromptDefaultBody(
                  'firefox',
                  HomePermission.read.localize(tester.l10n).toLowerCase(),
                  testCase.requestedPath,
                ),
              ),
              findsOneWidget,
            );
          },
        );

        expect(
          find.text(tester.l10n.homePromptMetaDataPublishedBy('Mozilla')),
          findsOneWidget,
        );

        for (final option in testCase.options.where((o) => o.showInitially)) {
          expect(find.text(option.localize(tester.l10n)), findsOneWidget);
          expect(find.text(option.pathPattern), findsOneWidget);
        }
        for (final option in testCase.options.where((o) => !o.showInitially)) {
          expect(find.text(option.localize(tester.l10n)), findsNothing);
          expect(find.text(option.pathPattern), findsNothing);
        }

        await tester.tap(
          find.text(tester.l10n.homePromptMoreOptionsLabel),
        );
        await tester.pumpAndSettle();

        for (final option in testCase.options) {
          expect(find.text(option.localize(tester.l10n)), findsOneWidget);
          expect(find.text(option.pathPattern), findsOneWidget);
        }
      });
    }
  });

  testWidgets('display prompt details without meta', (tester) async {
    final container = createContainer();
    final testDetailsWithoutMeta = testDetails.copyWith(
        metaData: MetaData(
          promptId: 'promptId',
          snapName: 'firefox',
          publisher: '',
          storeUrl: '',
        ),
        enrichedPathKind: EnrichedPathKind.topLevelDirFile(
          dirname: 'Downloads',
          filename: 'file.txt',
        ),);
    registerMockPromptDetails(
      promptDetails: testDetailsWithoutMeta,
    );
    await tester.pumpApp(
      (_) => UncontrolledProviderScope(
        container: container,
        child: const PromptPage(),
      ),
    );

    expect(
      find.text(
        tester.l10n.homePromptTopLevelDirFileBody(
          'firefox',
          HomePermission.read.localize(tester.l10n).toLowerCase(),
          'file.txt',
          'Downloads',
        ),
      ),
      findsOneWidget,
    );

    expect(
      find.text(tester.l10n.homePatternTypeTopLevelDirectory('Downloads')),
      findsOneWidget,
    );

    expect(
      find.text(tester.l10n.homePromptMetaDataPublishedBy('Mozilla')),
      findsNothing,
    );
  });

  group('submit prompt reply', () {
    final testCases = [
      (
        name: 'successful',
        replyResponse: PromptReplyResponse.success(),
      ),
      (
        name: 'prompt not found',
        replyResponse: PromptReplyResponse.promptNotFound(message: 'not found'),
      ),
    ];

    for (final testCase in testCases) {
      testWidgets(testCase.name, (tester) async {
        final container = createContainer();
        registerMockPromptDetails(
          promptDetails: testDetails,
        );
        final client = registerMockAppArmorPromptingClient(
          promptDetails: testDetails,
          replyResponse: testCase.replyResponse,
        );
        await tester.pumpApp(
          (_) => UncontrolledProviderScope(
            container: container,
            child: const PromptPage(),
          ),
        );

        await tester.tap(
          find.text(tester.l10n.homePromptMoreOptionsLabel),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.text(
            tester.l10n.homePatternTypeCustomPath,
          ),
        );

        final windowClosed = YaruTestWindow.waitForClosed();

        await tester.tap(find.text(tester.l10n.promptActionOptionDeny));
        await tester.pumpAndSettle();

        verify(
          client.replyToPrompt(
            PromptReply.home(
              promptId: 'promptId',
              action: Action.deny,
              lifespan: Lifespan.forever,
              pathPattern: '/home/ubuntu/Downloads/file.txt',
              permissions: {HomePermission.read},
            ),
          ),
        ).called(1);

        await expectLater(windowClosed, completes);
      });
    }
  });

  group('action buttons', () {
    final replyTemplate = PromptReply.home(
      promptId: 'promptId',
      action: Action.deny,
      lifespan: Lifespan.forever,
      pathPattern: '/home/ubuntu/Downloads/**',
      permissions: {HomePermission.read},
    );
    for (final testCase in <({
      String name,
      String Function(AppLocalizations l10) label,
      PromptReply expectedReply,
    })>[
      (
        name: 'allow always',
        label: (l10) => l10.promptActionOptionAllowAlways,
        expectedReply: replyTemplate.copyWith(
          action: Action.allow,
          lifespan: Lifespan.forever,
        ),
      ),
      (
        name: 'allow once',
        label: (l10) => l10.promptActionOptionAllowOnce,
        expectedReply: replyTemplate.copyWith(
          action: Action.allow,
          lifespan: Lifespan.single,
        ),
      ),
      (
        name: 'deny once',
        label: (l10) => l10.promptActionOptionDenyOnce,
        expectedReply: replyTemplate.copyWith(
          action: Action.deny,
          lifespan: Lifespan.single,
        ),
      ),
    ]) {
      testWidgets(testCase.name, (tester) async {
        final container = createContainer();
        registerMockPromptDetails(
          promptDetails: testDetails,
        );
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
    registerMockPromptDetails(
      promptDetails: testDetails,
    );
    registerMockAppArmorPromptingClient(
      promptDetails: testDetails,
      replyResponse: PromptReplyResponse.unknown(message: 'error message'),
    );
    final expectedError = HomePromptErrorUnknown('error message');

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

    await tester.tap(
      find.text(tester.l10n.homePromptMoreOptionsLabel),
    );
    await tester.pumpAndSettle();

    expect(find.text(expectedError.body(tester.l10n)), findsOneWidget);
    expect(find.text(expectedError.title(tester.l10n)), findsOneWidget);
  });
}
