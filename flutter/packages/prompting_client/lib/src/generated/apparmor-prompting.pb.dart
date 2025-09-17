// This is a generated file - do not edit.
//
// Generated from apparmor-prompting.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'apparmor-prompting.pbenum.dart';
import 'google/protobuf/empty.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'apparmor-prompting.pbenum.dart';

enum PromptReply_PromptReply {
  homePromptReply,
  cameraPromptReply,
  microphonePromptReply,
  notSet
}

class PromptReply extends $pb.GeneratedMessage {
  factory PromptReply({
    $core.String? promptId,
    Action? action,
    Lifespan? lifespan,
    HomePromptReply? homePromptReply,
    CameraPromptReply? cameraPromptReply,
    MicrophonePromptReply? microphonePromptReply,
  }) {
    final result = create();
    if (promptId != null) result.promptId = promptId;
    if (action != null) result.action = action;
    if (lifespan != null) result.lifespan = lifespan;
    if (homePromptReply != null) result.homePromptReply = homePromptReply;
    if (cameraPromptReply != null) result.cameraPromptReply = cameraPromptReply;
    if (microphonePromptReply != null)
      result.microphonePromptReply = microphonePromptReply;
    return result;
  }

  PromptReply._();

  factory PromptReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PromptReply_PromptReply>
      _PromptReply_PromptReplyByTag = {
    4: PromptReply_PromptReply.homePromptReply,
    5: PromptReply_PromptReply.cameraPromptReply,
    6: PromptReply_PromptReply.microphonePromptReply,
    0: PromptReply_PromptReply.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..oo(0, [4, 5, 6])
    ..aOS(1, _omitFieldNames ? '' : 'promptId')
    ..e<Action>(2, _omitFieldNames ? '' : 'action', $pb.PbFieldType.OE,
        defaultOrMaker: Action.ALLOW,
        valueOf: Action.valueOf,
        enumValues: Action.values)
    ..e<Lifespan>(3, _omitFieldNames ? '' : 'lifespan', $pb.PbFieldType.OE,
        defaultOrMaker: Lifespan.SINGLE,
        valueOf: Lifespan.valueOf,
        enumValues: Lifespan.values)
    ..aOM<HomePromptReply>(4, _omitFieldNames ? '' : 'homePromptReply',
        subBuilder: HomePromptReply.create)
    ..aOM<CameraPromptReply>(5, _omitFieldNames ? '' : 'cameraPromptReply',
        subBuilder: CameraPromptReply.create)
    ..aOM<MicrophonePromptReply>(
        6, _omitFieldNames ? '' : 'microphonePromptReply',
        subBuilder: MicrophonePromptReply.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReply clone() => PromptReply()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReply copyWith(void Function(PromptReply) updates) =>
      super.copyWith((message) => updates(message as PromptReply))
          as PromptReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReply create() => PromptReply._();
  @$core.override
  PromptReply createEmptyInstance() => create();
  static $pb.PbList<PromptReply> createRepeated() => $pb.PbList<PromptReply>();
  @$core.pragma('dart2js:noInline')
  static PromptReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromptReply>(create);
  static PromptReply? _defaultInstance;

  PromptReply_PromptReply whichPromptReply() =>
      _PromptReply_PromptReplyByTag[$_whichOneof(0)]!;
  void clearPromptReply() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get promptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set promptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPromptId() => $_clearField(1);

  @$pb.TagNumber(2)
  Action get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(Action value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);

  @$pb.TagNumber(3)
  Lifespan get lifespan => $_getN(2);
  @$pb.TagNumber(3)
  set lifespan(Lifespan value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLifespan() => $_has(2);
  @$pb.TagNumber(3)
  void clearLifespan() => $_clearField(3);

  @$pb.TagNumber(4)
  HomePromptReply get homePromptReply => $_getN(3);
  @$pb.TagNumber(4)
  set homePromptReply(HomePromptReply value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasHomePromptReply() => $_has(3);
  @$pb.TagNumber(4)
  void clearHomePromptReply() => $_clearField(4);
  @$pb.TagNumber(4)
  HomePromptReply ensureHomePromptReply() => $_ensure(3);

  @$pb.TagNumber(5)
  CameraPromptReply get cameraPromptReply => $_getN(4);
  @$pb.TagNumber(5)
  set cameraPromptReply(CameraPromptReply value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCameraPromptReply() => $_has(4);
  @$pb.TagNumber(5)
  void clearCameraPromptReply() => $_clearField(5);
  @$pb.TagNumber(5)
  CameraPromptReply ensureCameraPromptReply() => $_ensure(4);

  @$pb.TagNumber(6)
  MicrophonePromptReply get microphonePromptReply => $_getN(5);
  @$pb.TagNumber(6)
  set microphonePromptReply(MicrophonePromptReply value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMicrophonePromptReply() => $_has(5);
  @$pb.TagNumber(6)
  void clearMicrophonePromptReply() => $_clearField(6);
  @$pb.TagNumber(6)
  MicrophonePromptReply ensureMicrophonePromptReply() => $_ensure(5);
}

class PromptReplyResponse_HomeRuleConflicts extends $pb.GeneratedMessage {
  factory PromptReplyResponse_HomeRuleConflicts({
    $core.Iterable<PromptReplyResponse_HomeRuleConflict>? conflicts,
  }) {
    final result = create();
    if (conflicts != null) result.conflicts.addAll(conflicts);
    return result;
  }

  PromptReplyResponse_HomeRuleConflicts._();

  factory PromptReplyResponse_HomeRuleConflicts.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptReplyResponse_HomeRuleConflicts.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptReplyResponse.HomeRuleConflicts',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..pc<PromptReplyResponse_HomeRuleConflict>(
        1, _omitFieldNames ? '' : 'conflicts', $pb.PbFieldType.PM,
        subBuilder: PromptReplyResponse_HomeRuleConflict.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_HomeRuleConflicts clone() =>
      PromptReplyResponse_HomeRuleConflicts()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_HomeRuleConflicts copyWith(
          void Function(PromptReplyResponse_HomeRuleConflicts) updates) =>
      super.copyWith((message) =>
              updates(message as PromptReplyResponse_HomeRuleConflicts))
          as PromptReplyResponse_HomeRuleConflicts;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_HomeRuleConflicts create() =>
      PromptReplyResponse_HomeRuleConflicts._();
  @$core.override
  PromptReplyResponse_HomeRuleConflicts createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_HomeRuleConflicts> createRepeated() =>
      $pb.PbList<PromptReplyResponse_HomeRuleConflicts>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_HomeRuleConflicts getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PromptReplyResponse_HomeRuleConflicts>(create);
  static PromptReplyResponse_HomeRuleConflicts? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PromptReplyResponse_HomeRuleConflict> get conflicts =>
      $_getList(0);
}

class PromptReplyResponse_HomeRuleConflict extends $pb.GeneratedMessage {
  factory PromptReplyResponse_HomeRuleConflict({
    HomePermission? permission,
    $core.String? variant,
    $core.String? conflictingId,
  }) {
    final result = create();
    if (permission != null) result.permission = permission;
    if (variant != null) result.variant = variant;
    if (conflictingId != null) result.conflictingId = conflictingId;
    return result;
  }

  PromptReplyResponse_HomeRuleConflict._();

  factory PromptReplyResponse_HomeRuleConflict.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptReplyResponse_HomeRuleConflict.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptReplyResponse.HomeRuleConflict',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..e<HomePermission>(
        1, _omitFieldNames ? '' : 'permission', $pb.PbFieldType.OE,
        defaultOrMaker: HomePermission.READ,
        valueOf: HomePermission.valueOf,
        enumValues: HomePermission.values)
    ..aOS(2, _omitFieldNames ? '' : 'variant')
    ..aOS(3, _omitFieldNames ? '' : 'conflictingId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_HomeRuleConflict clone() =>
      PromptReplyResponse_HomeRuleConflict()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_HomeRuleConflict copyWith(
          void Function(PromptReplyResponse_HomeRuleConflict) updates) =>
      super.copyWith((message) =>
              updates(message as PromptReplyResponse_HomeRuleConflict))
          as PromptReplyResponse_HomeRuleConflict;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_HomeRuleConflict create() =>
      PromptReplyResponse_HomeRuleConflict._();
  @$core.override
  PromptReplyResponse_HomeRuleConflict createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_HomeRuleConflict> createRepeated() =>
      $pb.PbList<PromptReplyResponse_HomeRuleConflict>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_HomeRuleConflict getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PromptReplyResponse_HomeRuleConflict>(create);
  static PromptReplyResponse_HomeRuleConflict? _defaultInstance;

  @$pb.TagNumber(1)
  HomePermission get permission => $_getN(0);
  @$pb.TagNumber(1)
  set permission(HomePermission value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPermission() => $_has(0);
  @$pb.TagNumber(1)
  void clearPermission() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get variant => $_getSZ(1);
  @$pb.TagNumber(2)
  set variant($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVariant() => $_has(1);
  @$pb.TagNumber(2)
  void clearVariant() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get conflictingId => $_getSZ(2);
  @$pb.TagNumber(3)
  set conflictingId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConflictingId() => $_has(2);
  @$pb.TagNumber(3)
  void clearConflictingId() => $_clearField(3);
}

class PromptReplyResponse_InvalidHomePermissions extends $pb.GeneratedMessage {
  factory PromptReplyResponse_InvalidHomePermissions({
    $core.Iterable<HomePermission>? requested,
    $core.Iterable<HomePermission>? replied,
  }) {
    final result = create();
    if (requested != null) result.requested.addAll(requested);
    if (replied != null) result.replied.addAll(replied);
    return result;
  }

  PromptReplyResponse_InvalidHomePermissions._();

  factory PromptReplyResponse_InvalidHomePermissions.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptReplyResponse_InvalidHomePermissions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptReplyResponse.InvalidHomePermissions',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..pc<HomePermission>(
        1, _omitFieldNames ? '' : 'requested', $pb.PbFieldType.KE,
        valueOf: HomePermission.valueOf,
        enumValues: HomePermission.values,
        defaultEnumValue: HomePermission.READ)
    ..pc<HomePermission>(
        2, _omitFieldNames ? '' : 'replied', $pb.PbFieldType.KE,
        valueOf: HomePermission.valueOf,
        enumValues: HomePermission.values,
        defaultEnumValue: HomePermission.READ)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_InvalidHomePermissions clone() =>
      PromptReplyResponse_InvalidHomePermissions()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_InvalidHomePermissions copyWith(
          void Function(PromptReplyResponse_InvalidHomePermissions) updates) =>
      super.copyWith((message) =>
              updates(message as PromptReplyResponse_InvalidHomePermissions))
          as PromptReplyResponse_InvalidHomePermissions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_InvalidHomePermissions create() =>
      PromptReplyResponse_InvalidHomePermissions._();
  @$core.override
  PromptReplyResponse_InvalidHomePermissions createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_InvalidHomePermissions>
      createRepeated() =>
          $pb.PbList<PromptReplyResponse_InvalidHomePermissions>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_InvalidHomePermissions getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PromptReplyResponse_InvalidHomePermissions>(create);
  static PromptReplyResponse_InvalidHomePermissions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<HomePermission> get requested => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<HomePermission> get replied => $_getList(1);
}

class PromptReplyResponse_InvalidPathPattern extends $pb.GeneratedMessage {
  factory PromptReplyResponse_InvalidPathPattern({
    $core.String? requested,
    $core.String? replied,
  }) {
    final result = create();
    if (requested != null) result.requested = requested;
    if (replied != null) result.replied = replied;
    return result;
  }

  PromptReplyResponse_InvalidPathPattern._();

  factory PromptReplyResponse_InvalidPathPattern.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptReplyResponse_InvalidPathPattern.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptReplyResponse.InvalidPathPattern',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requested')
    ..aOS(2, _omitFieldNames ? '' : 'replied')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_InvalidPathPattern clone() =>
      PromptReplyResponse_InvalidPathPattern()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_InvalidPathPattern copyWith(
          void Function(PromptReplyResponse_InvalidPathPattern) updates) =>
      super.copyWith((message) =>
              updates(message as PromptReplyResponse_InvalidPathPattern))
          as PromptReplyResponse_InvalidPathPattern;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_InvalidPathPattern create() =>
      PromptReplyResponse_InvalidPathPattern._();
  @$core.override
  PromptReplyResponse_InvalidPathPattern createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_InvalidPathPattern> createRepeated() =>
      $pb.PbList<PromptReplyResponse_InvalidPathPattern>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_InvalidPathPattern getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PromptReplyResponse_InvalidPathPattern>(create);
  static PromptReplyResponse_InvalidPathPattern? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requested => $_getSZ(0);
  @$pb.TagNumber(1)
  set requested($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequested() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequested() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get replied => $_getSZ(1);
  @$pb.TagNumber(2)
  set replied($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReplied() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplied() => $_clearField(2);
}

class PromptReplyResponse_ParseError extends $pb.GeneratedMessage {
  factory PromptReplyResponse_ParseError({
    $core.String? field_1,
    $core.String? value,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    if (value != null) result.value = value;
    return result;
  }

  PromptReplyResponse_ParseError._();

  factory PromptReplyResponse_ParseError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptReplyResponse_ParseError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptReplyResponse.ParseError',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_ParseError clone() =>
      PromptReplyResponse_ParseError()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_ParseError copyWith(
          void Function(PromptReplyResponse_ParseError) updates) =>
      super.copyWith(
              (message) => updates(message as PromptReplyResponse_ParseError))
          as PromptReplyResponse_ParseError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_ParseError create() =>
      PromptReplyResponse_ParseError._();
  @$core.override
  PromptReplyResponse_ParseError createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_ParseError> createRepeated() =>
      $pb.PbList<PromptReplyResponse_ParseError>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_ParseError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse_ParseError>(create);
  static PromptReplyResponse_ParseError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class PromptReplyResponse_UnsupportedValue extends $pb.GeneratedMessage {
  factory PromptReplyResponse_UnsupportedValue({
    $core.String? field_1,
    $core.Iterable<$core.String>? supported,
    $core.Iterable<$core.String>? provided,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    if (supported != null) result.supported.addAll(supported);
    if (provided != null) result.provided.addAll(provided);
    return result;
  }

  PromptReplyResponse_UnsupportedValue._();

  factory PromptReplyResponse_UnsupportedValue.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptReplyResponse_UnsupportedValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptReplyResponse.UnsupportedValue',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..pPS(2, _omitFieldNames ? '' : 'supported')
    ..pPS(3, _omitFieldNames ? '' : 'provided')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_UnsupportedValue clone() =>
      PromptReplyResponse_UnsupportedValue()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse_UnsupportedValue copyWith(
          void Function(PromptReplyResponse_UnsupportedValue) updates) =>
      super.copyWith((message) =>
              updates(message as PromptReplyResponse_UnsupportedValue))
          as PromptReplyResponse_UnsupportedValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_UnsupportedValue create() =>
      PromptReplyResponse_UnsupportedValue._();
  @$core.override
  PromptReplyResponse_UnsupportedValue createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_UnsupportedValue> createRepeated() =>
      $pb.PbList<PromptReplyResponse_UnsupportedValue>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_UnsupportedValue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PromptReplyResponse_UnsupportedValue>(create);
  static PromptReplyResponse_UnsupportedValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get supported => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get provided => $_getList(2);
}

enum PromptReplyResponse_PromptReplyType {
  success,
  raw,
  promptNotFound,
  ruleNotFound,
  ruleConflicts,
  invalidPermissions,
  invalidPathPattern,
  parseError,
  unsupportedValue,
  notSet
}

class PromptReplyResponse extends $pb.GeneratedMessage {
  factory PromptReplyResponse({
    $core.String? message,
    $2.Empty? success,
    $2.Empty? raw,
    $2.Empty? promptNotFound,
    $2.Empty? ruleNotFound,
    PromptReplyResponse_HomeRuleConflicts? ruleConflicts,
    PromptReplyResponse_InvalidHomePermissions? invalidPermissions,
    PromptReplyResponse_InvalidPathPattern? invalidPathPattern,
    PromptReplyResponse_ParseError? parseError,
    PromptReplyResponse_UnsupportedValue? unsupportedValue,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (success != null) result.success = success;
    if (raw != null) result.raw = raw;
    if (promptNotFound != null) result.promptNotFound = promptNotFound;
    if (ruleNotFound != null) result.ruleNotFound = ruleNotFound;
    if (ruleConflicts != null) result.ruleConflicts = ruleConflicts;
    if (invalidPermissions != null)
      result.invalidPermissions = invalidPermissions;
    if (invalidPathPattern != null)
      result.invalidPathPattern = invalidPathPattern;
    if (parseError != null) result.parseError = parseError;
    if (unsupportedValue != null) result.unsupportedValue = unsupportedValue;
    return result;
  }

  PromptReplyResponse._();

  factory PromptReplyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptReplyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PromptReplyResponse_PromptReplyType>
      _PromptReplyResponse_PromptReplyTypeByTag = {
    2: PromptReplyResponse_PromptReplyType.success,
    3: PromptReplyResponse_PromptReplyType.raw,
    4: PromptReplyResponse_PromptReplyType.promptNotFound,
    5: PromptReplyResponse_PromptReplyType.ruleNotFound,
    6: PromptReplyResponse_PromptReplyType.ruleConflicts,
    7: PromptReplyResponse_PromptReplyType.invalidPermissions,
    8: PromptReplyResponse_PromptReplyType.invalidPathPattern,
    9: PromptReplyResponse_PromptReplyType.parseError,
    10: PromptReplyResponse_PromptReplyType.unsupportedValue,
    0: PromptReplyResponse_PromptReplyType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptReplyResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..aOM<$2.Empty>(2, _omitFieldNames ? '' : 'success',
        subBuilder: $2.Empty.create)
    ..aOM<$2.Empty>(3, _omitFieldNames ? '' : 'raw',
        subBuilder: $2.Empty.create)
    ..aOM<$2.Empty>(4, _omitFieldNames ? '' : 'promptNotFound',
        subBuilder: $2.Empty.create)
    ..aOM<$2.Empty>(5, _omitFieldNames ? '' : 'ruleNotFound',
        subBuilder: $2.Empty.create)
    ..aOM<PromptReplyResponse_HomeRuleConflicts>(
        6, _omitFieldNames ? '' : 'ruleConflicts',
        subBuilder: PromptReplyResponse_HomeRuleConflicts.create)
    ..aOM<PromptReplyResponse_InvalidHomePermissions>(
        7, _omitFieldNames ? '' : 'invalidPermissions',
        subBuilder: PromptReplyResponse_InvalidHomePermissions.create)
    ..aOM<PromptReplyResponse_InvalidPathPattern>(
        8, _omitFieldNames ? '' : 'invalidPathPattern',
        subBuilder: PromptReplyResponse_InvalidPathPattern.create)
    ..aOM<PromptReplyResponse_ParseError>(
        9, _omitFieldNames ? '' : 'parseError',
        subBuilder: PromptReplyResponse_ParseError.create)
    ..aOM<PromptReplyResponse_UnsupportedValue>(
        10, _omitFieldNames ? '' : 'unsupportedValue',
        subBuilder: PromptReplyResponse_UnsupportedValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse clone() => PromptReplyResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptReplyResponse copyWith(void Function(PromptReplyResponse) updates) =>
      super.copyWith((message) => updates(message as PromptReplyResponse))
          as PromptReplyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse create() => PromptReplyResponse._();
  @$core.override
  PromptReplyResponse createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse> createRepeated() =>
      $pb.PbList<PromptReplyResponse>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse>(create);
  static PromptReplyResponse? _defaultInstance;

  PromptReplyResponse_PromptReplyType whichPromptReplyType() =>
      _PromptReplyResponse_PromptReplyTypeByTag[$_whichOneof(0)]!;
  void clearPromptReplyType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Empty get success => $_getN(1);
  @$pb.TagNumber(2)
  set success($2.Empty value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Empty ensureSuccess() => $_ensure(1);

  @$pb.TagNumber(3)
  $2.Empty get raw => $_getN(2);
  @$pb.TagNumber(3)
  set raw($2.Empty value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRaw() => $_has(2);
  @$pb.TagNumber(3)
  void clearRaw() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Empty ensureRaw() => $_ensure(2);

  @$pb.TagNumber(4)
  $2.Empty get promptNotFound => $_getN(3);
  @$pb.TagNumber(4)
  set promptNotFound($2.Empty value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPromptNotFound() => $_has(3);
  @$pb.TagNumber(4)
  void clearPromptNotFound() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Empty ensurePromptNotFound() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Empty get ruleNotFound => $_getN(4);
  @$pb.TagNumber(5)
  set ruleNotFound($2.Empty value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRuleNotFound() => $_has(4);
  @$pb.TagNumber(5)
  void clearRuleNotFound() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Empty ensureRuleNotFound() => $_ensure(4);

  @$pb.TagNumber(6)
  PromptReplyResponse_HomeRuleConflicts get ruleConflicts => $_getN(5);
  @$pb.TagNumber(6)
  set ruleConflicts(PromptReplyResponse_HomeRuleConflicts value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRuleConflicts() => $_has(5);
  @$pb.TagNumber(6)
  void clearRuleConflicts() => $_clearField(6);
  @$pb.TagNumber(6)
  PromptReplyResponse_HomeRuleConflicts ensureRuleConflicts() => $_ensure(5);

  @$pb.TagNumber(7)
  PromptReplyResponse_InvalidHomePermissions get invalidPermissions =>
      $_getN(6);
  @$pb.TagNumber(7)
  set invalidPermissions(PromptReplyResponse_InvalidHomePermissions value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasInvalidPermissions() => $_has(6);
  @$pb.TagNumber(7)
  void clearInvalidPermissions() => $_clearField(7);
  @$pb.TagNumber(7)
  PromptReplyResponse_InvalidHomePermissions ensureInvalidPermissions() =>
      $_ensure(6);

  @$pb.TagNumber(8)
  PromptReplyResponse_InvalidPathPattern get invalidPathPattern => $_getN(7);
  @$pb.TagNumber(8)
  set invalidPathPattern(PromptReplyResponse_InvalidPathPattern value) =>
      $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasInvalidPathPattern() => $_has(7);
  @$pb.TagNumber(8)
  void clearInvalidPathPattern() => $_clearField(8);
  @$pb.TagNumber(8)
  PromptReplyResponse_InvalidPathPattern ensureInvalidPathPattern() =>
      $_ensure(7);

  @$pb.TagNumber(9)
  PromptReplyResponse_ParseError get parseError => $_getN(8);
  @$pb.TagNumber(9)
  set parseError(PromptReplyResponse_ParseError value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasParseError() => $_has(8);
  @$pb.TagNumber(9)
  void clearParseError() => $_clearField(9);
  @$pb.TagNumber(9)
  PromptReplyResponse_ParseError ensureParseError() => $_ensure(8);

  @$pb.TagNumber(10)
  PromptReplyResponse_UnsupportedValue get unsupportedValue => $_getN(9);
  @$pb.TagNumber(10)
  set unsupportedValue(PromptReplyResponse_UnsupportedValue value) =>
      $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUnsupportedValue() => $_has(9);
  @$pb.TagNumber(10)
  void clearUnsupportedValue() => $_clearField(10);
  @$pb.TagNumber(10)
  PromptReplyResponse_UnsupportedValue ensureUnsupportedValue() => $_ensure(9);
}

enum GetCurrentPromptResponse_Prompt {
  homePrompt,
  cameraPrompt,
  microphonePrompt,
  notSet
}

class GetCurrentPromptResponse extends $pb.GeneratedMessage {
  factory GetCurrentPromptResponse({
    HomePrompt? homePrompt,
    CameraPrompt? cameraPrompt,
    MicrophonePrompt? microphonePrompt,
  }) {
    final result = create();
    if (homePrompt != null) result.homePrompt = homePrompt;
    if (cameraPrompt != null) result.cameraPrompt = cameraPrompt;
    if (microphonePrompt != null) result.microphonePrompt = microphonePrompt;
    return result;
  }

  GetCurrentPromptResponse._();

  factory GetCurrentPromptResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCurrentPromptResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, GetCurrentPromptResponse_Prompt>
      _GetCurrentPromptResponse_PromptByTag = {
    1: GetCurrentPromptResponse_Prompt.homePrompt,
    2: GetCurrentPromptResponse_Prompt.cameraPrompt,
    3: GetCurrentPromptResponse_Prompt.microphonePrompt,
    0: GetCurrentPromptResponse_Prompt.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentPromptResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<HomePrompt>(1, _omitFieldNames ? '' : 'homePrompt',
        subBuilder: HomePrompt.create)
    ..aOM<CameraPrompt>(2, _omitFieldNames ? '' : 'cameraPrompt',
        subBuilder: CameraPrompt.create)
    ..aOM<MicrophonePrompt>(3, _omitFieldNames ? '' : 'microphonePrompt',
        subBuilder: MicrophonePrompt.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentPromptResponse clone() =>
      GetCurrentPromptResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentPromptResponse copyWith(
          void Function(GetCurrentPromptResponse) updates) =>
      super.copyWith((message) => updates(message as GetCurrentPromptResponse))
          as GetCurrentPromptResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentPromptResponse create() => GetCurrentPromptResponse._();
  @$core.override
  GetCurrentPromptResponse createEmptyInstance() => create();
  static $pb.PbList<GetCurrentPromptResponse> createRepeated() =>
      $pb.PbList<GetCurrentPromptResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentPromptResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentPromptResponse>(create);
  static GetCurrentPromptResponse? _defaultInstance;

  GetCurrentPromptResponse_Prompt whichPrompt() =>
      _GetCurrentPromptResponse_PromptByTag[$_whichOneof(0)]!;
  void clearPrompt() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  HomePrompt get homePrompt => $_getN(0);
  @$pb.TagNumber(1)
  set homePrompt(HomePrompt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHomePrompt() => $_has(0);
  @$pb.TagNumber(1)
  void clearHomePrompt() => $_clearField(1);
  @$pb.TagNumber(1)
  HomePrompt ensureHomePrompt() => $_ensure(0);

  @$pb.TagNumber(2)
  CameraPrompt get cameraPrompt => $_getN(1);
  @$pb.TagNumber(2)
  set cameraPrompt(CameraPrompt value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCameraPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCameraPrompt() => $_clearField(2);
  @$pb.TagNumber(2)
  CameraPrompt ensureCameraPrompt() => $_ensure(1);

  @$pb.TagNumber(3)
  MicrophonePrompt get microphonePrompt => $_getN(2);
  @$pb.TagNumber(3)
  set microphonePrompt(MicrophonePrompt value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMicrophonePrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearMicrophonePrompt() => $_clearField(3);
  @$pb.TagNumber(3)
  MicrophonePrompt ensureMicrophonePrompt() => $_ensure(2);
}

class HomePromptReply extends $pb.GeneratedMessage {
  factory HomePromptReply({
    $core.String? pathPattern,
    $core.Iterable<HomePermission>? permissions,
  }) {
    final result = create();
    if (pathPattern != null) result.pathPattern = pathPattern;
    if (permissions != null) result.permissions.addAll(permissions);
    return result;
  }

  HomePromptReply._();

  factory HomePromptReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HomePromptReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HomePromptReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pathPattern')
    ..pc<HomePermission>(
        2, _omitFieldNames ? '' : 'permissions', $pb.PbFieldType.KE,
        valueOf: HomePermission.valueOf,
        enumValues: HomePermission.values,
        defaultEnumValue: HomePermission.READ)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomePromptReply clone() => HomePromptReply()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomePromptReply copyWith(void Function(HomePromptReply) updates) =>
      super.copyWith((message) => updates(message as HomePromptReply))
          as HomePromptReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HomePromptReply create() => HomePromptReply._();
  @$core.override
  HomePromptReply createEmptyInstance() => create();
  static $pb.PbList<HomePromptReply> createRepeated() =>
      $pb.PbList<HomePromptReply>();
  @$core.pragma('dart2js:noInline')
  static HomePromptReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HomePromptReply>(create);
  static HomePromptReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pathPattern => $_getSZ(0);
  @$pb.TagNumber(1)
  set pathPattern($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPathPattern() => $_has(0);
  @$pb.TagNumber(1)
  void clearPathPattern() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<HomePermission> get permissions => $_getList(1);
}

class CameraPromptReply extends $pb.GeneratedMessage {
  factory CameraPromptReply({
    $core.Iterable<DevicePermission>? permissions,
  }) {
    final result = create();
    if (permissions != null) result.permissions.addAll(permissions);
    return result;
  }

  CameraPromptReply._();

  factory CameraPromptReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CameraPromptReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CameraPromptReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..pc<DevicePermission>(
        1, _omitFieldNames ? '' : 'permissions', $pb.PbFieldType.KE,
        valueOf: DevicePermission.valueOf,
        enumValues: DevicePermission.values,
        defaultEnumValue: DevicePermission.ACCESS)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CameraPromptReply clone() => CameraPromptReply()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CameraPromptReply copyWith(void Function(CameraPromptReply) updates) =>
      super.copyWith((message) => updates(message as CameraPromptReply))
          as CameraPromptReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CameraPromptReply create() => CameraPromptReply._();
  @$core.override
  CameraPromptReply createEmptyInstance() => create();
  static $pb.PbList<CameraPromptReply> createRepeated() =>
      $pb.PbList<CameraPromptReply>();
  @$core.pragma('dart2js:noInline')
  static CameraPromptReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CameraPromptReply>(create);
  static CameraPromptReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DevicePermission> get permissions => $_getList(0);
}

class MicrophonePromptReply extends $pb.GeneratedMessage {
  factory MicrophonePromptReply({
    $core.Iterable<DevicePermission>? permissions,
  }) {
    final result = create();
    if (permissions != null) result.permissions.addAll(permissions);
    return result;
  }

  MicrophonePromptReply._();

  factory MicrophonePromptReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MicrophonePromptReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MicrophonePromptReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..pc<DevicePermission>(
        1, _omitFieldNames ? '' : 'permissions', $pb.PbFieldType.KE,
        valueOf: DevicePermission.valueOf,
        enumValues: DevicePermission.values,
        defaultEnumValue: DevicePermission.ACCESS)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MicrophonePromptReply clone() =>
      MicrophonePromptReply()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MicrophonePromptReply copyWith(
          void Function(MicrophonePromptReply) updates) =>
      super.copyWith((message) => updates(message as MicrophonePromptReply))
          as MicrophonePromptReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MicrophonePromptReply create() => MicrophonePromptReply._();
  @$core.override
  MicrophonePromptReply createEmptyInstance() => create();
  static $pb.PbList<MicrophonePromptReply> createRepeated() =>
      $pb.PbList<MicrophonePromptReply>();
  @$core.pragma('dart2js:noInline')
  static MicrophonePromptReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MicrophonePromptReply>(create);
  static MicrophonePromptReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DevicePermission> get permissions => $_getList(0);
}

class HomePrompt_PatternOption extends $pb.GeneratedMessage {
  factory HomePrompt_PatternOption({
    HomePatternType? homePatternType,
    $core.String? pathPattern,
    $core.bool? showInitially,
  }) {
    final result = create();
    if (homePatternType != null) result.homePatternType = homePatternType;
    if (pathPattern != null) result.pathPattern = pathPattern;
    if (showInitially != null) result.showInitially = showInitially;
    return result;
  }

  HomePrompt_PatternOption._();

  factory HomePrompt_PatternOption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HomePrompt_PatternOption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HomePrompt.PatternOption',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..e<HomePatternType>(
        1, _omitFieldNames ? '' : 'homePatternType', $pb.PbFieldType.OE,
        defaultOrMaker: HomePatternType.REQUESTED_DIRECTORY,
        valueOf: HomePatternType.valueOf,
        enumValues: HomePatternType.values)
    ..aOS(2, _omitFieldNames ? '' : 'pathPattern')
    ..aOB(3, _omitFieldNames ? '' : 'showInitially')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomePrompt_PatternOption clone() =>
      HomePrompt_PatternOption()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomePrompt_PatternOption copyWith(
          void Function(HomePrompt_PatternOption) updates) =>
      super.copyWith((message) => updates(message as HomePrompt_PatternOption))
          as HomePrompt_PatternOption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HomePrompt_PatternOption create() => HomePrompt_PatternOption._();
  @$core.override
  HomePrompt_PatternOption createEmptyInstance() => create();
  static $pb.PbList<HomePrompt_PatternOption> createRepeated() =>
      $pb.PbList<HomePrompt_PatternOption>();
  @$core.pragma('dart2js:noInline')
  static HomePrompt_PatternOption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HomePrompt_PatternOption>(create);
  static HomePrompt_PatternOption? _defaultInstance;

  @$pb.TagNumber(1)
  HomePatternType get homePatternType => $_getN(0);
  @$pb.TagNumber(1)
  set homePatternType(HomePatternType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHomePatternType() => $_has(0);
  @$pb.TagNumber(1)
  void clearHomePatternType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pathPattern => $_getSZ(1);
  @$pb.TagNumber(2)
  set pathPattern($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPathPattern() => $_has(1);
  @$pb.TagNumber(2)
  void clearPathPattern() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get showInitially => $_getBF(2);
  @$pb.TagNumber(3)
  set showInitially($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShowInitially() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowInitially() => $_clearField(3);
}

class HomePrompt extends $pb.GeneratedMessage {
  factory HomePrompt({
    MetaData? metaData,
    $core.String? requestedPath,
    $core.String? homeDir,
    $core.Iterable<HomePermission>? requestedPermissions,
    $core.Iterable<HomePermission>? availablePermissions,
    $core.Iterable<HomePermission>? suggestedPermissions,
    $core.Iterable<HomePrompt_PatternOption>? patternOptions,
    $core.int? initialPatternOption,
    EnrichedPathKind? enrichedPathKind,
  }) {
    final result = create();
    if (metaData != null) result.metaData = metaData;
    if (requestedPath != null) result.requestedPath = requestedPath;
    if (homeDir != null) result.homeDir = homeDir;
    if (requestedPermissions != null)
      result.requestedPermissions.addAll(requestedPermissions);
    if (availablePermissions != null)
      result.availablePermissions.addAll(availablePermissions);
    if (suggestedPermissions != null)
      result.suggestedPermissions.addAll(suggestedPermissions);
    if (patternOptions != null) result.patternOptions.addAll(patternOptions);
    if (initialPatternOption != null)
      result.initialPatternOption = initialPatternOption;
    if (enrichedPathKind != null) result.enrichedPathKind = enrichedPathKind;
    return result;
  }

  HomePrompt._();

  factory HomePrompt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HomePrompt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HomePrompt',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOM<MetaData>(1, _omitFieldNames ? '' : 'metaData',
        subBuilder: MetaData.create)
    ..aOS(2, _omitFieldNames ? '' : 'requestedPath')
    ..aOS(3, _omitFieldNames ? '' : 'homeDir')
    ..pc<HomePermission>(
        4, _omitFieldNames ? '' : 'requestedPermissions', $pb.PbFieldType.KE,
        valueOf: HomePermission.valueOf,
        enumValues: HomePermission.values,
        defaultEnumValue: HomePermission.READ)
    ..pc<HomePermission>(
        5, _omitFieldNames ? '' : 'availablePermissions', $pb.PbFieldType.KE,
        valueOf: HomePermission.valueOf,
        enumValues: HomePermission.values,
        defaultEnumValue: HomePermission.READ)
    ..pc<HomePermission>(
        6, _omitFieldNames ? '' : 'suggestedPermissions', $pb.PbFieldType.KE,
        valueOf: HomePermission.valueOf,
        enumValues: HomePermission.values,
        defaultEnumValue: HomePermission.READ)
    ..pc<HomePrompt_PatternOption>(
        7, _omitFieldNames ? '' : 'patternOptions', $pb.PbFieldType.PM,
        subBuilder: HomePrompt_PatternOption.create)
    ..a<$core.int>(
        8, _omitFieldNames ? '' : 'initialPatternOption', $pb.PbFieldType.O3)
    ..aOM<EnrichedPathKind>(9, _omitFieldNames ? '' : 'enrichedPathKind',
        subBuilder: EnrichedPathKind.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomePrompt clone() => HomePrompt()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomePrompt copyWith(void Function(HomePrompt) updates) =>
      super.copyWith((message) => updates(message as HomePrompt)) as HomePrompt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HomePrompt create() => HomePrompt._();
  @$core.override
  HomePrompt createEmptyInstance() => create();
  static $pb.PbList<HomePrompt> createRepeated() => $pb.PbList<HomePrompt>();
  @$core.pragma('dart2js:noInline')
  static HomePrompt getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HomePrompt>(create);
  static HomePrompt? _defaultInstance;

  @$pb.TagNumber(1)
  MetaData get metaData => $_getN(0);
  @$pb.TagNumber(1)
  set metaData(MetaData value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetaData() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetaData() => $_clearField(1);
  @$pb.TagNumber(1)
  MetaData ensureMetaData() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get requestedPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestedPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestedPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestedPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get homeDir => $_getSZ(2);
  @$pb.TagNumber(3)
  set homeDir($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHomeDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearHomeDir() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<HomePermission> get requestedPermissions => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<HomePermission> get availablePermissions => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<HomePermission> get suggestedPermissions => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<HomePrompt_PatternOption> get patternOptions => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get initialPatternOption => $_getIZ(7);
  @$pb.TagNumber(8)
  set initialPatternOption($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasInitialPatternOption() => $_has(7);
  @$pb.TagNumber(8)
  void clearInitialPatternOption() => $_clearField(8);

  @$pb.TagNumber(9)
  EnrichedPathKind get enrichedPathKind => $_getN(8);
  @$pb.TagNumber(9)
  set enrichedPathKind(EnrichedPathKind value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEnrichedPathKind() => $_has(8);
  @$pb.TagNumber(9)
  void clearEnrichedPathKind() => $_clearField(9);
  @$pb.TagNumber(9)
  EnrichedPathKind ensureEnrichedPathKind() => $_ensure(8);
}

class CameraPrompt extends $pb.GeneratedMessage {
  factory CameraPrompt({
    MetaData? metaData,
  }) {
    final result = create();
    if (metaData != null) result.metaData = metaData;
    return result;
  }

  CameraPrompt._();

  factory CameraPrompt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CameraPrompt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CameraPrompt',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOM<MetaData>(1, _omitFieldNames ? '' : 'metaData',
        subBuilder: MetaData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CameraPrompt clone() => CameraPrompt()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CameraPrompt copyWith(void Function(CameraPrompt) updates) =>
      super.copyWith((message) => updates(message as CameraPrompt))
          as CameraPrompt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CameraPrompt create() => CameraPrompt._();
  @$core.override
  CameraPrompt createEmptyInstance() => create();
  static $pb.PbList<CameraPrompt> createRepeated() =>
      $pb.PbList<CameraPrompt>();
  @$core.pragma('dart2js:noInline')
  static CameraPrompt getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CameraPrompt>(create);
  static CameraPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  MetaData get metaData => $_getN(0);
  @$pb.TagNumber(1)
  set metaData(MetaData value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetaData() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetaData() => $_clearField(1);
  @$pb.TagNumber(1)
  MetaData ensureMetaData() => $_ensure(0);
}

class MicrophonePrompt extends $pb.GeneratedMessage {
  factory MicrophonePrompt({
    MetaData? metaData,
  }) {
    final result = create();
    if (metaData != null) result.metaData = metaData;
    return result;
  }

  MicrophonePrompt._();

  factory MicrophonePrompt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MicrophonePrompt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MicrophonePrompt',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOM<MetaData>(1, _omitFieldNames ? '' : 'metaData',
        subBuilder: MetaData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MicrophonePrompt clone() => MicrophonePrompt()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MicrophonePrompt copyWith(void Function(MicrophonePrompt) updates) =>
      super.copyWith((message) => updates(message as MicrophonePrompt))
          as MicrophonePrompt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MicrophonePrompt create() => MicrophonePrompt._();
  @$core.override
  MicrophonePrompt createEmptyInstance() => create();
  static $pb.PbList<MicrophonePrompt> createRepeated() =>
      $pb.PbList<MicrophonePrompt>();
  @$core.pragma('dart2js:noInline')
  static MicrophonePrompt getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MicrophonePrompt>(create);
  static MicrophonePrompt? _defaultInstance;

  @$pb.TagNumber(1)
  MetaData get metaData => $_getN(0);
  @$pb.TagNumber(1)
  set metaData(MetaData value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetaData() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetaData() => $_clearField(1);
  @$pb.TagNumber(1)
  MetaData ensureMetaData() => $_ensure(0);
}

class MetaData extends $pb.GeneratedMessage {
  factory MetaData({
    $core.String? promptId,
    $core.String? snapName,
    $core.String? storeUrl,
    $core.String? publisher,
    $core.String? updatedAt,
    $core.List<$core.int>? snapIcon,
  }) {
    final result = create();
    if (promptId != null) result.promptId = promptId;
    if (snapName != null) result.snapName = snapName;
    if (storeUrl != null) result.storeUrl = storeUrl;
    if (publisher != null) result.publisher = publisher;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (snapIcon != null) result.snapIcon = snapIcon;
    return result;
  }

  MetaData._();

  factory MetaData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetaData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetaData',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'promptId')
    ..aOS(2, _omitFieldNames ? '' : 'snapName')
    ..aOS(3, _omitFieldNames ? '' : 'storeUrl')
    ..aOS(4, _omitFieldNames ? '' : 'publisher')
    ..aOS(5, _omitFieldNames ? '' : 'updatedAt')
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'snapIcon', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetaData clone() => MetaData()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetaData copyWith(void Function(MetaData) updates) =>
      super.copyWith((message) => updates(message as MetaData)) as MetaData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetaData create() => MetaData._();
  @$core.override
  MetaData createEmptyInstance() => create();
  static $pb.PbList<MetaData> createRepeated() => $pb.PbList<MetaData>();
  @$core.pragma('dart2js:noInline')
  static MetaData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MetaData>(create);
  static MetaData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get promptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set promptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPromptId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get snapName => $_getSZ(1);
  @$pb.TagNumber(2)
  set snapName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSnapName() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get storeUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set storeUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStoreUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearStoreUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get publisher => $_getSZ(3);
  @$pb.TagNumber(4)
  set publisher($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPublisher() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublisher() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get updatedAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set updatedAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get snapIcon => $_getN(5);
  @$pb.TagNumber(6)
  set snapIcon($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSnapIcon() => $_has(5);
  @$pb.TagNumber(6)
  void clearSnapIcon() => $_clearField(6);
}

class ResolveHomePatternTypeResponse extends $pb.GeneratedMessage {
  factory ResolveHomePatternTypeResponse({
    HomePatternType? homePatternType,
  }) {
    final result = create();
    if (homePatternType != null) result.homePatternType = homePatternType;
    return result;
  }

  ResolveHomePatternTypeResponse._();

  factory ResolveHomePatternTypeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveHomePatternTypeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveHomePatternTypeResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..e<HomePatternType>(
        1, _omitFieldNames ? '' : 'homePatternType', $pb.PbFieldType.OE,
        defaultOrMaker: HomePatternType.REQUESTED_DIRECTORY,
        valueOf: HomePatternType.valueOf,
        enumValues: HomePatternType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveHomePatternTypeResponse clone() =>
      ResolveHomePatternTypeResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveHomePatternTypeResponse copyWith(
          void Function(ResolveHomePatternTypeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ResolveHomePatternTypeResponse))
          as ResolveHomePatternTypeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveHomePatternTypeResponse create() =>
      ResolveHomePatternTypeResponse._();
  @$core.override
  ResolveHomePatternTypeResponse createEmptyInstance() => create();
  static $pb.PbList<ResolveHomePatternTypeResponse> createRepeated() =>
      $pb.PbList<ResolveHomePatternTypeResponse>();
  @$core.pragma('dart2js:noInline')
  static ResolveHomePatternTypeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveHomePatternTypeResponse>(create);
  static ResolveHomePatternTypeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  HomePatternType get homePatternType => $_getN(0);
  @$pb.TagNumber(1)
  set homePatternType(HomePatternType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHomePatternType() => $_has(0);
  @$pb.TagNumber(1)
  void clearHomePatternType() => $_clearField(1);
}

class SetLoggingFilterResponse extends $pb.GeneratedMessage {
  factory SetLoggingFilterResponse({
    $core.String? current,
  }) {
    final result = create();
    if (current != null) result.current = current;
    return result;
  }

  SetLoggingFilterResponse._();

  factory SetLoggingFilterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetLoggingFilterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetLoggingFilterResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'current')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetLoggingFilterResponse clone() =>
      SetLoggingFilterResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetLoggingFilterResponse copyWith(
          void Function(SetLoggingFilterResponse) updates) =>
      super.copyWith((message) => updates(message as SetLoggingFilterResponse))
          as SetLoggingFilterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetLoggingFilterResponse create() => SetLoggingFilterResponse._();
  @$core.override
  SetLoggingFilterResponse createEmptyInstance() => create();
  static $pb.PbList<SetLoggingFilterResponse> createRepeated() =>
      $pb.PbList<SetLoggingFilterResponse>();
  @$core.pragma('dart2js:noInline')
  static SetLoggingFilterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetLoggingFilterResponse>(create);
  static SetLoggingFilterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get current => $_getSZ(0);
  @$pb.TagNumber(1)
  set current($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrent() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrent() => $_clearField(1);
}

enum EnrichedPathKind_Kind {
  homeDir,
  topLevelDir,
  subDir,
  homeDirFile,
  topLevelDirFile,
  subDirFile,
  notSet
}

class EnrichedPathKind extends $pb.GeneratedMessage {
  factory EnrichedPathKind({
    HomeDir? homeDir,
    TopLevelDir? topLevelDir,
    SubDir? subDir,
    HomeDirFile? homeDirFile,
    TopLevelDirFile? topLevelDirFile,
    SubDirFile? subDirFile,
  }) {
    final result = create();
    if (homeDir != null) result.homeDir = homeDir;
    if (topLevelDir != null) result.topLevelDir = topLevelDir;
    if (subDir != null) result.subDir = subDir;
    if (homeDirFile != null) result.homeDirFile = homeDirFile;
    if (topLevelDirFile != null) result.topLevelDirFile = topLevelDirFile;
    if (subDirFile != null) result.subDirFile = subDirFile;
    return result;
  }

  EnrichedPathKind._();

  factory EnrichedPathKind.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnrichedPathKind.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, EnrichedPathKind_Kind>
      _EnrichedPathKind_KindByTag = {
    1: EnrichedPathKind_Kind.homeDir,
    2: EnrichedPathKind_Kind.topLevelDir,
    3: EnrichedPathKind_Kind.subDir,
    4: EnrichedPathKind_Kind.homeDirFile,
    5: EnrichedPathKind_Kind.topLevelDirFile,
    6: EnrichedPathKind_Kind.subDirFile,
    0: EnrichedPathKind_Kind.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnrichedPathKind',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<HomeDir>(1, _omitFieldNames ? '' : 'homeDir',
        subBuilder: HomeDir.create)
    ..aOM<TopLevelDir>(2, _omitFieldNames ? '' : 'topLevelDir',
        subBuilder: TopLevelDir.create)
    ..aOM<SubDir>(3, _omitFieldNames ? '' : 'subDir', subBuilder: SubDir.create)
    ..aOM<HomeDirFile>(4, _omitFieldNames ? '' : 'homeDirFile',
        subBuilder: HomeDirFile.create)
    ..aOM<TopLevelDirFile>(5, _omitFieldNames ? '' : 'topLevelDirFile',
        subBuilder: TopLevelDirFile.create)
    ..aOM<SubDirFile>(6, _omitFieldNames ? '' : 'subDirFile',
        subBuilder: SubDirFile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnrichedPathKind clone() => EnrichedPathKind()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnrichedPathKind copyWith(void Function(EnrichedPathKind) updates) =>
      super.copyWith((message) => updates(message as EnrichedPathKind))
          as EnrichedPathKind;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnrichedPathKind create() => EnrichedPathKind._();
  @$core.override
  EnrichedPathKind createEmptyInstance() => create();
  static $pb.PbList<EnrichedPathKind> createRepeated() =>
      $pb.PbList<EnrichedPathKind>();
  @$core.pragma('dart2js:noInline')
  static EnrichedPathKind getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnrichedPathKind>(create);
  static EnrichedPathKind? _defaultInstance;

  EnrichedPathKind_Kind whichKind() =>
      _EnrichedPathKind_KindByTag[$_whichOneof(0)]!;
  void clearKind() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  HomeDir get homeDir => $_getN(0);
  @$pb.TagNumber(1)
  set homeDir(HomeDir value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHomeDir() => $_has(0);
  @$pb.TagNumber(1)
  void clearHomeDir() => $_clearField(1);
  @$pb.TagNumber(1)
  HomeDir ensureHomeDir() => $_ensure(0);

  @$pb.TagNumber(2)
  TopLevelDir get topLevelDir => $_getN(1);
  @$pb.TagNumber(2)
  set topLevelDir(TopLevelDir value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTopLevelDir() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopLevelDir() => $_clearField(2);
  @$pb.TagNumber(2)
  TopLevelDir ensureTopLevelDir() => $_ensure(1);

  @$pb.TagNumber(3)
  SubDir get subDir => $_getN(2);
  @$pb.TagNumber(3)
  set subDir(SubDir value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSubDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubDir() => $_clearField(3);
  @$pb.TagNumber(3)
  SubDir ensureSubDir() => $_ensure(2);

  @$pb.TagNumber(4)
  HomeDirFile get homeDirFile => $_getN(3);
  @$pb.TagNumber(4)
  set homeDirFile(HomeDirFile value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasHomeDirFile() => $_has(3);
  @$pb.TagNumber(4)
  void clearHomeDirFile() => $_clearField(4);
  @$pb.TagNumber(4)
  HomeDirFile ensureHomeDirFile() => $_ensure(3);

  @$pb.TagNumber(5)
  TopLevelDirFile get topLevelDirFile => $_getN(4);
  @$pb.TagNumber(5)
  set topLevelDirFile(TopLevelDirFile value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTopLevelDirFile() => $_has(4);
  @$pb.TagNumber(5)
  void clearTopLevelDirFile() => $_clearField(5);
  @$pb.TagNumber(5)
  TopLevelDirFile ensureTopLevelDirFile() => $_ensure(4);

  @$pb.TagNumber(6)
  SubDirFile get subDirFile => $_getN(5);
  @$pb.TagNumber(6)
  set subDirFile(SubDirFile value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSubDirFile() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubDirFile() => $_clearField(6);
  @$pb.TagNumber(6)
  SubDirFile ensureSubDirFile() => $_ensure(5);
}

class HomeDir extends $pb.GeneratedMessage {
  factory HomeDir() => create();

  HomeDir._();

  factory HomeDir.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HomeDir.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HomeDir',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomeDir clone() => HomeDir()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomeDir copyWith(void Function(HomeDir) updates) =>
      super.copyWith((message) => updates(message as HomeDir)) as HomeDir;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HomeDir create() => HomeDir._();
  @$core.override
  HomeDir createEmptyInstance() => create();
  static $pb.PbList<HomeDir> createRepeated() => $pb.PbList<HomeDir>();
  @$core.pragma('dart2js:noInline')
  static HomeDir getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HomeDir>(create);
  static HomeDir? _defaultInstance;
}

class TopLevelDir extends $pb.GeneratedMessage {
  factory TopLevelDir({
    $core.String? dirname,
  }) {
    final result = create();
    if (dirname != null) result.dirname = dirname;
    return result;
  }

  TopLevelDir._();

  factory TopLevelDir.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TopLevelDir.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TopLevelDir',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'dirname')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopLevelDir clone() => TopLevelDir()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopLevelDir copyWith(void Function(TopLevelDir) updates) =>
      super.copyWith((message) => updates(message as TopLevelDir))
          as TopLevelDir;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TopLevelDir create() => TopLevelDir._();
  @$core.override
  TopLevelDir createEmptyInstance() => create();
  static $pb.PbList<TopLevelDir> createRepeated() => $pb.PbList<TopLevelDir>();
  @$core.pragma('dart2js:noInline')
  static TopLevelDir getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TopLevelDir>(create);
  static TopLevelDir? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get dirname => $_getSZ(0);
  @$pb.TagNumber(1)
  set dirname($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDirname() => $_has(0);
  @$pb.TagNumber(1)
  void clearDirname() => $_clearField(1);
}

class SubDir extends $pb.GeneratedMessage {
  factory SubDir() => create();

  SubDir._();

  factory SubDir.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubDir.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubDir',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubDir clone() => SubDir()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubDir copyWith(void Function(SubDir) updates) =>
      super.copyWith((message) => updates(message as SubDir)) as SubDir;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubDir create() => SubDir._();
  @$core.override
  SubDir createEmptyInstance() => create();
  static $pb.PbList<SubDir> createRepeated() => $pb.PbList<SubDir>();
  @$core.pragma('dart2js:noInline')
  static SubDir getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubDir>(create);
  static SubDir? _defaultInstance;
}

class HomeDirFile extends $pb.GeneratedMessage {
  factory HomeDirFile({
    $core.String? filename,
  }) {
    final result = create();
    if (filename != null) result.filename = filename;
    return result;
  }

  HomeDirFile._();

  factory HomeDirFile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HomeDirFile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HomeDirFile',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'filename')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomeDirFile clone() => HomeDirFile()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HomeDirFile copyWith(void Function(HomeDirFile) updates) =>
      super.copyWith((message) => updates(message as HomeDirFile))
          as HomeDirFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HomeDirFile create() => HomeDirFile._();
  @$core.override
  HomeDirFile createEmptyInstance() => create();
  static $pb.PbList<HomeDirFile> createRepeated() => $pb.PbList<HomeDirFile>();
  @$core.pragma('dart2js:noInline')
  static HomeDirFile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HomeDirFile>(create);
  static HomeDirFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get filename => $_getSZ(0);
  @$pb.TagNumber(1)
  set filename($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFilename() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilename() => $_clearField(1);
}

class TopLevelDirFile extends $pb.GeneratedMessage {
  factory TopLevelDirFile({
    $core.String? dirname,
    $core.String? filename,
  }) {
    final result = create();
    if (dirname != null) result.dirname = dirname;
    if (filename != null) result.filename = filename;
    return result;
  }

  TopLevelDirFile._();

  factory TopLevelDirFile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TopLevelDirFile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TopLevelDirFile',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'dirname')
    ..aOS(2, _omitFieldNames ? '' : 'filename')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopLevelDirFile clone() => TopLevelDirFile()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopLevelDirFile copyWith(void Function(TopLevelDirFile) updates) =>
      super.copyWith((message) => updates(message as TopLevelDirFile))
          as TopLevelDirFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TopLevelDirFile create() => TopLevelDirFile._();
  @$core.override
  TopLevelDirFile createEmptyInstance() => create();
  static $pb.PbList<TopLevelDirFile> createRepeated() =>
      $pb.PbList<TopLevelDirFile>();
  @$core.pragma('dart2js:noInline')
  static TopLevelDirFile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TopLevelDirFile>(create);
  static TopLevelDirFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get dirname => $_getSZ(0);
  @$pb.TagNumber(1)
  set dirname($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDirname() => $_has(0);
  @$pb.TagNumber(1)
  void clearDirname() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get filename => $_getSZ(1);
  @$pb.TagNumber(2)
  set filename($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFilename() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilename() => $_clearField(2);
}

class SubDirFile extends $pb.GeneratedMessage {
  factory SubDirFile() => create();

  SubDirFile._();

  factory SubDirFile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubDirFile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubDirFile',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubDirFile clone() => SubDirFile()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubDirFile copyWith(void Function(SubDirFile) updates) =>
      super.copyWith((message) => updates(message as SubDirFile)) as SubDirFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubDirFile create() => SubDirFile._();
  @$core.override
  SubDirFile createEmptyInstance() => create();
  static $pb.PbList<SubDirFile> createRepeated() => $pb.PbList<SubDirFile>();
  @$core.pragma('dart2js:noInline')
  static SubDirFile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubDirFile>(create);
  static SubDirFile? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
