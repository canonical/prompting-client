import 'package:flutter/material.dart' hide Action;
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/widgets/adaptive_button_bar.dart';
import 'package:yaru/yaru.dart';

typedef DeviceActionCallback = Future<PromptReplyResponse> Function({
  required Action action,
  required Lifespan lifespan,
});

class DeviceActionButtons extends ConsumerStatefulWidget {
  const DeviceActionButtons({
    required this.onAction,
    super.key,
  });

  final DeviceActionCallback onAction;

  @override
  ConsumerState<DeviceActionButtons> createState() =>
      _DeviceActionButtonsState();
}

class _DeviceActionButtonsState extends ConsumerState<DeviceActionButtons> {
  /// The width the bar has stretched the buttons to, reported after layout.
  /// A [YaruSplitButton] menu anchors to its button, so sizing the menu to
  /// the same width keeps it within the button whether the bar laid the
  /// buttons out in a row or a column.
  double? _menuWidth;

  Future<void> _handleAction(
    BuildContext context,
    Action action,
    Lifespan lifespan,
  ) async {
    final response = await widget.onAction(
      action: action,
      lifespan: lifespan,
    );
    if (response is PromptReplyResponseSuccess ||
        response is PromptReplyResponsePromptNotFound) {
      if (context.mounted) {
        // Closing the window destroys the GL context with it, so let the frame
        // the button press scheduled finish first -- otherwise the raster
        // thread goes to draw into a surface that is already gone.
        final window = YaruWindow.of(context);
        await SchedulerBinding.instance.endOfFrame;
        await window.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

    // `expanded` stretches each button to the width the bar gives it, so that a
    // long translation still spans its share whether the buttons end up side by
    // side or stacked.
    return AdaptiveButtonBar(
      spacing: 16,
      onChildWidthChanged: (width) {
        if (mounted) setState(() => _menuWidth = width);
      },
      children: [
        YaruSplitButton.filled(
          expanded: true,
          menuWidth: _menuWidth,
          onPressed: () =>
              _handleAction(context, Action.allow, Lifespan.forever),
          items: allowButtons
              .map(
                (item) => PopupMenuItem(
                  onTap: () =>
                      _handleAction(context, Action.allow, item.lifespan),
                  child: Text(item.label),
                ),
              )
              .toList(),
          child: Text(l10n.promptActionOptionAllowAlways),
        ),
        YaruSplitButton.filled(
          expanded: true,
          menuWidth: _menuWidth,
          onPressed: () => _handleAction(context, Action.deny, Lifespan.single),
          items: denyButtons
              .map(
                (item) => PopupMenuItem(
                  onTap: () =>
                      _handleAction(context, Action.deny, item.lifespan),
                  child: Text(item.label),
                ),
              )
              .toList(),
          child: Text(l10n.promptActionOptionDenyOnce),
        ),
      ],
    );
  }
}
