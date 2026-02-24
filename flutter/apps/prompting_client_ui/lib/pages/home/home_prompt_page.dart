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

const _verifiedAccountUrl = 'https://forum.snapcraft.io/t/verified-accounts/34002';

class HomePromptPage extends ConsumerWidget {
  const HomePromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homePromptDataModelProvider);
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...switch (model.view) {
          HomePromptView.standard => [],
          HomePromptView.moreOptions => [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: notifier.toggleMoreOptions,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.homePromptMoreOptionsTileLabel,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ],
          HomePromptView.customPathEditor => [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: notifier.cancelCustomPathEditor,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.homePatternTypeCustomPath,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ],
          HomePromptView.metadata => [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: notifier.navigateBackFromMetadata,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.homePromptMetaDataTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ],
        },
        ...switch (model.view) {
          HomePromptView.customPathEditor => [
              const _CustomPathEditor(),
            ],
          HomePromptView.standard => [
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Header(),
              if (model.visiblePatternOptions.isNotEmpty) const PatternOptions(),
              const Permissions(),
              if (model.error != null) _ErrorBox(model.error!),
              const ActionButtons(),
            ],
          HomePromptView.moreOptions => [
              const Header(),
              if (model.visiblePatternOptions.isNotEmpty) const PatternOptions(),
              if (model.error != null) _ErrorBox(model.error!),
              const Permissions(),
              const ActionButtons(),
            ],
          HomePromptView.metadata => [
              const _MetadataView(),
            ],
        },
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
    final model = ref.watch(homePromptDataModelProvider);
    final l10n = AppLocalizations.of(context);

    final markdownText = switch (model.enrichedPathKind) {
      EnrichedPathKindHomeDir() => l10n.homePromptHomeDirBody(
          model.details.metaData.snapName.bold(),
          model.details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
        ),
      EnrichedPathKindTopLevelDir(dirname: final dirname) =>
        l10n.homePromptTopLevelDirBody(
          model.details.metaData.snapName.bold(),
          model.details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          dirname.bold(),
        ),
      EnrichedPathKindSubDir() => l10n.homePromptDefaultBody(
          model.details.metaData.snapName.bold(),
          model.details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          model.details.requestedPath.bold(),
        ),
      EnrichedPathKindHomeDirFile(filename: final filename) =>
        l10n.homePromptHomeDirFileBody(
          model.details.metaData.snapName.bold(),
          model.details.requestedPermissions
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
          model.details.metaData.snapName.bold(),
          model.details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          filename.bold(),
          dirname.bold(),
        ),
      EnrichedPathKindSubDirFile() => l10n.homePromptDefaultBody(
          model.details.metaData.snapName.bold(),
          model.details.requestedPermissions
              .map((p) => p.localize(l10n).toLowerCase())
              .join(', ')
              .bold(),
          model.details.requestedPath.bold(),
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownText(
          markdownText,
        ),
        if (model.hasMeta && model.view == HomePromptView.standard)
          const _MetadataNavigationButton(),
      ],
    );
  }
}

class _MetadataNavigationButton extends ConsumerWidget {
  const _MetadataNavigationButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(homePromptDataModelProvider.notifier);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.navigate_next),
          onPressed: notifier.navigateToMetadata,
        ),
        Text(l10n.homePromptMetaDataTitle),
      ],
    );
  }
}

class _MetadataView extends ConsumerWidget {
  const _MetadataView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (metaData.publisher != null)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              MarkdownText(
                l10n.homePromptMetaDataPublishedBy(
                  metaData.publisher!.link(''),
                ),
              ),
              if (metaData.publisherVerified)
                Icon(
                  Icons.verified,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        if (metaData.publisherVerified)
          MarkdownText(
            '${l10n.homePromptMetaDataVerifiedAccountPrefix}'
            '[${l10n.homePromptMetaDataVerifiedAccountLink}]'
            '($_verifiedAccountUrl)'
            '${l10n.homePromptMetaDataVerifiedAccountSuffix}',
          ),
        if (updatedAt != null)
          Text(
            'App last updated on $updatedAt.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (metaData.storeUrl != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Open URL in browser
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                elevation: 0,
              ),
              child: Text(l10n.homePromptMetaDataAppCenterButton),
            ),
          ),
      ].withSpacing(12),
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
      title: switch (model.view) {
        HomePromptView.moreOptions =>
          l10n.promptAccessMoreOptionsTitle(model.details.metaData.snapName),
        _ => l10n.promptAccessTitle(
            model.details.metaData.snapName,
            model.details.requestedPermissions
                .map((p) => p.localize(l10n).toLowerCase())
                .join(', '),
          ),
      },
      options: model.visiblePatternOptions.toList(),
      optionTitle: (option) => option.localize(l10n),
      optionSubtitle: (option) => switch ((model.view, option.homePatternType)) {
        (HomePromptView.moreOptions, _) => Text(
            option.pathPattern,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        (_, HomePatternType.customPath) => Text(
            model.customPath,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
        _ => null,
      },
      groupValue: model.patternOption,
      onChanged: notifier.setPatternOption,
      trailingTile: switch (model.view) {
        HomePromptView.moreOptions => PromptingListTile(
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
          ),
        _ => PromptingListTile(
            title: l10n.homePromptMoreOptionsTileLabel,
            trailing: const Icon(Icons.navigate_next),
            onTap: notifier.toggleMoreOptions,
          ),
      },
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
        TextFormField(
          style: Theme.of(context).textTheme.bodyMedium,
          initialValue: initialCustomPath,
          onChanged: notifier.setCustomPath,
          decoration: InputDecoration(
            labelText: l10n.homePatternTypeCustomPath,
            suffixIcon: const Icon(Icons.edit_outlined),
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
    final model = ref.watch(homePromptDataModelProvider);
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    final selectedSummary = model.permissions.isEmpty
        ? null
        : model.permissions.map((p) => p.localize(l10n)).join(', ');

    return YaruBorderContainer(
      clipBehavior: Clip.hardEdge,
      child: PopupMenuButton<HomePermission>(
        padding: EdgeInsets.zero,
        tooltip: '',
        position: PopupMenuPosition.under,
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
