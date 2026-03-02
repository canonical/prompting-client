import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/l10n_x.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_data_model.dart';
import 'package:prompting_client_ui/theme.dart';
import 'package:yaru/yaru.dart';

class HomePermissions extends ConsumerWidget {
  const HomePermissions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homePromptDataModelProvider);
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    final selectedSummary = switch (model.permissions.length) {
      0 => null,
      1 => model.permissions.first.localizeOnly(l10n),
      _ => model.permissions.map((p) => p.localize(l10n)).join(', '),
    };

    return YaruBorderContainer(
      clipBehavior: Clip.hardEdge,
      child: PopupMenuButton<HomePermission>(
        padding: EdgeInsets.zero,
        tooltip: '',
        position: PopupMenuPosition.under,
        offset: Offset(1, 1),
        itemBuilder: (context) => [
          for (final option in model.details.availablePermissions)
            YaruMultiSelectPopupMenuItem<HomePermission>(
              value: option,
              checked: model.permissions.contains(option),
              enabled: !model.details.requestedPermissions.contains(option),
              onChanged: (_) => notifier.togglePermission(option),
              child: Text(option.localize(l10n)),
            ),
        ],
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kTileMinHeight),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kTileHorizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.homePromptPermissionsTitle,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: kTileTitleLetterSpacing,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    if (selectedSummary != null)
                      Text(
                        selectedSummary,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              letterSpacing: kTileTitleLetterSpacing,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    const Icon(YaruIcons.go_down, size: kTrailingIconSize),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
