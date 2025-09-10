import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/camera/camera_prompt_data_model.dart';
import 'package:prompting_client_ui/pages/camera/camera_prompt_error.dart';
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
        const CameraActionButtons(),
      ].withSpacing(20),
    );
  }
}

class CameraErrorBox extends ConsumerWidget {
  const CameraErrorBox(this.error, {super.key});

  final CameraPromptError error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return YaruInfoBox(
      yaruInfoType: YaruInfoType.danger,
      title: Text(error.title()),
      child: Text(error.body()),
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
    const buttons = [
      CameraActionButton(action: Action.allow, lifespan: Lifespan.forever),
      CameraActionButton(action: Action.allow, lifespan: Lifespan.session),
      CameraActionButton(action: Action.deny, lifespan: Lifespan.single),
    ];
    return Wrap(runSpacing: 16, spacing: 16, children: buttons);
  }
}

class CameraActionButton extends ConsumerWidget {
  const CameraActionButton({required this.action, this.lifespan, super.key});

  final Action action;
  final Lifespan? lifespan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return OutlinedButton(
      onPressed: () async {
              final response = await ref
                  .read(cameraPromptDataModelProvider.notifier)
                  .saveAndContinue(action: action, lifespan: lifespan);
              if (response is PromptReplyResponseSuccess) {
                if (context.mounted) {
                  await YaruWindow.of(context).close();
                }
              } else if (response is PromptReplyResponsePromptNotFound) {
                if (context.mounted) {
                  await YaruWindow.of(context).close();
                }
              }
            },
      child: Text(
        switch ((action, lifespan)) {
          (Action.allow, Lifespan.forever) => l10n.promptActionOptionAllowAlways,
          (Action.allow, Lifespan.session) => l10n.promptActionOptionAllowUntilLogout,
          (Action.deny, Lifespan.single) => l10n.promptActionOptionDenyOnce,
          _ => action == Action.allow 
            ? l10n.promptActionOptionAllow 
            : l10n.promptActionOptionDeny,
        },
      ),
    );
  }
}
