import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_data_model.dart';
import 'package:prompting_client_ui/theme.dart';
import 'package:prompting_client_ui/widgets/iterable_extensions.dart';
import 'package:prompting_client_ui/widgets/markdown_text.dart';
import 'package:yaru/yaru.dart';

const _verifiedAccountUrl =
    'https://forum.snapcraft.io/t/verified-accounts/34002';

class HomeMetadataPage extends ConsumerWidget {
  const HomeMetadataPage({super.key});

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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(YaruIcons.go_previous),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.homePromptMetaDataTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: kBackButtonSpacerWidth),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kPagePadding),
              child: Column(
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
                      child: FilledButton(
                        onPressed: () {
                          // TODO: Open URL in browser
                        },
                        child: Text(l10n.homePromptMetaDataAppCenterButton),
                      ),
                    ),
                ].withSpacing(kContentSpacing),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
