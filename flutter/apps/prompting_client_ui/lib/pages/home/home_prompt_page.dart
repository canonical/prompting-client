import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/l10n_x.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_data_model.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_error.dart';
import 'package:prompting_client_ui/widgets/device_action_buttons.dart';
import 'package:prompting_client_ui/widgets/form_widgets.dart';
import 'package:prompting_client_ui/widgets/iterable_extensions.dart';
import 'package:prompting_client_ui/widgets/markdown_text.dart';
import 'package:prompting_client_ui/widgets/prompting_list_tile.dart';
import 'package:prompting_client_ui/widgets/snap_icon.dart';
import 'package:prompting_client_ui/widgets/tile_constants.dart';
import 'package:yaru/yaru.dart';

class HomePromptPage extends ConsumerWidget {
  const HomePromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMoreOptions = ref.watch(
      homePromptDataModelProvider.select((m) => m.showMoreOptions),
    );
    final showCustomPathEditor = ref.watch(
      homePromptDataModelProvider.select((m) => m.showCustomPathEditor),
    );
    final hasVisibleOptions = ref.watch(
      homePromptDataModelProvider
          .select((m) => m.visiblePatternOptions.isNotEmpty),
    );
    final error = ref.watch(homePromptDataModelProvider.select((m) => m.error));
    final snapIcon = ref.watch(
      homePromptDataModelProvider.select((m) => m.details.metaData.snapIcon),
    );
    final details = ref.watch(
      homePromptDataModelProvider.select((m) => m.details),
    );
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    if (showCustomPathEditor) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: notifier.cancelCustomPathEditor,
          ),
          const _CustomPathEditor(),
        ].withSpacing(20),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMoreOptions)
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: notifier.toggleMoreOptions,
          ),
        if (snapIcon != null)
          Center(
            child: SnapIcon(snapIcon: snapIcon, dimension: 80),
          ),
        Center(
          child: Text(
            l10n.homePromptTitleQuestion(
              details.metaData.snapName,
              details.requestedPermissions
                  .map((p) => p.localize(l10n).toLowerCase())
                  .join(', '),
            ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Header(),
        if (hasVisibleOptions)
          const PatternOptions(),
        if (error != null && showMoreOptions) _ErrorBox(error),
        const Permissions(),
        if (error != null && !showMoreOptions) _ErrorBox(error),
        const ActionButtons(),
      ].withSpacing(20),
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

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(
      homePromptDataModelProvider.select((m) => m.details),
    );
    final hasMeta = ref.watch(
      homePromptDataModelProvider.select((m) => m.hasMeta),
    );
    final enrichedPathKind = ref.watch(
      homePromptDataModelProvider.select((m) => m.enrichedPathKind),
    );
    final l10n = AppLocalizations.of(context);

    final markdownText = switch (enrichedPathKind) {
      EnrichedPathKindHomeDir() => l10n.homePromptHomeDirBody(
          details.metaData.snapName.bold(),
          details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
        ),
      EnrichedPathKindTopLevelDir(dirname: final dirname) =>
        l10n.homePromptTopLevelDirBody(
          details.metaData.snapName.bold(),
          details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          dirname.bold(),
        ),
      EnrichedPathKindSubDir() => l10n.homePromptDefaultBody(
          details.metaData.snapName.bold(),
          details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          details.requestedPath.bold(),
        ),
      EnrichedPathKindHomeDirFile(filename: final filename) =>
        l10n.homePromptHomeDirFileBody(
          details.metaData.snapName.bold(),
          details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          filename.bold(),
        ),
      EnrichedPathKindTopLevelDirFile(
        dirname: final dirname,
        filename: final filename
      ) =>
        l10n.homePromptTopLevelDirFileBody(
          details.metaData.snapName.bold(),
          details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          filename.bold(),
          dirname.bold(),
        ),
      EnrichedPathKindSubDirFile() => l10n.homePromptDefaultBody(
          details.metaData.snapName.bold(),
          details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          details.requestedPath.bold(),
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownText(
          markdownText,
        ),
        if (hasMeta) const MetaDataDropdown(),
      ],
    );
  }
}

class MetaDataDropdown extends ConsumerWidget {
  const MetaDataDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final metaData = ref
        .watch(homePromptDataModelProvider.select((m) => m.details.metaData));

    String? updatedAt;
    if (metaData.updatedAt != null) {
      try {
        updatedAt = DateFormat.yMMMd().format(metaData.updatedAt!);
      } on ArgumentError catch (_) {
        // Fall back to English if the locale isn't valid
        updatedAt = DateFormat.yMMMd('en').format(metaData.updatedAt!);
      }
    }

    return YaruExpandable(
      expandButtonPosition: YaruExpandableButtonPosition.start,
      header: Text(l10n.homePromptMetaDataTitle),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (metaData.publisher != null)
                    MarkdownText(
                      l10n.homePromptMetaDataPublishedBy(
                        metaData.publisher!.link(''),
                      ),
                    ),
                  if (updatedAt != null)
                    MarkdownText(
                      l10n.homePromptMetaDataLastUpdated(updatedAt).bold(),
                    ),
                  if (metaData.storeUrl != null)
                    MarkdownText(
                      l10n.homePromptMetaDataAppCenterLink
                          .link(metaData.storeUrl!),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DeviceActionButtons(
      onAction: ({required action, required lifespan}) => ref
          .read(homePromptDataModelProvider.notifier)
          .saveAndContinue(action: action, lifespan: lifespan),
    );
  }
}

class PatternOptions extends ConsumerWidget {
  const PatternOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homePromptDataModelProvider);
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return RadioButtonList<PatternOption>(
      title: model.showMoreOptions
          ? l10n.promptAccessMoreOptionsTitle(model.details.metaData.snapName)
          : l10n.promptAccessTitle(
              model.details.metaData.snapName,
              model.details.requestedPermissions
                  .map((p) => p.localize(l10n).toLowerCase())
                  .join(', '),
            ),
      options: model.visiblePatternOptions.toList(),
      optionTitle: (option) => option.localize(l10n),
      optionSubtitle: (option) => model.showMoreOptions
          ? Text(
              option.pathPattern,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            )
          : null,
      groupValue: model.patternOption,
      onChanged: notifier.setPatternOption,
      trailingTile: model.showMoreOptions
          ? PromptingListTile(
              title: l10n.homePatternTypeCustomPath,
              subtitle: model.patternOption.homePatternType ==
                      HomePatternType.customPath
                  ? Text(
                      model.customPath,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    )
                  : null,
              leading: YaruRadio<PatternOption>(
                value: HomePromptData.empty,
                groupValue: model.patternOption,
                onChanged: (_) => notifier.enterCustomPathEditor(),
              ),
              trailing: const Icon(Icons.edit_outlined),
              onTap: notifier.enterCustomPathEditor,
            )
          : PromptingListTile(
              title: l10n.homePromptMoreOptionsTileLabel,
              trailing: const Icon(Icons.navigate_next),
              onTap: notifier.toggleMoreOptions,
            ),
    );
  }
}

class _CustomPathEditor extends ConsumerWidget {
  const _CustomPathEditor();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialCustomPath =
        ref.read(homePromptDataModelProvider.select((m) => m.customPath));
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YaruBorderContainer(
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kTileHorizontalPadding,
              vertical: 12,
            ),
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              initialValue: initialCustomPath,
              onChanged: notifier.setCustomPath,
              decoration: InputDecoration(
                labelText: l10n.homePatternTypeCustomPath,
                suffixIcon: const Icon(Icons.edit_outlined),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kTileHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeCustomPathMustStartWithSlash,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _WildcardRow('*', l10n.homeCustomPathWildcardStarDescription),
              _WildcardRow('?', l10n.homeCustomPathWildcardQuestionDescription),
              _WildcardRow('/**', l10n.homeCustomPathWildcardDoubleStarDescription),
              _WildcardRow('{x,y}', l10n.homeCustomPathWildcardCurlyDescription),
              _WildcardRow(r'\', l10n.homeCustomPathWildcardBackslashDescription),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: notifier.saveCustomPath,
          child: Text(l10n.homeCustomPathSaveButton),
        ),
      ].withSpacing(12),
    );
  }
}

class _WildcardRow extends StatelessWidget {
  const _WildcardRow(this.label, this.description);

  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class Permissions extends ConsumerWidget {
  const Permissions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPermissions =
        ref.watch(homePromptDataModelProvider.select((m) => m.permissions));
    final details = ref.watch(
      homePromptDataModelProvider.select((m) => m.details),
    );
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    final selectedSummary = selectedPermissions.isEmpty
        ? null
        : selectedPermissions.map((p) => p.localize(l10n)).join(', ');

    return YaruBorderContainer(
      clipBehavior: Clip.hardEdge,
      child: PopupMenuButton<HomePermission>(
        padding: EdgeInsets.zero,
        tooltip: '',
        position: PopupMenuPosition.under,
        itemBuilder: (context) => [
          for (final option in details.availablePermissions)
            YaruMultiSelectPopupMenuItem<HomePermission>(
              value: option,
              checked: selectedPermissions.contains(option),
              enabled: !details.requestedPermissions.contains(option),
              onChanged: (_) => notifier.togglePermission(option),
              child: Text(option.localize(l10n)),
            ),
        ],
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kTileMinHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kTileHorizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homePromptPermissionsTitle,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            letterSpacing: kTileTitleLetterSpacing,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    if (selectedSummary != null)
                      Text(
                        selectedSummary,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                  ],
                ),
                const Icon(Icons.expand_more),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
