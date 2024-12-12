import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/app/prompt_model.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_error.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ubuntu_service/ubuntu_service.dart';

part 'home_prompt_data_model.freezed.dart';
part 'home_prompt_data_model.g.dart';

@freezed
class HomePromptData with _$HomePromptData {
  factory HomePromptData({
    required PromptDetailsHome details,
    required Set<HomePermission> permissions,
    required String customPath,
    required PatternOption patternOption,
    required EnrichedPathKind enrichedPathKind,
    @Default(Lifespan.forever) Lifespan lifespan,
    HomePromptError? error,
    @Default(false) bool showMoreOptions,
  }) = _HomePromptData;

  HomePromptData._();

  String get pathPattern => switch (patternOption.homePatternType) {
        HomePatternType.customPath => customPath,
        _ => patternOption.pathPattern,
      };

  bool get isValid => permissions.isNotEmpty;

  bool get hasMeta =>
      (details.metaData.publisher?.isNotEmpty ?? false) &&
      (details.metaData.storeUrl?.isNotEmpty ?? false) &&
      details.metaData.updatedAt != null;

  Iterable<PatternOption> get visiblePatternOptions => showMoreOptions
      ? details.patternOptions
      : details.patternOptions.where((option) => option.showInitially);
}

@riverpod
class HomePromptDataModel extends _$HomePromptDataModel {
  @override
  HomePromptData build() {
    final details = ref.watch(currentPromptProvider) as PromptDetailsHome;
    return HomePromptData(
      details: details,
      patternOption: details.patternOptions.isEmpty
          ? PatternOption(
              homePatternType: HomePatternType.customPath,
              pathPattern: '',
            )
          : details.patternOptions.toList()[details.initialPatternOption
              .clamp(0, details.patternOptions.length - 1)],
      permissions: details.requestedPermissions,
      customPath: details.requestedPath,
      enrichedPathKind: details.enrichedPathKind,
    );
  }

  PromptReply buildReply({required Action action, Lifespan? lifespan}) {
    return PromptReply.home(
      promptId: state.details.metaData.promptId,
      action: action,
      lifespan: lifespan ?? state.lifespan,
      pathPattern: state.pathPattern,
      permissions: state.permissions,
    );
  }

  void setPatternOption(PatternOption? patternOption) {
    if (patternOption == null || patternOption == state.patternOption) return;
    state = state.copyWith(patternOption: patternOption);
  }

  void setCustomPath(String path) => state = state.copyWith(customPath: path);

  void setLifespan(Lifespan? lifespan) {
    if (lifespan == null || lifespan == state.lifespan) return;
    state = state.copyWith(lifespan: lifespan);
  }

  void togglePermission(HomePermission permission) {
    if (!state.details.availablePermissions.contains(permission)) {
      throw ArgumentError('$permission is not an available permission');
    }

    final permissions = state.permissions.toSet();

    if (permissions.contains(permission)) {
      permissions.remove(permission);
    } else {
      permissions.add(permission);
    }

    state = state.copyWith(permissions: permissions);
  }

  void toggleMoreOptions() {
    if (state.showMoreOptions) {
      state = state.copyWith(
        showMoreOptions: false,
        // Remove permissions that were not initially suggested when hiding more options
        permissions: state.details.requestedPermissions.union(
          state.permissions.intersection(state.details.suggestedPermissions),
        ),
      );
    } else {
      state = state.copyWith(showMoreOptions: true);
    }
  }

  Future<PromptReplyResponse> saveAndContinue({
    required Action action,
    Lifespan? lifespan,
  }) async {
    final response = await getService<PromptingClient>()
        .replyToPrompt(buildReply(action: action, lifespan: lifespan));

    final error = switch (response) {
      PromptReplyResponseUnknown(message: final message) =>
        HomePromptErrorUnknown(message),
      _ => null,
    };
    if (error != null) {
      state = state.copyWith(error: error);
    }
    return response;
  }
}
