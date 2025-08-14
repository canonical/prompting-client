import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';
import 'package:prompting_client/src/generated/apparmor-prompting.pbgrpc.dart'
    as pb;
import 'package:prompting_client/src/generated/google/protobuf/wrappers.pb.dart';
import 'package:prompting_client/src/prompting_models.dart';

class PromptingClient {
  PromptingClient(InternetAddress host, [int port = 443])
      : _client = pb.AppArmorPromptingClient(
          ClientChannel(
            host,
            port: port,
            options: const ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  @visibleForTesting
  PromptingClient.withClient(this._client);

  final pb.AppArmorPromptingClient _client;

  Stream<PromptDetails> getCurrentPrompt(int pid) => _client
      .getCurrentPrompt(Int64Value(value: Int64(pid)))
      .map(PrompteDetailsConversion.fromProto);

  Future<PromptReplyResponse> replyToPrompt(PromptReply reply) => _client
      .replyToPrompt(reply.toProto())
      .then(PromptReplyResponseConversion.fromProto);

  Future<HomePatternType> resolveHomePatternType(String pattern) =>
      _client.resolveHomePatternType(StringValue(value: pattern)).then(
            (response) =>
                HomePatternTypeConversion.fromProto(response.homePatternType),
          );
}

extension ActionConversion on Action {
  pb.Action toProto() => switch (this) {
        Action.allow => pb.Action.ALLOW,
        Action.deny => pb.Action.DENY,
      };
}

extension HomePatternTypeConversion on HomePatternType {
  static HomePatternType fromProto(pb.HomePatternType homePatternType) =>
      switch (homePatternType) {
        pb.HomePatternType.REQUESTED_DIRECTORY =>
          HomePatternType.requestedDirectory,
        pb.HomePatternType.REQUESTED_FILE => HomePatternType.requestedFile,
        pb.HomePatternType.TOP_LEVEL_DIRECTORY =>
          HomePatternType.topLevelDirectory,
        pb.HomePatternType.CONTAINING_DIRECTORY =>
          HomePatternType.containingDirectory,
        pb.HomePatternType.HOME_DIRECTORY => HomePatternType.homeDirectory,
        pb.HomePatternType.MATCHING_FILE_EXTENSION =>
          HomePatternType.matchingFileExtension,
        pb.HomePatternType.REQUESTED_DIRECTORY_CONTENTS =>
          HomePatternType.requestedDirectoryContents,
        _ => throw ArgumentError('Unknown home pattern type: $homePatternType'),
      };
}

extension LifespanConversion on Lifespan {
  pb.Lifespan toProto() => switch (this) {
        Lifespan.single => pb.Lifespan.SINGLE,
        Lifespan.session => pb.Lifespan.SESSION,
        Lifespan.forever => pb.Lifespan.FOREVER,
      };
}

extension MetaDataConversion on MetaData {
  static MetaData fromProto(pb.MetaData metaData) => MetaData(
        promptId: metaData.promptId,
        snapName: metaData.snapName,
        storeUrl: metaData.storeUrl,
        publisher: metaData.publisher,
        updatedAt: DateTime.tryParse(metaData.updatedAt),
      );
}

extension MoreOptionConversion on PatternOption {
  static PatternOption fromProto(pb.HomePrompt_PatternOption patternOption) =>
      PatternOption(
        homePatternType:
            HomePatternTypeConversion.fromProto(patternOption.homePatternType),
        pathPattern: patternOption.pathPattern,
        showInitially: patternOption.showInitially,
      );
}

extension PermissionConversion on HomePermission {
  static HomePermission fromProto(pb.HomePermission permission) =>
      switch (permission) {
        pb.HomePermission.READ => HomePermission.read,
        pb.HomePermission.WRITE => HomePermission.write,
        pb.HomePermission.EXECUTE => HomePermission.execute,
        _ => throw ArgumentError('Unknown home permission: $permission'),
      };

  pb.HomePermission toProto() => switch (this) {
        HomePermission.read => pb.HomePermission.READ,
        HomePermission.write => pb.HomePermission.WRITE,
        HomePermission.execute => pb.HomePermission.EXECUTE,
      };
}

extension EnrichedPathKindConversion on EnrichedPathKind {
  static EnrichedPathKind fromProto(pb.EnrichedPathKind kind) =>
      switch (kind.whichKind()) {
        pb.EnrichedPathKind_Kind.homeDir => EnrichedPathKind.homeDir(),
        pb.EnrichedPathKind_Kind.topLevelDir => EnrichedPathKind.topLevelDir(
            dirname: kind.topLevelDir.dirname,
          ),
        pb.EnrichedPathKind_Kind.subDir => EnrichedPathKind.subDir(),
        pb.EnrichedPathKind_Kind.homeDirFile => EnrichedPathKind.homeDirFile(
            filename: kind.homeDirFile.filename,
          ),
        pb.EnrichedPathKind_Kind.topLevelDirFile =>
          EnrichedPathKind.topLevelDirFile(
            dirname: kind.topLevelDirFile.dirname,
            filename: kind.topLevelDirFile.filename,
          ),
        pb.EnrichedPathKind_Kind.subDirFile => EnrichedPathKind.subDirFile(),
        pb.EnrichedPathKind_Kind.notSet => throw ArgumentError('Unknown kind'),
      };
}

extension PrompteDetailsConversion on PromptDetails {
  static PromptDetails fromProto(pb.GetCurrentPromptResponse response) =>
      switch (response.whichPrompt()) {
        pb.GetCurrentPromptResponse_Prompt.homePrompt => PromptDetails.home(
            metaData:
                MetaDataConversion.fromProto(response.homePrompt.metaData),
            requestedPath: response.homePrompt.requestedPath,
            homeDir: response.homePrompt.homeDir,
            requestedPermissions: response.homePrompt.requestedPermissions
                .map(PermissionConversion.fromProto)
                .toSet(),
            availablePermissions: response.homePrompt.availablePermissions
                .map(PermissionConversion.fromProto)
                .toSet(),
            suggestedPermissions: response.homePrompt.suggestedPermissions
                .map(PermissionConversion.fromProto)
                .toSet(),
            patternOptions: response.homePrompt.patternOptions
                .map(MoreOptionConversion.fromProto)
                .toSet(),
            initialPatternOption: response.homePrompt.initialPatternOption,
            enrichedPathKind: EnrichedPathKindConversion.fromProto(
              response.homePrompt.enrichedPathKind,
            ),
          ),
        pb.GetCurrentPromptResponse_Prompt.notSet =>
          throw ArgumentError('Prompt type not set'),
      };
}

extension PromptReplyConversion on PromptReply {
  pb.PromptReply toProto() => switch (this) {
        PromptReplyHome() => pb.PromptReply(
            promptId: promptId,
            action: action.toProto(),
            lifespan: lifespan.toProto(),
            homePromptReply: pb.HomePromptReply(
              pathPattern: pathPattern,
              permissions: permissions.map((e) => e.toProto()),
            ),
          ),
      };
}

extension PromptReplyResponseConversion on PromptReplyResponse {
  static PromptReplyResponse fromProto(pb.PromptReplyResponse response) =>
      switch (response.whichPromptReplyType()) {
        pb.PromptReplyResponse_PromptReplyType.success =>
          PromptReplyResponse.success(),
        pb.PromptReplyResponse_PromptReplyType.promptNotFound =>
          PromptReplyResponse.promptNotFound(message: response.message),
        pb.PromptReplyResponse_PromptReplyType.raw ||
        // TODO: handle new cases explicitly
        pb.PromptReplyResponse_PromptReplyType.parseError ||
        pb.PromptReplyResponse_PromptReplyType.ruleNotFound ||
        pb.PromptReplyResponse_PromptReplyType.ruleConflicts ||
        pb.PromptReplyResponse_PromptReplyType.unsupportedValue ||
        pb.PromptReplyResponse_PromptReplyType.invalidPermissions ||
        pb.PromptReplyResponse_PromptReplyType.invalidPathPattern =>
          PromptReplyResponse.unknown(message: response.message),
        pb.PromptReplyResponse_PromptReplyType.notSet =>
          throw ArgumentError('Prompt reply type not set'),
      };
}
