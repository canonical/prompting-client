import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompting_client_ui/pages/home/home_standard_page.dart';
import 'package:prompting_client_ui/pages/prompt_page.dart';
import 'package:prompting_client_ui/theme.dart';

import 'test_utils.dart';

void main() {
  testWidgets('display home prompt', (tester) async {
    final container = createContainer();
    registerMockPromptDetails(
      promptDetails: mockPromptDetailsHome(
        requestedPath: '/home/ubuntu/Documents/foo.txt',
      ),
    );
    await tester.pumpApp(
      (_) => const PromptPage(),
      container: container,
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeStandardPage), findsOneWidget);
  });

  testWidgets(
      'measures its content at the window width, not the allocation it '
      'has while off screen', (tester) async {
    final container = createContainer();
    registerMockPromptDetails(
      promptDetails: mockPromptDetailsHome(
        requestedPath: '/home/ubuntu/Documents/foo.txt',
      ),
    );
    // GTK allocates an unmapped window's contents 1px wide, and the window is
    // unmapped until PromptPage has reported a height back. Measuring at that
    // allocation wraps every line and yields a height in the thousands.
    await tester.pumpApp(
      (_) => const SizedBox(width: 1, child: PromptPage()),
      container: container,
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(HomeStandardPage)).width,
      kWindowWidth - 2 * kPagePadding,
    );
    expect(
      tester.getSize(find.byType(HomeStandardPage)).height,
      lessThan(1000),
    );
  });

  testWidgets(
      'lets its content grow past the window width when given more room',
      (tester) async {
    final container = createContainer();
    registerMockPromptDetails(
      promptDetails: mockPromptDetailsHome(
        requestedPath: '/home/ubuntu/Documents/foo.txt',
      ),
    );
    // A floor, not a fixed width: on a wider surface (the test default) the
    // content takes what it is offered instead of stopping at kWindowWidth.
    const surfaceWidth = 760.0;
    await tester.pumpApp(
      (_) => const SizedBox(width: surfaceWidth, child: PromptPage()),
      container: container,
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(HomeStandardPage)).width,
      surfaceWidth - 2 * kPagePadding,
    );
  });
}
