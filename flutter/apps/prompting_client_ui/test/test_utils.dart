import 'package:flutter/material.dart' hide MetaData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:ubuntu_service/ubuntu_service.dart';

import 'test_utils.mocks.dart';

extension WidgetTesterX on WidgetTester {
  BuildContext get context => element(find.byType(Scaffold).first);
  AppLocalizations get l10n => AppLocalizations.of(context);

  Future<void> pumpApp(WidgetBuilder builder) async {
    // The intended minimum size of the window.
    // TODO: (dloose) Revert to actual window size after fixing overflow issues
    view.physicalSize = (const Size(760, 990)) * view.devicePixelRatio;
    return pumpWidget(
      MaterialApp(
        home: Scaffold(body: Builder(builder: builder)),
        localizationsDelegates: localizationsDelegates,
      ),
    );
  }
}

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: [
      ...overrides,
    ],
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

PromptDetails mockPromptDetailsHome({
  String? promptId,
  String? snapName,
  String? publisher,
  DateTime? updatedAt,
  String? storeUrl,
  String? requestedPath,
  String? homeDir,
  Set<HomePermission>? requestedPermissions,
  Set<HomePermission>? availablePermissions,
  Set<HomePermission>? suggestedPermissions,
  Set<PatternOption>? patternOptions,
  EnrichedPathKind? enrichedPathKind,
}) =>
    PromptDetails.home(
      metaData: MetaData(
        promptId: promptId ?? '',
        snapName: snapName ?? '',
        publisher: publisher,
        updatedAt: updatedAt,
        storeUrl: storeUrl,
      ),
      requestedPath: requestedPath ?? '',
      homeDir: homeDir ?? '',
      requestedPermissions: requestedPermissions ?? {},
      availablePermissions: availablePermissions ?? {},
      suggestedPermissions: suggestedPermissions ?? {},
      patternOptions: patternOptions ?? {},
      enrichedPathKind: enrichedPathKind ?? EnrichedPathKind.homeDir(),
    );

PromptDetails mockPromptDetailsCamera({
  String? promptId,
  String? snapName,
  String? publisher,
  DateTime? updatedAt,
  String? storeUrl,
}) =>
    PromptDetails.camera(
      metaData: MetaData(
        promptId: promptId ?? '',
        snapName: snapName ?? '',
        publisher: publisher,
        updatedAt: updatedAt,
        storeUrl: storeUrl,
      ),
    );

PromptDetails mockPromptDetailsMicrophone({
  String? promptId,
  String? snapName,
  String? publisher,
  DateTime? updatedAt,
  String? storeUrl,
}) =>
    PromptDetails.microphone(
      metaData: MetaData(
        promptId: promptId ?? '',
        snapName: snapName ?? '',
        publisher: publisher,
        updatedAt: updatedAt,
        storeUrl: storeUrl,
      ),
    );

PromptDetails registerMockPromptDetails({
  required PromptDetails promptDetails,
}) {
  registerMockService<PromptDetails>(promptDetails);
  addTearDown(() => unregisterService<PromptDetails>());
  return promptDetails;
}

@GenerateMocks([PromptingClient])
PromptingClient registerMockAppArmorPromptingClient({
  required PromptDetails promptDetails,
  PromptReplyResponse? replyResponse,
}) {
  provideDummy<PromptDetails>(mockPromptDetailsHome());
  provideDummy<PromptReplyResponse>(PromptReplyResponse.unknown(message: ''));
  final client = MockPromptingClient();
  when(client.getCurrentPrompt(any))
      .thenAnswer((_) => Stream.value(promptDetails));
  when(client.replyToPrompt(any)).thenAnswer(
    (_) async => replyResponse ?? PromptReplyResponse.unknown(message: ''),
  );

  registerMockService<PromptingClient>(client);
  addTearDown(() => unregisterService<PromptingClient>());
  return client;
}
