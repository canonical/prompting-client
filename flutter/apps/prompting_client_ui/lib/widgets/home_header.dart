import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/l10n_x.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_data_model.dart';
import 'package:prompting_client_ui/widgets/markdown_text.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key, this.metadataButton});

  final Widget? metadataButton;

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
        MarkdownText(markdownText),
        if (metadataButton != null) metadataButton!,
      ],
    );
  }
}
