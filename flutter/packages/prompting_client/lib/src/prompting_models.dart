import 'dart:io';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompting_models.freezed.dart';
part 'prompting_models.g.dart';

enum Action { allow, deny }

enum HomePatternType {
  customPath,
  requestedDirectory,
  requestedFile,
  topLevelDirectory,
  containingDirectory,
  homeDirectory,
  matchingFileExtension,
  requestedDirectoryContents,
}

// Technically there is also a 'timespan' variant of this enum (on the
// snapd side) but it isn't something that we are currently supporting
// through the prompt UI.
enum Lifespan { single, session, forever }

enum HomePermission { read, write, execute }

enum DevicePermission { access }

@freezed
class MetaData with _$MetaData {
  factory MetaData({
    required String promptId,
    required String snapName,
    DateTime? updatedAt,
    String? storeUrl,
    String? publisher,
    SnapIconData? snapIcon,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}

@freezed
class SnapIconData with _$SnapIconData {
  factory SnapIconData({
    @BytesConverter() required Uint8List bytes,
    required String mimeType,
  }) = _SnapIconData;

  factory SnapIconData.fromJson(Map<String, dynamic> json) =>
      _$SnapIconDataFromJson(json);
}

/// Used to 'deserialize' an icon from an image file in tests.
class BytesConverter implements JsonConverter<Uint8List, String> {
  const BytesConverter();

  @override
  Uint8List fromJson(String json) {
    try {
      return File(json).readAsBytesSync();
    } on FileSystemException catch (_) {
      return Uint8List(0);
    }
  }

  @override
  String toJson(Uint8List object) =>
      '[raw image data (${object.lengthInBytes} bytes)]';
}

@freezed
class PatternOption with _$PatternOption {
  factory PatternOption({
    required HomePatternType homePatternType,
    required String pathPattern,
    @Default(false) bool showInitially,
  }) = _PatternOption;

  factory PatternOption.fromJson(Map<String, dynamic> json) =>
      _$PatternOptionFromJson(json);
}

@freezed
sealed class EnrichedPathKind with _$EnrichedPathKind {
  factory EnrichedPathKind.homeDir() = EnrichedPathKindHomeDir;

  factory EnrichedPathKind.topLevelDir({
    required String dirname,
  }) = EnrichedPathKindTopLevelDir;

  factory EnrichedPathKind.subDir() = EnrichedPathKindSubDir;

  factory EnrichedPathKind.homeDirFile({
    required String filename,
  }) = EnrichedPathKindHomeDirFile;

  factory EnrichedPathKind.topLevelDirFile({
    required String dirname,
    required String filename,
  }) = EnrichedPathKindTopLevelDirFile;

  factory EnrichedPathKind.subDirFile() = EnrichedPathKindSubDirFile;

  factory EnrichedPathKind.fromJson(Map<String, dynamic> json) =>
      _$EnrichedPathKindFromJson(json);
}

@freezed
sealed class PromptDetails with _$PromptDetails {
  factory PromptDetails.home({
    required MetaData metaData,
    required String requestedPath,
    required String homeDir,
    required Set<HomePermission> requestedPermissions,
    required Set<HomePermission> availablePermissions,
    required Set<HomePermission> suggestedPermissions,
    required Set<PatternOption> patternOptions,
    required EnrichedPathKind enrichedPathKind,
    @Default(0) int initialPatternOption,
  }) = PromptDetailsHome;

  factory PromptDetails.camera({
    required MetaData metaData,
  }) = PromptDetailsCamera;

  factory PromptDetails.microphone({
    required MetaData metaData,
  }) = PromptDetailsMicrophone;

  factory PromptDetails.fromJson(Map<String, dynamic> json) =>
      _$PromptDetailsFromJson(json);
}

@freezed
sealed class PromptReply with _$PromptReply {
  factory PromptReply.home({
    required String promptId,
    required Action action,
    required Lifespan lifespan,
    required String pathPattern,
    required Set<HomePermission> permissions,
  }) = PromptReplyHome;

  factory PromptReply.camera({
    required String promptId,
    required Action action,
    required Lifespan lifespan,
    required Set<DevicePermission> permissions,
  }) = PromptReplyCamera;

  factory PromptReply.microphone({
    required String promptId,
    required Action action,
    required Lifespan lifespan,
    required Set<DevicePermission> permissions,
  }) = PromptReplyMicrophone;

  factory PromptReply.fromJson(Map<String, dynamic> json) =>
      _$PromptReplyFromJson(json);
}

@freezed
sealed class PromptReplyResponse with _$PromptReplyResponse {
  factory PromptReplyResponse.success() = PromptReplyResponseSuccess;
  factory PromptReplyResponse.promptNotFound({required String message}) =
      PromptReplyResponsePromptNotFound;
  factory PromptReplyResponse.unknown({required String message}) =
      PromptReplyResponseUnknown;
}
