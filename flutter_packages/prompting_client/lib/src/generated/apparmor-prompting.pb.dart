//
//  Generated code. Do not modify.
//  source: apparmor-prompting.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'apparmor-prompting.pbenum.dart';
import 'google/protobuf/empty.pb.dart' as $0;

export 'apparmor-prompting.pbenum.dart';

enum PromptReply_PromptReply {
  homePromptReply, 
  notSet
}

class PromptReply extends $pb.GeneratedMessage {
  factory PromptReply({
    $core.String? promptId,
    Action? action,
    Lifespan? lifespan,
    HomePromptReply? homePromptReply,
  }) {
    final $result = create();
    if (promptId != null) {
      $result.promptId = promptId;
    }
    if (action != null) {
      $result.action = action;
    }
    if (lifespan != null) {
      $result.lifespan = lifespan;
    }
    if (homePromptReply != null) {
      $result.homePromptReply = homePromptReply;
    }
    return $result;
  }
  PromptReply._() : super();
  factory PromptReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PromptReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, PromptReply_PromptReply> _PromptReply_PromptReplyByTag = {
    4 : PromptReply_PromptReply.homePromptReply,
    0 : PromptReply_PromptReply.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PromptReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..oo(0, [4])
    ..aOS(1, _omitFieldNames ? '' : 'promptId')
    ..e<Action>(2, _omitFieldNames ? '' : 'action', $pb.PbFieldType.OE, defaultOrMaker: Action.ALLOW, valueOf: Action.valueOf, enumValues: Action.values)
    ..e<Lifespan>(3, _omitFieldNames ? '' : 'lifespan', $pb.PbFieldType.OE, defaultOrMaker: Lifespan.SINGLE, valueOf: Lifespan.valueOf, enumValues: Lifespan.values)
    ..aOM<HomePromptReply>(4, _omitFieldNames ? '' : 'homePromptReply', subBuilder: HomePromptReply.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PromptReply clone() => PromptReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PromptReply copyWith(void Function(PromptReply) updates) => super.copyWith((message) => updates(message as PromptReply)) as PromptReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReply create() => PromptReply._();
  PromptReply createEmptyInstance() => create();
  static $pb.PbList<PromptReply> createRepeated() => $pb.PbList<PromptReply>();
  @$core.pragma('dart2js:noInline')
  static PromptReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptReply>(create);
  static PromptReply? _defaultInstance;

  PromptReply_PromptReply whichPromptReply() => _PromptReply_PromptReplyByTag[$_whichOneof(0)]!;
  void clearPromptReply() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get promptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set promptId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPromptId() => clearField(1);

  @$pb.TagNumber(2)
  Action get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(Action v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => clearField(2);

  @$pb.TagNumber(3)
  Lifespan get lifespan => $_getN(2);
  @$pb.TagNumber(3)
  set lifespan(Lifespan v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLifespan() => $_has(2);
  @$pb.TagNumber(3)
  void clearLifespan() => clearField(3);

  @$pb.TagNumber(4)
  HomePromptReply get homePromptReply => $_getN(3);
  @$pb.TagNumber(4)
  set homePromptReply(HomePromptReply v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasHomePromptReply() => $_has(3);
  @$pb.TagNumber(4)
  void clearHomePromptReply() => clearField(4);
  @$pb.TagNumber(4)
  HomePromptReply ensureHomePromptReply() => $_ensure(3);
}

class PromptReplyResponse_HomeRuleConflicts extends $pb.GeneratedMessage {
  factory PromptReplyResponse_HomeRuleConflicts({
    $core.Iterable<PromptReplyResponse_HomeRuleConflict>? conflicts,
  }) {
    final $result = create();
    if (conflicts != null) {
      $result.conflicts.addAll(conflicts);
    }
    return $result;
  }
  PromptReplyResponse_HomeRuleConflicts._() : super();
  factory PromptReplyResponse_HomeRuleConflicts.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PromptReplyResponse_HomeRuleConflicts.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PromptReplyResponse.HomeRuleConflicts', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..pc<PromptReplyResponse_HomeRuleConflict>(1, _omitFieldNames ? '' : 'conflicts', $pb.PbFieldType.PM, subBuilder: PromptReplyResponse_HomeRuleConflict.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_HomeRuleConflicts clone() => PromptReplyResponse_HomeRuleConflicts()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_HomeRuleConflicts copyWith(void Function(PromptReplyResponse_HomeRuleConflicts) updates) => super.copyWith((message) => updates(message as PromptReplyResponse_HomeRuleConflicts)) as PromptReplyResponse_HomeRuleConflicts;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_HomeRuleConflicts create() => PromptReplyResponse_HomeRuleConflicts._();
  PromptReplyResponse_HomeRuleConflicts createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_HomeRuleConflicts> createRepeated() => $pb.PbList<PromptReplyResponse_HomeRuleConflicts>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_HomeRuleConflicts getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse_HomeRuleConflicts>(create);
  static PromptReplyResponse_HomeRuleConflicts? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<PromptReplyResponse_HomeRuleConflict> get conflicts => $_getList(0);
}

class PromptReplyResponse_HomeRuleConflict extends $pb.GeneratedMessage {
  factory PromptReplyResponse_HomeRuleConflict({
    HomePermission? permission,
    $core.String? variant,
    $core.String? conflictingId,
  }) {
    final $result = create();
    if (permission != null) {
      $result.permission = permission;
    }
    if (variant != null) {
      $result.variant = variant;
    }
    if (conflictingId != null) {
      $result.conflictingId = conflictingId;
    }
    return $result;
  }
  PromptReplyResponse_HomeRuleConflict._() : super();
  factory PromptReplyResponse_HomeRuleConflict.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PromptReplyResponse_HomeRuleConflict.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PromptReplyResponse.HomeRuleConflict', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..e<HomePermission>(1, _omitFieldNames ? '' : 'permission', $pb.PbFieldType.OE, defaultOrMaker: HomePermission.READ, valueOf: HomePermission.valueOf, enumValues: HomePermission.values)
    ..aOS(2, _omitFieldNames ? '' : 'variant')
    ..aOS(3, _omitFieldNames ? '' : 'conflictingId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_HomeRuleConflict clone() => PromptReplyResponse_HomeRuleConflict()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_HomeRuleConflict copyWith(void Function(PromptReplyResponse_HomeRuleConflict) updates) => super.copyWith((message) => updates(message as PromptReplyResponse_HomeRuleConflict)) as PromptReplyResponse_HomeRuleConflict;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_HomeRuleConflict create() => PromptReplyResponse_HomeRuleConflict._();
  PromptReplyResponse_HomeRuleConflict createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_HomeRuleConflict> createRepeated() => $pb.PbList<PromptReplyResponse_HomeRuleConflict>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_HomeRuleConflict getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse_HomeRuleConflict>(create);
  static PromptReplyResponse_HomeRuleConflict? _defaultInstance;

  @$pb.TagNumber(1)
  HomePermission get permission => $_getN(0);
  @$pb.TagNumber(1)
  set permission(HomePermission v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPermission() => $_has(0);
  @$pb.TagNumber(1)
  void clearPermission() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get variant => $_getSZ(1);
  @$pb.TagNumber(2)
  set variant($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVariant() => $_has(1);
  @$pb.TagNumber(2)
  void clearVariant() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get conflictingId => $_getSZ(2);
  @$pb.TagNumber(3)
  set conflictingId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConflictingId() => $_has(2);
  @$pb.TagNumber(3)
  void clearConflictingId() => clearField(3);
}

class PromptReplyResponse_InvalidHomePermissions extends $pb.GeneratedMessage {
  factory PromptReplyResponse_InvalidHomePermissions({
    $core.Iterable<HomePermission>? requested,
    $core.Iterable<HomePermission>? replied,
  }) {
    final $result = create();
    if (requested != null) {
      $result.requested.addAll(requested);
    }
    if (replied != null) {
      $result.replied.addAll(replied);
    }
    return $result;
  }
  PromptReplyResponse_InvalidHomePermissions._() : super();
  factory PromptReplyResponse_InvalidHomePermissions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PromptReplyResponse_InvalidHomePermissions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PromptReplyResponse.InvalidHomePermissions', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..pc<HomePermission>(1, _omitFieldNames ? '' : 'requested', $pb.PbFieldType.KE, valueOf: HomePermission.valueOf, enumValues: HomePermission.values, defaultEnumValue: HomePermission.READ)
    ..pc<HomePermission>(2, _omitFieldNames ? '' : 'replied', $pb.PbFieldType.KE, valueOf: HomePermission.valueOf, enumValues: HomePermission.values, defaultEnumValue: HomePermission.READ)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_InvalidHomePermissions clone() => PromptReplyResponse_InvalidHomePermissions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_InvalidHomePermissions copyWith(void Function(PromptReplyResponse_InvalidHomePermissions) updates) => super.copyWith((message) => updates(message as PromptReplyResponse_InvalidHomePermissions)) as PromptReplyResponse_InvalidHomePermissions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_InvalidHomePermissions create() => PromptReplyResponse_InvalidHomePermissions._();
  PromptReplyResponse_InvalidHomePermissions createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_InvalidHomePermissions> createRepeated() => $pb.PbList<PromptReplyResponse_InvalidHomePermissions>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_InvalidHomePermissions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse_InvalidHomePermissions>(create);
  static PromptReplyResponse_InvalidHomePermissions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<HomePermission> get requested => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<HomePermission> get replied => $_getList(1);
}

class PromptReplyResponse_InvalidPathPattern extends $pb.GeneratedMessage {
  factory PromptReplyResponse_InvalidPathPattern({
    $core.String? requested,
    $core.String? replied,
  }) {
    final $result = create();
    if (requested != null) {
      $result.requested = requested;
    }
    if (replied != null) {
      $result.replied = replied;
    }
    return $result;
  }
  PromptReplyResponse_InvalidPathPattern._() : super();
  factory PromptReplyResponse_InvalidPathPattern.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PromptReplyResponse_InvalidPathPattern.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PromptReplyResponse.InvalidPathPattern', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requested')
    ..aOS(2, _omitFieldNames ? '' : 'replied')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_InvalidPathPattern clone() => PromptReplyResponse_InvalidPathPattern()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_InvalidPathPattern copyWith(void Function(PromptReplyResponse_InvalidPathPattern) updates) => super.copyWith((message) => updates(message as PromptReplyResponse_InvalidPathPattern)) as PromptReplyResponse_InvalidPathPattern;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_InvalidPathPattern create() => PromptReplyResponse_InvalidPathPattern._();
  PromptReplyResponse_InvalidPathPattern createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_InvalidPathPattern> createRepeated() => $pb.PbList<PromptReplyResponse_InvalidPathPattern>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_InvalidPathPattern getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse_InvalidPathPattern>(create);
  static PromptReplyResponse_InvalidPathPattern? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requested => $_getSZ(0);
  @$pb.TagNumber(1)
  set requested($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequested() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequested() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get replied => $_getSZ(1);
  @$pb.TagNumber(2)
  set replied($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReplied() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplied() => clearField(2);
}

class PromptReplyResponse_ParseError extends $pb.GeneratedMessage {
  factory PromptReplyResponse_ParseError({
    $core.String? field_1,
    $core.String? value,
  }) {
    final $result = create();
    if (field_1 != null) {
      $result.field_1 = field_1;
    }
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  PromptReplyResponse_ParseError._() : super();
  factory PromptReplyResponse_ParseError.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PromptReplyResponse_ParseError.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PromptReplyResponse.ParseError', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_ParseError clone() => PromptReplyResponse_ParseError()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_ParseError copyWith(void Function(PromptReplyResponse_ParseError) updates) => super.copyWith((message) => updates(message as PromptReplyResponse_ParseError)) as PromptReplyResponse_ParseError;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_ParseError create() => PromptReplyResponse_ParseError._();
  PromptReplyResponse_ParseError createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_ParseError> createRepeated() => $pb.PbList<PromptReplyResponse_ParseError>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_ParseError getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse_ParseError>(create);
  static PromptReplyResponse_ParseError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class PromptReplyResponse_UnsupportedValue extends $pb.GeneratedMessage {
  factory PromptReplyResponse_UnsupportedValue({
    $core.String? field_1,
    $core.Iterable<$core.String>? supported,
    $core.Iterable<$core.String>? provided,
  }) {
    final $result = create();
    if (field_1 != null) {
      $result.field_1 = field_1;
    }
    if (supported != null) {
      $result.supported.addAll(supported);
    }
    if (provided != null) {
      $result.provided.addAll(provided);
    }
    return $result;
  }
  PromptReplyResponse_UnsupportedValue._() : super();
  factory PromptReplyResponse_UnsupportedValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PromptReplyResponse_UnsupportedValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PromptReplyResponse.UnsupportedValue', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..pPS(2, _omitFieldNames ? '' : 'supported')
    ..pPS(3, _omitFieldNames ? '' : 'provided')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_UnsupportedValue clone() => PromptReplyResponse_UnsupportedValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PromptReplyResponse_UnsupportedValue copyWith(void Function(PromptReplyResponse_UnsupportedValue) updates) => super.copyWith((message) => updates(message as PromptReplyResponse_UnsupportedValue)) as PromptReplyResponse_UnsupportedValue;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_UnsupportedValue create() => PromptReplyResponse_UnsupportedValue._();
  PromptReplyResponse_UnsupportedValue createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse_UnsupportedValue> createRepeated() => $pb.PbList<PromptReplyResponse_UnsupportedValue>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse_UnsupportedValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse_UnsupportedValue>(create);
  static PromptReplyResponse_UnsupportedValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get supported => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.String> get provided => $_getList(2);
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
    $0.Empty? success,
    $0.Empty? raw,
    $0.Empty? promptNotFound,
    $0.Empty? ruleNotFound,
    PromptReplyResponse_HomeRuleConflicts? ruleConflicts,
    PromptReplyResponse_InvalidHomePermissions? invalidPermissions,
    PromptReplyResponse_InvalidPathPattern? invalidPathPattern,
    PromptReplyResponse_ParseError? parseError,
    PromptReplyResponse_UnsupportedValue? unsupportedValue,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    if (success != null) {
      $result.success = success;
    }
    if (raw != null) {
      $result.raw = raw;
    }
    if (promptNotFound != null) {
      $result.promptNotFound = promptNotFound;
    }
    if (ruleNotFound != null) {
      $result.ruleNotFound = ruleNotFound;
    }
    if (ruleConflicts != null) {
      $result.ruleConflicts = ruleConflicts;
    }
    if (invalidPermissions != null) {
      $result.invalidPermissions = invalidPermissions;
    }
    if (invalidPathPattern != null) {
      $result.invalidPathPattern = invalidPathPattern;
    }
    if (parseError != null) {
      $result.parseError = parseError;
    }
    if (unsupportedValue != null) {
      $result.unsupportedValue = unsupportedValue;
    }
    return $result;
  }
  PromptReplyResponse._() : super();
  factory PromptReplyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PromptReplyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, PromptReplyResponse_PromptReplyType> _PromptReplyResponse_PromptReplyTypeByTag = {
    2 : PromptReplyResponse_PromptReplyType.success,
    3 : PromptReplyResponse_PromptReplyType.raw,
    4 : PromptReplyResponse_PromptReplyType.promptNotFound,
    5 : PromptReplyResponse_PromptReplyType.ruleNotFound,
    6 : PromptReplyResponse_PromptReplyType.ruleConflicts,
    7 : PromptReplyResponse_PromptReplyType.invalidPermissions,
    8 : PromptReplyResponse_PromptReplyType.invalidPathPattern,
    9 : PromptReplyResponse_PromptReplyType.parseError,
    10 : PromptReplyResponse_PromptReplyType.unsupportedValue,
    0 : PromptReplyResponse_PromptReplyType.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PromptReplyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..aOM<$0.Empty>(2, _omitFieldNames ? '' : 'success', subBuilder: $0.Empty.create)
    ..aOM<$0.Empty>(3, _omitFieldNames ? '' : 'raw', subBuilder: $0.Empty.create)
    ..aOM<$0.Empty>(4, _omitFieldNames ? '' : 'promptNotFound', subBuilder: $0.Empty.create)
    ..aOM<$0.Empty>(5, _omitFieldNames ? '' : 'ruleNotFound', subBuilder: $0.Empty.create)
    ..aOM<PromptReplyResponse_HomeRuleConflicts>(6, _omitFieldNames ? '' : 'ruleConflicts', subBuilder: PromptReplyResponse_HomeRuleConflicts.create)
    ..aOM<PromptReplyResponse_InvalidHomePermissions>(7, _omitFieldNames ? '' : 'invalidPermissions', subBuilder: PromptReplyResponse_InvalidHomePermissions.create)
    ..aOM<PromptReplyResponse_InvalidPathPattern>(8, _omitFieldNames ? '' : 'invalidPathPattern', subBuilder: PromptReplyResponse_InvalidPathPattern.create)
    ..aOM<PromptReplyResponse_ParseError>(9, _omitFieldNames ? '' : 'parseError', subBuilder: PromptReplyResponse_ParseError.create)
    ..aOM<PromptReplyResponse_UnsupportedValue>(10, _omitFieldNames ? '' : 'unsupportedValue', subBuilder: PromptReplyResponse_UnsupportedValue.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PromptReplyResponse clone() => PromptReplyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PromptReplyResponse copyWith(void Function(PromptReplyResponse) updates) => super.copyWith((message) => updates(message as PromptReplyResponse)) as PromptReplyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse create() => PromptReplyResponse._();
  PromptReplyResponse createEmptyInstance() => create();
  static $pb.PbList<PromptReplyResponse> createRepeated() => $pb.PbList<PromptReplyResponse>();
  @$core.pragma('dart2js:noInline')
  static PromptReplyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptReplyResponse>(create);
  static PromptReplyResponse? _defaultInstance;

  PromptReplyResponse_PromptReplyType whichPromptReplyType() => _PromptReplyResponse_PromptReplyTypeByTag[$_whichOneof(0)]!;
  void clearPromptReplyType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  $0.Empty get success => $_getN(1);
  @$pb.TagNumber(2)
  set success($0.Empty v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => clearField(2);
  @$pb.TagNumber(2)
  $0.Empty ensureSuccess() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Empty get raw => $_getN(2);
  @$pb.TagNumber(3)
  set raw($0.Empty v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRaw() => $_has(2);
  @$pb.TagNumber(3)
  void clearRaw() => clearField(3);
  @$pb.TagNumber(3)
  $0.Empty ensureRaw() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Empty get promptNotFound => $_getN(3);
  @$pb.TagNumber(4)
  set promptNotFound($0.Empty v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPromptNotFound() => $_has(3);
  @$pb.TagNumber(4)
  void clearPromptNotFound() => clearField(4);
  @$pb.TagNumber(4)
  $0.Empty ensurePromptNotFound() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Empty get ruleNotFound => $_getN(4);
  @$pb.TagNumber(5)
  set ruleNotFound($0.Empty v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRuleNotFound() => $_has(4);
  @$pb.TagNumber(5)
  void clearRuleNotFound() => clearField(5);
  @$pb.TagNumber(5)
  $0.Empty ensureRuleNotFound() => $_ensure(4);

  @$pb.TagNumber(6)
  PromptReplyResponse_HomeRuleConflicts get ruleConflicts => $_getN(5);
  @$pb.TagNumber(6)
  set ruleConflicts(PromptReplyResponse_HomeRuleConflicts v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasRuleConflicts() => $_has(5);
  @$pb.TagNumber(6)
  void clearRuleConflicts() => clearField(6);
  @$pb.TagNumber(6)
  PromptReplyResponse_HomeRuleConflicts ensureRuleConflicts() => $_ensure(5);

  @$pb.TagNumber(7)
  PromptReplyResponse_InvalidHomePermissions get invalidPermissions => $_getN(6);
  @$pb.TagNumber(7)
  set invalidPermissions(PromptReplyResponse_InvalidHomePermissions v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasInvalidPermissions() => $_has(6);
  @$pb.TagNumber(7)
  void clearInvalidPermissions() => clearField(7);
  @$pb.TagNumber(7)
  PromptReplyResponse_InvalidHomePermissions ensureInvalidPermissions() => $_ensure(6);

  @$pb.TagNumber(8)
  PromptReplyResponse_InvalidPathPattern get invalidPathPattern => $_getN(7);
  @$pb.TagNumber(8)
  set invalidPathPattern(PromptReplyResponse_InvalidPathPattern v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasInvalidPathPattern() => $_has(7);
  @$pb.TagNumber(8)
  void clearInvalidPathPattern() => clearField(8);
  @$pb.TagNumber(8)
  PromptReplyResponse_InvalidPathPattern ensureInvalidPathPattern() => $_ensure(7);

  @$pb.TagNumber(9)
  PromptReplyResponse_ParseError get parseError => $_getN(8);
  @$pb.TagNumber(9)
  set parseError(PromptReplyResponse_ParseError v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasParseError() => $_has(8);
  @$pb.TagNumber(9)
  void clearParseError() => clearField(9);
  @$pb.TagNumber(9)
  PromptReplyResponse_ParseError ensureParseError() => $_ensure(8);

  @$pb.TagNumber(10)
  PromptReplyResponse_UnsupportedValue get unsupportedValue => $_getN(9);
  @$pb.TagNumber(10)
  set unsupportedValue(PromptReplyResponse_UnsupportedValue v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasUnsupportedValue() => $_has(9);
  @$pb.TagNumber(10)
  void clearUnsupportedValue() => clearField(10);
  @$pb.TagNumber(10)
  PromptReplyResponse_UnsupportedValue ensureUnsupportedValue() => $_ensure(9);
}

enum GetCurrentPromptResponse_Prompt {
  homePrompt, 
  notSet
}

class GetCurrentPromptResponse extends $pb.GeneratedMessage {
  factory GetCurrentPromptResponse({
    HomePrompt? homePrompt,
  }) {
    final $result = create();
    if (homePrompt != null) {
      $result.homePrompt = homePrompt;
    }
    return $result;
  }
  GetCurrentPromptResponse._() : super();
  factory GetCurrentPromptResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCurrentPromptResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, GetCurrentPromptResponse_Prompt> _GetCurrentPromptResponse_PromptByTag = {
    1 : GetCurrentPromptResponse_Prompt.homePrompt,
    0 : GetCurrentPromptResponse_Prompt.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetCurrentPromptResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<HomePrompt>(1, _omitFieldNames ? '' : 'homePrompt', subBuilder: HomePrompt.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCurrentPromptResponse clone() => GetCurrentPromptResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCurrentPromptResponse copyWith(void Function(GetCurrentPromptResponse) updates) => super.copyWith((message) => updates(message as GetCurrentPromptResponse)) as GetCurrentPromptResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentPromptResponse create() => GetCurrentPromptResponse._();
  GetCurrentPromptResponse createEmptyInstance() => create();
  static $pb.PbList<GetCurrentPromptResponse> createRepeated() => $pb.PbList<GetCurrentPromptResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentPromptResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCurrentPromptResponse>(create);
  static GetCurrentPromptResponse? _defaultInstance;

  GetCurrentPromptResponse_Prompt whichPrompt() => _GetCurrentPromptResponse_PromptByTag[$_whichOneof(0)]!;
  void clearPrompt() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  HomePrompt get homePrompt => $_getN(0);
  @$pb.TagNumber(1)
  set homePrompt(HomePrompt v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHomePrompt() => $_has(0);
  @$pb.TagNumber(1)
  void clearHomePrompt() => clearField(1);
  @$pb.TagNumber(1)
  HomePrompt ensureHomePrompt() => $_ensure(0);
}

class HomePromptReply extends $pb.GeneratedMessage {
  factory HomePromptReply({
    $core.String? pathPattern,
    $core.Iterable<HomePermission>? permissions,
  }) {
    final $result = create();
    if (pathPattern != null) {
      $result.pathPattern = pathPattern;
    }
    if (permissions != null) {
      $result.permissions.addAll(permissions);
    }
    return $result;
  }
  HomePromptReply._() : super();
  factory HomePromptReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HomePromptReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HomePromptReply', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pathPattern')
    ..pc<HomePermission>(2, _omitFieldNames ? '' : 'permissions', $pb.PbFieldType.KE, valueOf: HomePermission.valueOf, enumValues: HomePermission.values, defaultEnumValue: HomePermission.READ)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HomePromptReply clone() => HomePromptReply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HomePromptReply copyWith(void Function(HomePromptReply) updates) => super.copyWith((message) => updates(message as HomePromptReply)) as HomePromptReply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HomePromptReply create() => HomePromptReply._();
  HomePromptReply createEmptyInstance() => create();
  static $pb.PbList<HomePromptReply> createRepeated() => $pb.PbList<HomePromptReply>();
  @$core.pragma('dart2js:noInline')
  static HomePromptReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HomePromptReply>(create);
  static HomePromptReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pathPattern => $_getSZ(0);
  @$pb.TagNumber(1)
  set pathPattern($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPathPattern() => $_has(0);
  @$pb.TagNumber(1)
  void clearPathPattern() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<HomePermission> get permissions => $_getList(1);
}

class HomePrompt_PatternOption extends $pb.GeneratedMessage {
  factory HomePrompt_PatternOption({
    HomePatternType? homePatternType,
    $core.String? pathPattern,
    $core.bool? showInitially,
  }) {
    final $result = create();
    if (homePatternType != null) {
      $result.homePatternType = homePatternType;
    }
    if (pathPattern != null) {
      $result.pathPattern = pathPattern;
    }
    if (showInitially != null) {
      $result.showInitially = showInitially;
    }
    return $result;
  }
  HomePrompt_PatternOption._() : super();
  factory HomePrompt_PatternOption.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HomePrompt_PatternOption.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HomePrompt.PatternOption', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..e<HomePatternType>(1, _omitFieldNames ? '' : 'homePatternType', $pb.PbFieldType.OE, defaultOrMaker: HomePatternType.REQUESTED_DIRECTORY, valueOf: HomePatternType.valueOf, enumValues: HomePatternType.values)
    ..aOS(2, _omitFieldNames ? '' : 'pathPattern')
    ..aOB(3, _omitFieldNames ? '' : 'showInitially')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HomePrompt_PatternOption clone() => HomePrompt_PatternOption()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HomePrompt_PatternOption copyWith(void Function(HomePrompt_PatternOption) updates) => super.copyWith((message) => updates(message as HomePrompt_PatternOption)) as HomePrompt_PatternOption;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HomePrompt_PatternOption create() => HomePrompt_PatternOption._();
  HomePrompt_PatternOption createEmptyInstance() => create();
  static $pb.PbList<HomePrompt_PatternOption> createRepeated() => $pb.PbList<HomePrompt_PatternOption>();
  @$core.pragma('dart2js:noInline')
  static HomePrompt_PatternOption getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HomePrompt_PatternOption>(create);
  static HomePrompt_PatternOption? _defaultInstance;

  @$pb.TagNumber(1)
  HomePatternType get homePatternType => $_getN(0);
  @$pb.TagNumber(1)
  set homePatternType(HomePatternType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHomePatternType() => $_has(0);
  @$pb.TagNumber(1)
  void clearHomePatternType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pathPattern => $_getSZ(1);
  @$pb.TagNumber(2)
  set pathPattern($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPathPattern() => $_has(1);
  @$pb.TagNumber(2)
  void clearPathPattern() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get showInitially => $_getBF(2);
  @$pb.TagNumber(3)
  set showInitially($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasShowInitially() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowInitially() => clearField(3);
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
  }) {
    final $result = create();
    if (metaData != null) {
      $result.metaData = metaData;
    }
    if (requestedPath != null) {
      $result.requestedPath = requestedPath;
    }
    if (homeDir != null) {
      $result.homeDir = homeDir;
    }
    if (requestedPermissions != null) {
      $result.requestedPermissions.addAll(requestedPermissions);
    }
    if (availablePermissions != null) {
      $result.availablePermissions.addAll(availablePermissions);
    }
    if (suggestedPermissions != null) {
      $result.suggestedPermissions.addAll(suggestedPermissions);
    }
    if (patternOptions != null) {
      $result.patternOptions.addAll(patternOptions);
    }
    if (initialPatternOption != null) {
      $result.initialPatternOption = initialPatternOption;
    }
    return $result;
  }
  HomePrompt._() : super();
  factory HomePrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HomePrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HomePrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..aOM<MetaData>(1, _omitFieldNames ? '' : 'metaData', subBuilder: MetaData.create)
    ..aOS(2, _omitFieldNames ? '' : 'requestedPath')
    ..aOS(3, _omitFieldNames ? '' : 'homeDir')
    ..pc<HomePermission>(4, _omitFieldNames ? '' : 'requestedPermissions', $pb.PbFieldType.KE, valueOf: HomePermission.valueOf, enumValues: HomePermission.values, defaultEnumValue: HomePermission.READ)
    ..pc<HomePermission>(5, _omitFieldNames ? '' : 'availablePermissions', $pb.PbFieldType.KE, valueOf: HomePermission.valueOf, enumValues: HomePermission.values, defaultEnumValue: HomePermission.READ)
    ..pc<HomePermission>(6, _omitFieldNames ? '' : 'suggestedPermissions', $pb.PbFieldType.KE, valueOf: HomePermission.valueOf, enumValues: HomePermission.values, defaultEnumValue: HomePermission.READ)
    ..pc<HomePrompt_PatternOption>(7, _omitFieldNames ? '' : 'patternOptions', $pb.PbFieldType.PM, subBuilder: HomePrompt_PatternOption.create)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'initialPatternOption', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HomePrompt clone() => HomePrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HomePrompt copyWith(void Function(HomePrompt) updates) => super.copyWith((message) => updates(message as HomePrompt)) as HomePrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HomePrompt create() => HomePrompt._();
  HomePrompt createEmptyInstance() => create();
  static $pb.PbList<HomePrompt> createRepeated() => $pb.PbList<HomePrompt>();
  @$core.pragma('dart2js:noInline')
  static HomePrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HomePrompt>(create);
  static HomePrompt? _defaultInstance;

  @$pb.TagNumber(1)
  MetaData get metaData => $_getN(0);
  @$pb.TagNumber(1)
  set metaData(MetaData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMetaData() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetaData() => clearField(1);
  @$pb.TagNumber(1)
  MetaData ensureMetaData() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get requestedPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestedPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRequestedPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestedPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get homeDir => $_getSZ(2);
  @$pb.TagNumber(3)
  set homeDir($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHomeDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearHomeDir() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<HomePermission> get requestedPermissions => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<HomePermission> get availablePermissions => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<HomePermission> get suggestedPermissions => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<HomePrompt_PatternOption> get patternOptions => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get initialPatternOption => $_getIZ(7);
  @$pb.TagNumber(8)
  set initialPatternOption($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasInitialPatternOption() => $_has(7);
  @$pb.TagNumber(8)
  void clearInitialPatternOption() => clearField(8);
}

class MetaData extends $pb.GeneratedMessage {
  factory MetaData({
    $core.String? promptId,
    $core.String? snapName,
    $core.String? storeUrl,
    $core.String? publisher,
    $core.String? updatedAt,
  }) {
    final $result = create();
    if (promptId != null) {
      $result.promptId = promptId;
    }
    if (snapName != null) {
      $result.snapName = snapName;
    }
    if (storeUrl != null) {
      $result.storeUrl = storeUrl;
    }
    if (publisher != null) {
      $result.publisher = publisher;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    return $result;
  }
  MetaData._() : super();
  factory MetaData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MetaData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MetaData', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'promptId')
    ..aOS(2, _omitFieldNames ? '' : 'snapName')
    ..aOS(3, _omitFieldNames ? '' : 'storeUrl')
    ..aOS(4, _omitFieldNames ? '' : 'publisher')
    ..aOS(5, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MetaData clone() => MetaData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MetaData copyWith(void Function(MetaData) updates) => super.copyWith((message) => updates(message as MetaData)) as MetaData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetaData create() => MetaData._();
  MetaData createEmptyInstance() => create();
  static $pb.PbList<MetaData> createRepeated() => $pb.PbList<MetaData>();
  @$core.pragma('dart2js:noInline')
  static MetaData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MetaData>(create);
  static MetaData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get promptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set promptId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPromptId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get snapName => $_getSZ(1);
  @$pb.TagNumber(2)
  set snapName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSnapName() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get storeUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set storeUrl($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStoreUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearStoreUrl() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get publisher => $_getSZ(3);
  @$pb.TagNumber(4)
  set publisher($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPublisher() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublisher() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get updatedAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set updatedAt($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUpdatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedAt() => clearField(5);
}

class ResolveHomePatternTypeResponse extends $pb.GeneratedMessage {
  factory ResolveHomePatternTypeResponse({
    HomePatternType? homePatternType,
  }) {
    final $result = create();
    if (homePatternType != null) {
      $result.homePatternType = homePatternType;
    }
    return $result;
  }
  ResolveHomePatternTypeResponse._() : super();
  factory ResolveHomePatternTypeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResolveHomePatternTypeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResolveHomePatternTypeResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..e<HomePatternType>(1, _omitFieldNames ? '' : 'homePatternType', $pb.PbFieldType.OE, defaultOrMaker: HomePatternType.REQUESTED_DIRECTORY, valueOf: HomePatternType.valueOf, enumValues: HomePatternType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResolveHomePatternTypeResponse clone() => ResolveHomePatternTypeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResolveHomePatternTypeResponse copyWith(void Function(ResolveHomePatternTypeResponse) updates) => super.copyWith((message) => updates(message as ResolveHomePatternTypeResponse)) as ResolveHomePatternTypeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveHomePatternTypeResponse create() => ResolveHomePatternTypeResponse._();
  ResolveHomePatternTypeResponse createEmptyInstance() => create();
  static $pb.PbList<ResolveHomePatternTypeResponse> createRepeated() => $pb.PbList<ResolveHomePatternTypeResponse>();
  @$core.pragma('dart2js:noInline')
  static ResolveHomePatternTypeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResolveHomePatternTypeResponse>(create);
  static ResolveHomePatternTypeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  HomePatternType get homePatternType => $_getN(0);
  @$pb.TagNumber(1)
  set homePatternType(HomePatternType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHomePatternType() => $_has(0);
  @$pb.TagNumber(1)
  void clearHomePatternType() => clearField(1);
}

class SetLoggingFilterResponse extends $pb.GeneratedMessage {
  factory SetLoggingFilterResponse({
    $core.String? current,
  }) {
    final $result = create();
    if (current != null) {
      $result.current = current;
    }
    return $result;
  }
  SetLoggingFilterResponse._() : super();
  factory SetLoggingFilterResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetLoggingFilterResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SetLoggingFilterResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'apparmor_prompting'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'current')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SetLoggingFilterResponse clone() => SetLoggingFilterResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SetLoggingFilterResponse copyWith(void Function(SetLoggingFilterResponse) updates) => super.copyWith((message) => updates(message as SetLoggingFilterResponse)) as SetLoggingFilterResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetLoggingFilterResponse create() => SetLoggingFilterResponse._();
  SetLoggingFilterResponse createEmptyInstance() => create();
  static $pb.PbList<SetLoggingFilterResponse> createRepeated() => $pb.PbList<SetLoggingFilterResponse>();
  @$core.pragma('dart2js:noInline')
  static SetLoggingFilterResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetLoggingFilterResponse>(create);
  static SetLoggingFilterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get current => $_getSZ(0);
  @$pb.TagNumber(1)
  set current($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrent() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrent() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
