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

    return AdaptiveButtonBar(
      spacing: 16,
      children: [
        _SplitButton(
          label: l10n.promptActionOptionAllowAlways,
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
        ),
        _SplitButton(
          label: l10n.promptActionOptionDenyOnce,
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
        ),
      ],
    );
  }
}

/// A split button that fills the width it is given, with a dropdown menu as
/// wide as the button.
///
/// `expanded` is what stretches the button, so that a long translation still
/// gets a button spanning its share whether the bar lays the buttons out side
/// by side or stacked.
///
/// The menu is sized and placed here rather than by [YaruSplitButton] because
/// Yaru anchors it to the whole split button and leaves Material to choose an
/// edge of that anchor to align to. That choice only lands under the arrow
/// while the button hugs its label; stretched, the anchor is far wider than the
/// menu, and a full-width button leaves both edges equidistant, so the menu
/// opens at the end of the button opposite the arrow that was pressed. A menu
/// as wide as its anchor sits in the same place whichever edge Material picks.
class _SplitButton extends StatelessWidget {
  const _SplitButton({
    required this.label,
    required this.onPressed,
    required this.items,
  });

  final String label;
  final VoidCallback onPressed;
  final List<PopupMenuEntry<Object?>> items;

  void _showMenu(BuildContext context) {
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(
            button.size.bottomLeft(Offset.zero),
            ancestor: overlay,
          ),
          button.localToGlobal(
            button.size.bottomRight(Offset.zero),
            ancestor: overlay,
          ),
        ),
        Offset.zero & overlay.size,
      ),
      constraints: BoxConstraints.tightFor(width: button.size.width),
      // Matches the padding Yaru gives the menu it would have shown itself.
      menuPadding: const EdgeInsets.symmetric(vertical: kYaruButtonRadius),
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) => YaruSplitButton.filled(
        expanded: true,
        items: items,
        onPressed: onPressed,
        onOptionsPressed: () => _showMenu(context),
        child: Text(label),
      );
}
