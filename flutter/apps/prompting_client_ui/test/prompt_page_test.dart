import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prompting_client_ui/pages/home/home_standard_page.dart';
import 'package:prompting_client_ui/pages/prompt_page.dart';

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
}
