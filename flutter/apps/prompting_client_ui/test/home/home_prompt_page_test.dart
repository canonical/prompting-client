import 'package:flutter/material.dart' hide Action, MetaData;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/l10n_x.dart';
import 'package:prompting_client_ui/pages/home/home_metadata_page.dart';
import 'package:prompting_client_ui/pages/home/home_more_options_page.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_error.dart';
import 'package:prompting_client_ui/pages/home/home_standard_page.dart';
import 'package:prompting_client_ui/pages/prompt_page.dart';
import 'package:yaru/yaru.dart';
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
          promptDetails: (testDetails as PromptDetailsHome).copyWith(
            requestedPath: testCase.requestedPath,
            patternOptions: testCase.options,
            enrichedPathKind: testCase.enrichedPathKind,
          ),
        );
        await tester.pumpApp(
          (_) => const PromptPage(),
          container: container,
        );

        switch (testCase.enrichedPathKind) {
          case EnrichedPathKindHomeDir():
            expect(
              find.text(
                tester.l10n.homePromptHomeDirBody(
                  'firefox',
                  HomePermission.read.localize(tester.l10n).toLowerCase(),
                ),
              ),
              findsOneWidget,
            );
            break;

          case EnrichedPathKindHomeDirFile(filename: final filename):
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
            break;

          case EnrichedPathKindTopLevelDir(dirname: final dirname):
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
            break;

          case EnrichedPathKindTopLevelDirFile(
              dirname: final dirname,
              filename: final filename
            ):
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
            break;

          case EnrichedPathKindSubDir():
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
            break;

          case EnrichedPathKindSubDirFile():
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
            break;
        }
        final selectedOption = testCase.options.toList()[0];
        // Selected options will be shown, so find them as well even if showInitially is false.

        for (final option in testCase.options
            .where((o) => o.showInitially || o == selectedOption)) {
          expect(find.text(option.localize(tester.l10n)), findsOneWidget);
        }
        for (final option in testCase.options.where(
          (o) => !o.showInitially && o != selectedOption,
        )) {
          expect(find.text(option.localize(tester.l10n)), findsNothing);
        }

        await tester.tap(
          find.text(tester.l10n.homePromptMoreOptionsTileLabel),
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
    final testDetailsWithoutMeta = (testDetails as PromptDetailsHome).copyWith(
      metaData: MetaData(
        promptId: 'promptId',
        snapName: 'firefox',
        publisher: '',
        storeUrl: '',
      ),
      enrichedPathKind: EnrichedPathKind.topLevelDirFile(
        dirname: 'Downloads',
        filename: 'file.txt',
      ),
    );
    registerMockPromptDetails(
      promptDetails: testDetailsWithoutMeta,
    );
    await tester.pumpApp(
      (_) => const PromptPage(),
      container: container,
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
      find.text(tester.l10n.homePromptMetaDataTitle),
      findsNothing,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Icon &&
            widget.icon == YaruIcons.go_next &&
            widget.size == 16,
      ),
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
          (_) => const PromptPage(),
          container: container,
        );

        await tester.tap(
          find.text(tester.l10n.homePromptMoreOptionsTileLabel),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.text(
            tester.l10n.homePatternTypeCustomPath,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.text(tester.l10n.homeCustomPathSaveButton),
        );
        await tester.pumpAndSettle();

        final windowClosed = YaruTestWindow.waitForClosed();

        await tester.tap(find.text(tester.l10n.promptActionOptionDenyOnce));
        await tester.pumpAndSettle();

        verify(
          client.replyToPrompt(
            PromptReply.home(
              promptId: 'promptId',
              action: Action.deny,
              lifespan: Lifespan.single,
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
      String Function(AppLocalizations l10)? splitButtonParent,
      PromptReply expectedReply,
    })>[
      (
        name: 'allow always',
        label: (l10) => l10.promptActionOptionAllowAlways,
        splitButtonParent: null,
        expectedReply: replyTemplate.copyWith(
          action: Action.allow,
          lifespan: Lifespan.forever,
        ),
      ),
      (
        name: 'allow until logout',
        label: (l10) => l10.promptActionOptionAllowUntilLogout,
        splitButtonParent: (l10) => l10.promptActionOptionAllowAlways,
        expectedReply: replyTemplate.copyWith(
          action: Action.allow,
          lifespan: Lifespan.session,
        ),
      ),
      (
        name: 'allow once',
        label: (l10) => l10.promptActionOptionAllowOnce,
        splitButtonParent: (l10) => l10.promptActionOptionAllowAlways,
        expectedReply: replyTemplate.copyWith(
          action: Action.allow,
          lifespan: Lifespan.single,
        ),
      ),
      (
        name: 'deny once',
        label: (l10) => l10.promptActionOptionDenyOnce,
        splitButtonParent: null,
        expectedReply: replyTemplate.copyWith(
          action: Action.deny,
          lifespan: Lifespan.single,
        ),
      ),
      (
        name: 'deny always',
        label: (l10) => l10.promptActionOptionDenyAlways,
        splitButtonParent: (l10) => l10.promptActionOptionDenyOnce,
        expectedReply: replyTemplate.copyWith(
          action: Action.deny,
          lifespan: Lifespan.forever,
        ),
      ),
      (
        name: 'deny until logout',
        label: (l10) => l10.promptActionOptionDenyUntilLogout,
        splitButtonParent: (l10) => l10.promptActionOptionDenyOnce,
        expectedReply: replyTemplate.copyWith(
          action: Action.deny,
          lifespan: Lifespan.session,
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
    registerMockPromptDetails(
      promptDetails: testDetails,
    );
    registerMockAppArmorPromptingClient(
      promptDetails: testDetails,
      replyResponse: PromptReplyResponse.unknown(message: 'error message'),
    );
    final expectedError = HomePromptErrorUnknown('error message');

    await tester.pumpApp(
      (_) => const PromptPage(),
      container: container,
    );

    await tester.tap(find.text(tester.l10n.promptActionOptionAllowAlways));
    await tester.pumpAndSettle();

    expect(find.text(expectedError.body(tester.l10n)), findsOneWidget);
    expect(find.text(expectedError.title(tester.l10n)), findsOneWidget);

    await tester.tap(
      find.text(tester.l10n.homePromptMoreOptionsTileLabel),
    );
    await tester.pumpAndSettle();

    expect(find.text(expectedError.body(tester.l10n)), findsOneWidget);
    expect(find.text(expectedError.title(tester.l10n)), findsOneWidget);
  });

  testWidgets('navigate to metadata page', (tester) async {
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

    expect(find.text(tester.l10n.homePromptMetaDataTitle), findsOneWidget);

    // Tap the metadata icon button (the smaller go_next icon, size 16)
    final metadataIcon = find.byWidgetPredicate(
      (widget) =>
          widget is Icon &&
          widget.icon == YaruIcons.go_next &&
          widget.size == 16,
    );
    await tester.tap(metadataIcon);
    await tester.pumpAndSettle();

    expect(find.byType(HomeMetadataPage), findsOneWidget);

    expect(
      find.textContaining('Mozilla'),
      findsOneWidget,
    );

    expect(
      find.text(tester.l10n.homePromptMetaDataAppCenterButton),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(YaruIcons.go_previous));
    await tester.pumpAndSettle();

    expect(find.byType(HomeStandardPage), findsOneWidget);
  });

  testWidgets('navigate to more options and select pattern', (tester) async {
    final container = createContainer();
    final details = (testDetails as PromptDetailsHome).copyWith(
      requestedPath: '/home/ubuntu/Pictures/nested/foo.jpeg',
      enrichedPathKind: EnrichedPathKind.subDirFile(),
      patternOptions: {
        PatternOption(
          homePatternType: HomePatternType.homeDirectory,
          pathPattern: '/home/ubuntu/**',
        ),
        PatternOption(
          homePatternType: HomePatternType.topLevelDirectory,
          pathPattern: '/home/ubuntu/Pictures/**',
          showInitially: true,
        ),
        PatternOption(
          homePatternType: HomePatternType.containingDirectory,
          pathPattern: '/home/ubuntu/Pictures/nested/**',
        ),
        PatternOption(
          homePatternType: HomePatternType.requestedFile,
          pathPattern: '/home/ubuntu/Pictures/nested/foo.jpeg',
          showInitially: true,
        ),
      },
    );
    registerMockPromptDetails(promptDetails: details);
    registerMockAppArmorPromptingClient(
      promptDetails: details,
      replyResponse: PromptReplyResponse.success(),
    );
    await tester.pumpApp(
      (_) => const PromptPage(),
      container: container,
    );

    await tester.tap(
      find.text(tester.l10n.homePromptMoreOptionsTileLabel),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeMoreOptionsPage), findsOneWidget);

    for (final option in details.patternOptions) {
      expect(find.text(option.localize(tester.l10n)), findsOneWidget);
      expect(find.text(option.pathPattern), findsOneWidget);
    }

    // Select a non-initially-visible option (containing directory)
    final containingDir = details.patternOptions.firstWhere(
      (o) => o.homePatternType == HomePatternType.containingDirectory,
    );
    await tester.tap(find.text(containingDir.localize(tester.l10n)));
    await tester.pumpAndSettle();

    // Verify navigation back to standard page
    expect(find.byType(HomeStandardPage), findsOneWidget);

    // The selected option should now be visible on standard page
    expect(find.text(containingDir.localize(tester.l10n)), findsOneWidget);
  });

  testWidgets('custom path editor save flow', (tester) async {
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

    await tester.tap(
      find.text(tester.l10n.homePromptMoreOptionsTileLabel),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(tester.l10n.homePatternTypeCustomPath));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField),
      '/custom/path/**',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(tester.l10n.homeCustomPathSaveButton));
    await tester.pumpAndSettle();

    // Should be back on standard page
    expect(find.byType(HomeStandardPage), findsOneWidget);

    final windowClosed = YaruTestWindow.waitForClosed();

    // Submit with deny once
    await tester.tap(find.text(tester.l10n.promptActionOptionDenyOnce));
    await tester.pumpAndSettle();

    // Verify the custom path was used in reply
    verify(
      client.replyToPrompt(
        PromptReply.home(
          promptId: 'promptId',
          action: Action.deny,
          lifespan: Lifespan.single,
          pathPattern: '/custom/path/**',
          permissions: {HomePermission.read},
        ),
      ),
    ).called(1);

    await expectLater(windowClosed, completes);
  });

  testWidgets('custom path editor cancel flow', (tester) async {
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

    await tester.tap(
      find.text(tester.l10n.homePromptMoreOptionsTileLabel),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(tester.l10n.homePatternTypeCustomPath));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField),
      '/modified/path/**',
    );
    await tester.pumpAndSettle();

    // Cancel by tapping back button
    await tester.tap(find.byIcon(YaruIcons.go_previous));
    await tester.pumpAndSettle();
    expect(find.byType(HomeMoreOptionsPage), findsOneWidget);

    await tester.tap(find.byIcon(YaruIcons.go_previous));
    await tester.pumpAndSettle();
    expect(find.byType(HomeStandardPage), findsOneWidget);
  });

  testWidgets('toggle permissions', (tester) async {
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

    await tester.tap(find.text(tester.l10n.homePromptPermissionsTitle));
    await tester.pumpAndSettle();

    // Toggle write permission on via the popup menu item
    final writePermission = HomePermission.write;
    final menuItem = find.descendant(
      of: find.byType(YaruMultiSelectPopupMenuItem<HomePermission>),
      matching: find.text(writePermission.localize(tester.l10n)),
    );
    await tester.tap(menuItem, warnIfMissed: false);
    await tester.pumpAndSettle();

    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();

    final windowClosed = YaruTestWindow.waitForClosed();

    await tester.tap(find.text(tester.l10n.promptActionOptionAllowAlways));
    await tester.pumpAndSettle();

    verify(
      client.replyToPrompt(
        PromptReply.home(
          promptId: 'promptId',
          action: Action.allow,
          lifespan: Lifespan.forever,
          pathPattern: '/home/ubuntu/Downloads/**',
          permissions: {HomePermission.read, HomePermission.write},
        ),
      ),
    ).called(1);

    await expectLater(windowClosed, completes);
  });
}
