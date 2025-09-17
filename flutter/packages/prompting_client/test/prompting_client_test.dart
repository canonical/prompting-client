import 'dart:async';
import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prompting_client/src/generated/apparmor-prompting.pbgrpc.dart'
    as pb;
import 'package:prompting_client/src/generated/google/protobuf/empty.pb.dart';
import 'package:prompting_client/src/generated/google/protobuf/wrappers.pb.dart';
import 'package:prompting_client/src/prompting_client.dart';
import 'package:prompting_client/src/prompting_models.dart';
import 'package:test/test.dart';

import 'prompting_client_test.mocks.dart';

void main() {
  group('get current prompt', () {
    final mockResponse = pb.GetCurrentPromptResponse(
      homePrompt: pb.HomePrompt(
        metaData: pb.MetaData(
          promptId: 'promptId',
          snapName: 'snapName',
          storeUrl: 'storeUrl',
          publisher: 'publisher',
          updatedAt: '2024-07-13T10:57:28.34963269+02:00',
          snapIcon: [1, 2, 3],
        ),
        requestedPath: '/home/user/Downloads/example.txt',
        homeDir: '/home/user',
        requestedPermissions: [pb.HomePermission.WRITE],
        availablePermissions: [
          pb.HomePermission.READ,
          pb.HomePermission.WRITE,
          pb.HomePermission.EXECUTE,
        ],
        suggestedPermissions: [pb.HomePermission.READ, pb.HomePermission.WRITE],
        patternOptions: [
          pb.HomePrompt_PatternOption(
            homePatternType: pb.HomePatternType.REQUESTED_DIRECTORY,
            pathPattern: '/home/user/Downloads/**',
          ),
        ],
        initialPatternOption: 0,
        enrichedPathKind: pb.EnrichedPathKind(
          homeDir: pb.HomeDir(),
        ),
      ),
    )..freeze();
    final testCases = [
      (
        name: 'valid home prompt',
        mockResponse: mockResponse,
        expectedDetails: PromptDetails.home(
          metaData: MetaData(
            promptId: 'promptId',
            snapName: 'snapName',
            storeUrl: 'storeUrl',
            publisher: 'publisher',
            updatedAt: DateTime.utc(2024, 7, 13, 8, 57, 28, 349, 632),
            snapIcon: Uint8List.fromList([1, 2, 3]),
          ),
          requestedPath: '/home/user/Downloads/example.txt',
          homeDir: '/home/user',
          requestedPermissions: {HomePermission.write},
          availablePermissions: {
            HomePermission.read,
            HomePermission.write,
            HomePermission.execute,
          },
          suggestedPermissions: {HomePermission.read, HomePermission.write},
          patternOptions: {
            PatternOption(
              homePatternType: HomePatternType.requestedDirectory,
              pathPattern: '/home/user/Downloads/**',
            ),
          },
          enrichedPathKind: EnrichedPathKind.homeDir(),
        ),
        expectError: false,
      ),
    ];

    for (final testCase in testCases) {
      test(testCase.name, () async {
        final client = PromptingClient.withClient(
          createMockClient(
            currentPromptResponse: testCase.mockResponse,
          ),
        );

        final promptDetailsStream = client.getCurrentPrompt('cgroup');
        if (testCase.expectError) {
          await expectLater(promptDetailsStream, throwsArgumentError);
        } else {
          await expectLater(
            promptDetailsStream,
            emits(testCase.expectedDetails),
          );
        }
      });
    }
  });

  group('reply to prompt', () {
    final testCases = [
      (
        name: 'valid home prompt reply',
        promptReply: PromptReply.home(
          promptId: 'promptId',
          action: Action.allow,
          lifespan: Lifespan.session,
          pathPattern: '/home/user/Downloads/**',
          permissions: {HomePermission.read, HomePermission.write},
        ),
        mockResponse: pb.PromptReplyResponse(success: Empty()),
        expectedProto: pb.PromptReply(
          promptId: 'promptId',
          action: pb.Action.ALLOW,
          lifespan: pb.Lifespan.SESSION,
          homePromptReply: pb.HomePromptReply(
            pathPattern: '/home/user/Downloads/**',
            permissions: [pb.HomePermission.READ, pb.HomePermission.WRITE],
          ),
        ),
        expectedResponse: PromptReplyResponse.success(),
      ),
      (
        name: 'invalid home prompt reply',
        promptReply: PromptReply.home(
          promptId: 'promptId',
          action: Action.deny,
          lifespan: Lifespan.forever,
          pathPattern: '/home/user/Downloads/**',
          permissions: {HomePermission.read, HomePermission.write},
        ),
        mockResponse: pb.PromptReplyResponse(
          raw: Empty(),
          message: 'error message',
        ),
        expectedProto: pb.PromptReply(
          promptId: 'promptId',
          action: pb.Action.DENY,
          lifespan: pb.Lifespan.FOREVER,
          homePromptReply: pb.HomePromptReply(
            pathPattern: '/home/user/Downloads/**',
            permissions: [pb.HomePermission.READ, pb.HomePermission.WRITE],
          ),
        ),
        expectedResponse: PromptReplyResponse.unknown(message: 'error message'),
      ),
    ];

    for (final testCase in testCases) {
      test(testCase.name, () async {
        final mockClient =
            createMockClient(promptReplyResponse: testCase.mockResponse);
        final client = PromptingClient.withClient(mockClient);

        final response = await client.replyToPrompt(testCase.promptReply);
        verify(
          mockClient.replyToPrompt(testCase.expectedProto),
        ).called(1);
        expect(response, equals(testCase.expectedResponse));
      });
    }
  });

  group('resolve home pattern type', () {
    final testCases = [
      (
        name: 'home directory',
        pattern: '/home/user/**',
        mockResponse: pb.ResolveHomePatternTypeResponse(
          homePatternType: pb.HomePatternType.HOME_DIRECTORY,
        ),
        expectedType: HomePatternType.homeDirectory,
      ),
      (
        name: 'requested directory',
        pattern: '/home/user/directory/**',
        mockResponse: pb.ResolveHomePatternTypeResponse(
          homePatternType: pb.HomePatternType.REQUESTED_DIRECTORY,
        ),
        expectedType: HomePatternType.requestedDirectory,
      ),
      (
        name: 'requested file',
        pattern: '/home/user/file.txt',
        mockResponse: pb.ResolveHomePatternTypeResponse(
          homePatternType: pb.HomePatternType.REQUESTED_FILE,
        ),
        expectedType: HomePatternType.requestedFile,
      ),
    ];

    for (final testCase in testCases) {
      test(testCase.name, () async {
        final mockClient = createMockClient();
        when(
          mockClient
              .resolveHomePatternType(StringValue(value: testCase.pattern)),
        ).thenAnswer((_) => MockResponseFuture(testCase.mockResponse));
        final client = PromptingClient.withClient(mockClient);

        final type = await client.resolveHomePatternType(testCase.pattern);
        expect(type, equals(testCase.expectedType));
      });
    }
  });

  group('home pattern type conversion is exhaustive', () {
    for (final variant in pb.HomePatternType.values) {
      test(variant.toString(), () {
        // Just checking that we don't throw for any of the protobuf variants
        HomePatternTypeConversion.fromProto(variant);
      });
    }
  });
}

@GenerateMocks([pb.AppArmorPromptingClient])
pb.AppArmorPromptingClient createMockClient({
  pb.GetCurrentPromptResponse? currentPromptResponse,
  pb.PromptReplyResponse? promptReplyResponse,
}) {
  final mockClient = MockAppArmorPromptingClient();
  when(mockClient.getCurrentPrompt(any)).thenAnswer(
    (_) => MockResponseStream(
      Stream.value(currentPromptResponse ?? pb.GetCurrentPromptResponse()),
    ),
  );
  when(mockClient.replyToPrompt(any)).thenAnswer(
    (_) => MockResponseFuture(promptReplyResponse ?? pb.PromptReplyResponse()),
  );
  return mockClient;
}

class MockResponseFuture<T> extends Mock implements ResponseFuture<T> {
  MockResponseFuture(this.value);
  final T value;

  @override
  Future<S> then<S>(FutureOr<S> Function(T) onValue, {Function? onError}) =>
      Future.value(value).then(
        onValue,
        onError: onError,
      );
}

class MockResponseStream<T> extends Mock implements ResponseStream<T> {
  MockResponseStream(this.stream);
  final Stream<T> stream;

  @override
  Stream<S> map<S>(S Function(T event) convert) => stream.map(convert);
}
