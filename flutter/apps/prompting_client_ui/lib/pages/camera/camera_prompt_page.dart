import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/camera/camera_prompt_data_model.dart';
import 'package:prompting_client_ui/pages/camera/camera_prompt_error.dart';
import 'package:prompting_client_ui/widgets/device_action_buttons.dart';
import 'package:prompting_client_ui/widgets/iterable_extensions.dart';
import 'package:yaru/yaru.dart';

class CameraPromptPage extends ConsumerWidget {
  const CameraPromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error =
        ref.watch(cameraPromptDataModelProvider.select((m) => m.error));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CameraHeader(),
        if (error != null) CameraErrorBox(error),
        CameraActionButtons(),
      ].withSpacing(20),
    );
  }
}

class CameraErrorBox extends ConsumerWidget {
  const CameraErrorBox(this.error, {super.key});

  final CameraPromptError error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return YaruInfoBox(
      yaruInfoType: YaruInfoType.danger,
      title: Text(error.title(l10n)),
      child: Text(error.body(l10n)),
    );
  }
}

class CameraHeader extends ConsumerWidget {
  const CameraHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(
      cameraPromptDataModelProvider.select((m) => m.details),
    );

    final l10n = AppLocalizations.of(context);

    final text = l10n.cameraPromptBody(details.metaData.snapName);
    return Text(text);
  }
}

class CameraActionButtons extends ConsumerWidget {
  const CameraActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DeviceActionButtons(
      onAction: ({required action, required lifespan}) => ref
          .read(cameraPromptDataModelProvider.notifier)
          .saveAndContinue(action: action, lifespan: lifespan),
    );
  }
}
