import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/prompt_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ubuntu_service/ubuntu_service.dart';

part 'home_prompt_data_model.freezed.dart';
part 'home_prompt_data_model.g.dart';

@freezed
class HomePromptData with _$HomePromptData {
  factory HomePromptData({
    required PromptDetailsHome details,
    required bool withMoreOptions,
    required List<Permission> permissions,
    required String customPath,
    @Default(0) int? selectedPath,
    @Default(Action.allow) Action? action,
    @Default(Lifespan.forever) Lifespan? lifespan,
    String? errorMessage,
  }) = _HomePromptData;

  HomePromptData._();

  String get pathPattern {
    if (selectedPath! == numPatternOptions) {
      return customPath;
    } else {
      return details.patternOptions[selectedPath!].pathPattern;
    }
  }

  int get numPatternOptions => details.patternOptions.length;

  (HomePatternType, String) moreOptionPath(int index) {
    final opt = details.patternOptions[index];
    return (opt.homePatternType, opt.pathPattern);
  }

  bool get isValid =>
      selectedPath != null && action != null && lifespan != null;
}

@riverpod
class HomePromptDataModel extends _$HomePromptDataModel {
  @override
  HomePromptData build() {
    final details = ref.watch(currentPromptProvider) as PromptDetailsHome;
    return HomePromptData(
      details: details,
      // forcing for now while we are iterating on what options we provide
      withMoreOptions: true,
      permissions: details.requestedPermissions,
      customPath: details.requestedPath,
    );
  }

  PromptReply buildReply() {
    return PromptReply.home(
      promptId: state.details.metaData.promptId,
      action: state.action!,
      lifespan: state.lifespan!,
      pathPattern: state.pathPattern,
      permissions: state.permissions,
    );
  }

  void toggleMoreOptions() =>
      state = state.copyWith(withMoreOptions: !state.withMoreOptions);

  void setSelectedPath(int? i) => state = state.copyWith(selectedPath: i);

  void setCustomPath(String path) =>
      state = state.copyWith(customPath: path, errorMessage: null);

  void setAction(Action? a) => state = state.copyWith(action: a);

  void setLifespan(Lifespan? l) => state = state.copyWith(lifespan: l);

  void togglePerm(Permission p) {
    if (!state.details.availablePermissions.contains(p)) {
      throw ArgumentError('$p is not an available permission');
    }

    final permissions = [...state.permissions];

    if (permissions.contains(p)) {
      permissions.remove(p);
    } else {
      permissions.add(p);
    }

    state = state.copyWith(permissions: permissions);
  }

  Future<PromptReplyResponse> saveAndContinue() async {
    final response =
        await getService<PromptingClient>().replyToPrompt(buildReply());
    if (response is PromptReplyResponseUnknown) {
      state = state.copyWith(errorMessage: response.message);
    }
    return response;
  }
}
