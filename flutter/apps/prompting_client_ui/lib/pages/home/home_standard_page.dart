import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/l10n_x.dart';
import 'package:prompting_client_ui/pages/home/home_metadata_page.dart';
import 'package:prompting_client_ui/pages/home/home_more_options_page.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_data_model.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_error.dart';
import 'package:prompting_client_ui/widgets/device_action_buttons.dart';
import 'package:prompting_client_ui/widgets/home_header.dart';
import 'package:prompting_client_ui/widgets/home_pattern_options.dart';
import 'package:prompting_client_ui/widgets/home_permissions.dart';
import 'package:prompting_client_ui/widgets/iterable_extensions.dart';
import 'package:prompting_client_ui/widgets/prompting_list_tile.dart';
import 'package:prompting_client_ui/widgets/snap_icon.dart';
import 'package:prompting_client_ui/widgets/themed_page_route.dart';
import 'package:prompting_client_ui/widgets/tile_constants.dart';
import 'package:yaru/yaru.dart';

class HomeStandardPage extends ConsumerWidget {
  const HomeStandardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homePromptDataModelProvider);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (model.details.metaData.snapIcon != null)
          Center(
            child: SnapIcon(
              snapIcon: model.details.metaData.snapIcon!,
              dimension: 80,
            ),
          ),
        Center(
          child: Text(
            l10n.homePromptTitleQuestion(
              model.details.metaData.snapName,
              model.details.requestedPermissions
                  .map((p) => p.localize(l10n).toLowerCase())
                  .join(', '),
            ),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        HomeHeader(
          metadataButton: model.hasMeta
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.navigate_next),
                      onPressed: () {
                        Navigator.push(
                          context,
                          ThemedPageRoute<void>(
                            builder: (context) => const HomeMetadataPage(),
                          ),
                        );
                      },
                    ),
                    Text(l10n.homePromptMetaDataTitle),
                  ],
                )
              : null,
        ),
        if (model.visiblePatternOptions.isNotEmpty)
          HomePatternOptions(
            title: l10n.promptAccessTitle(
              model.details.metaData.snapName,
              model.details.requestedPermissions
                  .map((p) => p.localize(l10n).toLowerCase())
                  .join(', '),
            ),
            trailingTile: PromptingListTile(
              title: l10n.homePromptMoreOptionsTileLabel,
              trailing: const Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(
                  context,
                  ThemedPageRoute<void>(
                    builder: (context) => const HomeMoreOptionsPage(),
                  ),
                );
              },
            ),
          ),
        const HomePermissions(),
        if (model.error != null) _ErrorBox(model.error!),
        DeviceActionButtons(
          onAction: ({required action, required lifespan}) => ref
              .read(homePromptDataModelProvider.notifier)
              .saveAndContinue(action: action, lifespan: lifespan),
        ),
      ].withSpacing(kContentSpacing),
    );
  }
}

class _ErrorBox extends ConsumerWidget {
  const _ErrorBox(this.error);

  final HomePromptError error;

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
