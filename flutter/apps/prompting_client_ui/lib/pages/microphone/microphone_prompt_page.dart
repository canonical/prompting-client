import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/microphone/microphone_prompt_data_model.dart';
import 'package:prompting_client_ui/pages/microphone/microphone_prompt_error.dart';
import 'package:prompting_client_ui/widgets/iterable_extensions.dart';
import 'package:yaru/yaru.dart';

class MicrophonePromptPage extends ConsumerWidget {
  const MicrophonePromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error =
        ref.watch(microphonePromptDataModelProvider.select((m) => m.error));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MicrophoneHeader(),
        if (error != null) MicrophoneErrorBox(error),
        const MicrophoneActionButtons(),
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
    return Text(text);
  }
}

class MicrophoneActionButtons extends ConsumerWidget {
  const MicrophoneActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const buttons = [
      MicrophoneActionButton(action: Action.allow, lifespan: Lifespan.forever),
      MicrophoneActionButton(action: Action.allow, lifespan: Lifespan.session),
      MicrophoneActionButton(action: Action.deny, lifespan: Lifespan.single),
    ];
    return Wrap(runSpacing: 16, spacing: 16, children: buttons);
  }
}

class MicrophoneActionButton extends ConsumerWidget {
  const MicrophoneActionButton(
      {required this.action, this.lifespan, super.key});

  final Action action;
  final Lifespan? lifespan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return OutlinedButton(
      onPressed: () async {
        final response = await ref
            .read(microphonePromptDataModelProvider.notifier)
            .saveAndContinue(
              action: action,
              lifespan: lifespan ?? Lifespan.single,
            );
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
          (Action.allow, Lifespan.forever) =>
            l10n.promptActionOptionAllowAlways,
          (Action.allow, Lifespan.session) =>
            l10n.promptActionOptionAllowUntilLogout,
          (Action.deny, Lifespan.single) => l10n.promptActionOptionDenyOnce,
          _ => action == Action.allow
              ? l10n.promptActionOptionAllow
              : l10n.promptActionOptionDeny,
        },
      ),
    );
  }
}
