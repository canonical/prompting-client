import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:yaru/yaru.dart';

typedef DeviceActionCallback = Future<PromptReplyResponse> Function({
  required Action action,
  required Lifespan lifespan,
});

class DeviceActionButtons extends ConsumerWidget {
  const DeviceActionButtons({
    required this.onAction,
    super.key,
  });

  final DeviceActionCallback onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = [
      DeviceActionButton(
        action: Action.allow,
        lifespan: Lifespan.forever,
        onPressed: onAction,
      ),
      DeviceActionButton(
        action: Action.allow,
        lifespan: Lifespan.session,
        onPressed: onAction,
      ),
      DeviceActionButton(
        action: Action.deny,
        lifespan: Lifespan.single,
        onPressed: onAction,
      ),
    ];
    return Wrap(runSpacing: 16, spacing: 16, children: buttons);
  }
}

class DeviceActionButton extends ConsumerWidget {
  const DeviceActionButton({
    required this.action,
    required this.onPressed,
    this.lifespan,
    super.key,
  });

  final Action action;
  final Lifespan? lifespan;
  final DeviceActionCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return OutlinedButton(
      onPressed: () async {
        final response = await onPressed(
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
