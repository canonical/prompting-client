import 'package:flutter/material.dart' hide Action, MetaData;
import 'package:flutter_test/flutter_test.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/l10n_x.dart';

import 'test_utils.dart';

void main() {
  group('pattern options', () {
    for (final testCase in <({
      String name,
      PatternOption option,
      String Function(AppLocalizations l10n) expected,
    })>[
      (
        name: 'custom path',
        option: PatternOption(
          homePatternType: HomePatternType.customPath,
          pathPattern: '',
        ),
        expected: (l10n) => l10n.homePatternTypeCustomPath,
      ),
      (
        name: 'requested directory',
        option: PatternOption(
          homePatternType: HomePatternType.requestedDirectory,
          pathPattern: '/foo/bar/',
        ),
        expected: (l10n) => l10n.homePatternTypeRequestedDirectory
      ),
      (
        name: 'requested file',
        option: PatternOption(
          homePatternType: HomePatternType.requestedFile,
          pathPattern: '/foo/bar/baz.txt',
        ),
        expected: (l10n) => l10n.homePatternTypeRequestedFile
      ),
      (
        name: 'top level directory',
        option: PatternOption(
          homePatternType: HomePatternType.topLevelDirectory,
          pathPattern: '/foo/bar/**',
        ),
        expected: (l10n) => l10n.homePatternTypeTopLevelDirectory('bar')
      ),
      (
        name: 'containing directory',
        option: PatternOption(
          homePatternType: HomePatternType.containingDirectory,
          pathPattern: '/foo/bar/**',
        ),
        expected: (l10n) => l10n.homePatternTypeContainingDirectory
      ),
      (
        name: 'home directory',
        option: PatternOption(
          homePatternType: HomePatternType.homeDirectory,
          pathPattern: '/home/user/**',
        ),
        expected: (l10n) => l10n.homePatternTypeHomeDirectory
      ),
      (
        name: 'matching file extension',
        option: PatternOption(
          homePatternType: HomePatternType.matchingFileExtension,
          pathPattern: '/foo/bar/*.txt',
        ),
        expected: (l10n) => l10n.homePatternTypeMatchingFileExtension('TXT')
      ),
      (
        name: 'requested directory contents',
        option: PatternOption(
          homePatternType: HomePatternType.requestedDirectoryContents,
          pathPattern: '/foo/bar/**',
        ),
        expected: (l10n) => l10n.homePatternTypeRequestedDirectoryContents
      ),
    ]) {
      testWidgets(testCase.name, (tester) async {
        await tester.pumpApp((_) => const SizedBox());
        expect(
          testCase.option.localize(tester.l10n),
          equals(testCase.expected(tester.l10n)),
        );
      });
    }
  });
}
