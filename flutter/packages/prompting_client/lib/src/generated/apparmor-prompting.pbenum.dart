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

class Action extends $pb.ProtobufEnum {
  static const Action ALLOW = Action._(0, _omitEnumNames ? '' : 'ALLOW');
  static const Action DENY = Action._(1, _omitEnumNames ? '' : 'DENY');

  static const $core.List<Action> values = <Action>[
    ALLOW,
    DENY,
  ];

  static final $core.List<Action?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static Action? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Action._(super.value, super.name);
}

class Lifespan extends $pb.ProtobufEnum {
  static const Lifespan SINGLE = Lifespan._(0, _omitEnumNames ? '' : 'SINGLE');
  static const Lifespan SESSION =
      Lifespan._(1, _omitEnumNames ? '' : 'SESSION');
  static const Lifespan FOREVER =
      Lifespan._(2, _omitEnumNames ? '' : 'FOREVER');

  static const $core.List<Lifespan> values = <Lifespan>[
    SINGLE,
    SESSION,
    FOREVER,
  ];

  static final $core.List<Lifespan?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Lifespan? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Lifespan._(super.value, super.name);
}

class HomePermission extends $pb.ProtobufEnum {
  static const HomePermission READ =
      HomePermission._(0, _omitEnumNames ? '' : 'READ');
  static const HomePermission WRITE =
      HomePermission._(1, _omitEnumNames ? '' : 'WRITE');
  static const HomePermission EXECUTE =
      HomePermission._(2, _omitEnumNames ? '' : 'EXECUTE');

  static const $core.List<HomePermission> values = <HomePermission>[
    READ,
    WRITE,
    EXECUTE,
  ];

  static final $core.List<HomePermission?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static HomePermission? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HomePermission._(super.value, super.name);
}

class DevicePermission extends $pb.ProtobufEnum {
  static const DevicePermission ACCESS =
      DevicePermission._(0, _omitEnumNames ? '' : 'ACCESS');

  static const $core.List<DevicePermission> values = <DevicePermission>[
    ACCESS,
  ];

  static final $core.List<DevicePermission?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 0);
  static DevicePermission? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DevicePermission._(super.value, super.name);
}

class HomePatternType extends $pb.ProtobufEnum {
  static const HomePatternType REQUESTED_DIRECTORY =
      HomePatternType._(0, _omitEnumNames ? '' : 'REQUESTED_DIRECTORY');
  static const HomePatternType REQUESTED_FILE =
      HomePatternType._(1, _omitEnumNames ? '' : 'REQUESTED_FILE');
  static const HomePatternType TOP_LEVEL_DIRECTORY =
      HomePatternType._(2, _omitEnumNames ? '' : 'TOP_LEVEL_DIRECTORY');
  static const HomePatternType CONTAINING_DIRECTORY =
      HomePatternType._(3, _omitEnumNames ? '' : 'CONTAINING_DIRECTORY');
  static const HomePatternType HOME_DIRECTORY =
      HomePatternType._(4, _omitEnumNames ? '' : 'HOME_DIRECTORY');
  static const HomePatternType MATCHING_FILE_EXTENSION =
      HomePatternType._(5, _omitEnumNames ? '' : 'MATCHING_FILE_EXTENSION');
  static const HomePatternType REQUESTED_DIRECTORY_CONTENTS = HomePatternType._(
      6, _omitEnumNames ? '' : 'REQUESTED_DIRECTORY_CONTENTS');

  static const $core.List<HomePatternType> values = <HomePatternType>[
    REQUESTED_DIRECTORY,
    REQUESTED_FILE,
    TOP_LEVEL_DIRECTORY,
    CONTAINING_DIRECTORY,
    HOME_DIRECTORY,
    MATCHING_FILE_EXTENSION,
    REQUESTED_DIRECTORY_CONTENTS,
  ];

  static final $core.List<HomePatternType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static HomePatternType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HomePatternType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
