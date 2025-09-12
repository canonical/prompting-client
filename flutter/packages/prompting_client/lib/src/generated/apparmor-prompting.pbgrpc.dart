// This is a generated file - do not edit.
//
// Generated from apparmor-prompting.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'apparmor-prompting.pb.dart' as $1;
import 'google/protobuf/wrappers.pb.dart' as $0;

export 'apparmor-prompting.pb.dart';

@$pb.GrpcServiceName('apparmor_prompting.AppArmorPrompting')
class AppArmorPromptingClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AppArmorPromptingClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseStream<$1.GetCurrentPromptResponse> getCurrentPrompt(
    $0.StringValue request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getCurrentPrompt, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$1.PromptReplyResponse> replyToPrompt(
    $1.PromptReply request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$replyToPrompt, request, options: options);
  }

  $grpc.ResponseFuture<$1.ResolveHomePatternTypeResponse>
      resolveHomePatternType(
    $0.StringValue request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resolveHomePatternType, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.SetLoggingFilterResponse> setLoggingFilter(
    $0.StringValue request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setLoggingFilter, request, options: options);
  }

  // method descriptors

  static final _$getCurrentPrompt =
      $grpc.ClientMethod<$0.StringValue, $1.GetCurrentPromptResponse>(
          '/apparmor_prompting.AppArmorPrompting/GetCurrentPrompt',
          ($0.StringValue value) => value.writeToBuffer(),
          $1.GetCurrentPromptResponse.fromBuffer);
  static final _$replyToPrompt =
      $grpc.ClientMethod<$1.PromptReply, $1.PromptReplyResponse>(
          '/apparmor_prompting.AppArmorPrompting/ReplyToPrompt',
          ($1.PromptReply value) => value.writeToBuffer(),
          $1.PromptReplyResponse.fromBuffer);
  static final _$resolveHomePatternType =
      $grpc.ClientMethod<$0.StringValue, $1.ResolveHomePatternTypeResponse>(
          '/apparmor_prompting.AppArmorPrompting/ResolveHomePatternType',
          ($0.StringValue value) => value.writeToBuffer(),
          $1.ResolveHomePatternTypeResponse.fromBuffer);
  static final _$setLoggingFilter =
      $grpc.ClientMethod<$0.StringValue, $1.SetLoggingFilterResponse>(
          '/apparmor_prompting.AppArmorPrompting/SetLoggingFilter',
          ($0.StringValue value) => value.writeToBuffer(),
          $1.SetLoggingFilterResponse.fromBuffer);
}

@$pb.GrpcServiceName('apparmor_prompting.AppArmorPrompting')
abstract class AppArmorPromptingServiceBase extends $grpc.Service {
  $core.String get $name => 'apparmor_prompting.AppArmorPrompting';

  AppArmorPromptingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.StringValue, $1.GetCurrentPromptResponse>(
        'GetCurrentPrompt',
        getCurrentPrompt_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.StringValue.fromBuffer(value),
        ($1.GetCurrentPromptResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.PromptReply, $1.PromptReplyResponse>(
        'ReplyToPrompt',
        replyToPrompt_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.PromptReply.fromBuffer(value),
        ($1.PromptReplyResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.StringValue, $1.ResolveHomePatternTypeResponse>(
            'ResolveHomePatternType',
            resolveHomePatternType_Pre,
            false,
            false,
            ($core.List<$core.int> value) => $0.StringValue.fromBuffer(value),
            ($1.ResolveHomePatternTypeResponse value) =>
                value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StringValue, $1.SetLoggingFilterResponse>(
        'SetLoggingFilter',
        setLoggingFilter_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StringValue.fromBuffer(value),
        ($1.SetLoggingFilterResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$1.GetCurrentPromptResponse> getCurrentPrompt_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.StringValue> $request) async* {
    yield* getCurrentPrompt($call, await $request);
  }

  $async.Stream<$1.GetCurrentPromptResponse> getCurrentPrompt(
      $grpc.ServiceCall call, $0.StringValue request);

  $async.Future<$1.PromptReplyResponse> replyToPrompt_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.PromptReply> $request) async {
    return replyToPrompt($call, await $request);
  }

  $async.Future<$1.PromptReplyResponse> replyToPrompt(
      $grpc.ServiceCall call, $1.PromptReply request);

  $async.Future<$1.ResolveHomePatternTypeResponse> resolveHomePatternType_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.StringValue> $request) async {
    return resolveHomePatternType($call, await $request);
  }

  $async.Future<$1.ResolveHomePatternTypeResponse> resolveHomePatternType(
      $grpc.ServiceCall call, $0.StringValue request);

  $async.Future<$1.SetLoggingFilterResponse> setLoggingFilter_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.StringValue> $request) async {
    return setLoggingFilter($call, await $request);
  }

  $async.Future<$1.SetLoggingFilterResponse> setLoggingFilter(
      $grpc.ServiceCall call, $0.StringValue request);
}
