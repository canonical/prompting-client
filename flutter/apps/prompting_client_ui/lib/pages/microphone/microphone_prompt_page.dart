import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/microphone/microphone_prompt_data_model.dart';
import 'package:prompting_client_ui/pages/microphone/microphone_prompt_error.dart';
import 'package:prompting_client_ui/widgets/device_action_buttons.dart';
import 'package:prompting_client_ui/widgets/iterable_extensions.dart';
import 'package:prompting_client_ui/widgets/snap_icon.dart';
import 'package:yaru/yaru.dart';

class MicrophonePromptPage extends ConsumerWidget {
  const MicrophonePromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error =
        ref.watch(microphonePromptDataModelProvider.select((m) => m.error));
    final snapIcon = ref.watch(
      microphonePromptDataModelProvider.select((m) => m.details.metaData.snapIcon),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (snapIcon != null)
          Center(
            child: SnapIcon(snapIcon: snapIcon),
          ),
        const MicrophoneHeader(),
        if (error != null) MicrophoneErrorBox(error),
        MicrophoneActionButtons(),
      ].withSpacing(20),
    );
  }
}

class MicrophoneErrorBox extends ConsumerWidget {
  const MicrophoneErrorBox(this.error, {super.key});

  final MicrophonePromptError error;

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

class MicrophoneHeader extends ConsumerWidget {
  const MicrophoneHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(
      microphonePromptDataModelProvider.select((m) => m.details),
    );

    final l10n = AppLocalizations.of(context);

    final text = l10n.microphonePromptBody(details.metaData.snapName);
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class MicrophoneActionButtons extends ConsumerWidget {
  const MicrophoneActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DeviceActionButtons(
      onAction: ({required action, required lifespan}) => ref
          .read(microphonePromptDataModelProvider.notifier)
          .saveAndContinue(action: action, lifespan: lifespan),
    );
  }
}
