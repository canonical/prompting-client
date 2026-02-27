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

  Future<void> _handleAction(
    BuildContext context,
    Action action,
    Lifespan lifespan,
  ) async {
    final response = await onAction(
      action: action,
      lifespan: lifespan,
    );
    if (response is PromptReplyResponseSuccess ||
        response is PromptReplyResponsePromptNotFound) {
      if (context.mounted) {
        await YaruWindow.of(context).close();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final allowButtons = [
      (
        label: l10n.promptActionOptionAllowUntilLogout,
        lifespan: Lifespan.session,
      ),
      (
        label: l10n.promptActionOptionAllowOnce,
        lifespan: Lifespan.single,
      ),
    ];

    final denyButtons = [
      (
        label: l10n.promptActionOptionDenyAlways,
        lifespan: Lifespan.forever,
      ),
      (
        label: l10n.promptActionOptionDenyUntilLogout,
        lifespan: Lifespan.session,
      ),
    ];

    return Center(
      child: Wrap(
        runSpacing: 16,
        spacing: 16,
        alignment: WrapAlignment.center,
        children: [
          YaruSplitButton.filled(
            items: allowButtons
                .map(
                  (item) => PopupMenuItem(
                    onTap: () =>
                        _handleAction(context, Action.allow, item.lifespan),
                    child: Text(item.label),
                  ),
                )
                .toList(),
            onPressed: () =>
                _handleAction(context, Action.allow, Lifespan.forever),
            child: Text(l10n.promptActionOptionAllowAlways),
          ),
          YaruSplitButton.filled(
            items: denyButtons
                .map(
                  (item) => PopupMenuItem(
                    onTap: () =>
                        _handleAction(context, Action.deny, item.lifespan),
                    child: Text(item.label),
                  ),
                )
                .toList(),
            onPressed: () =>
                _handleAction(context, Action.deny, Lifespan.single),
            child: Text(l10n.promptActionOptionDenyOnce),
          ),
        ],
      ),
    );
  }
}
