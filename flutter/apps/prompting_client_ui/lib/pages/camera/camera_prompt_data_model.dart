import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/app/prompt_model.dart';
import 'package:prompting_client_ui/pages/camera/camera_prompt_error.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ubuntu_service/ubuntu_service.dart';

part 'camera_prompt_data_model.freezed.dart';
part 'camera_prompt_data_model.g.dart';

@freezed
class CameraPromptData with _$CameraPromptData {
  factory CameraPromptData({
    required PromptDetailsCamera details,
    @Default(Lifespan.forever) Lifespan lifespan,
    CameraPromptError? error,
  }) = _CameraPromptData;

  CameraPromptData._();
}

@riverpod
class CameraPromptDataModel extends _$CameraPromptDataModel {
  @override
  CameraPromptData build() {
    final details = ref.watch(currentPromptProvider) as PromptDetailsCamera;
    return CameraPromptData(
      details: details,
    );
  }

  PromptReply buildReply({required Action action, Lifespan? lifespan}) {
    return PromptReply.camera(
      promptId: state.details.metaData.promptId,
      action: action,
      lifespan: lifespan ?? state.lifespan,
      permissions: {CameraPermission.access},
    );
  }

  void setLifespan(Lifespan? lifespan) {
    if (lifespan == null || lifespan == state.lifespan) return;
    state = state.copyWith(lifespan: lifespan);
  }

  Future<PromptReplyResponse> saveAndContinue({
    required Action action,
    Lifespan? lifespan,
  }) async {
    final response = await getService<PromptingClient>()
        .replyToPrompt(buildReply(action: action, lifespan: lifespan));

    final error = switch (response) {
      PromptReplyResponseUnknown(message: final message) =>
        CameraPromptErrorUnknown(message),
      _ => null,
    };
    if (error != null) {
      state = state.copyWith(error: error);
    }
    return response;
  }
}
