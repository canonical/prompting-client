import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/home/home_custom_path_page.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_data_model.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_error.dart';
import 'package:prompting_client_ui/widgets/home_header.dart';
import 'package:prompting_client_ui/widgets/home_pattern_options.dart';
import 'package:prompting_client_ui/widgets/iterable_extensions.dart';
import 'package:prompting_client_ui/widgets/prompting_list_tile.dart';
import 'package:prompting_client_ui/widgets/themed_page_route.dart';
import 'package:prompting_client_ui/widgets/tile_constants.dart';
import 'package:yaru/yaru.dart';

class HomeMoreOptionsPage extends ConsumerWidget {
  const HomeMoreOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homePromptDataModelProvider);
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: () => Navigator.pop(context),
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
              const HomeHeader(),
              if (model.allPatternOptions.isNotEmpty)
                HomePatternOptions(
                  options: model.allPatternOptions,
                  title: l10n.promptAccessMoreOptionsTitle(
                    model.details.metaData.snapName,
                  ),
                  showSubtitles: true,
                  onChanged: (option) {
                    notifier.setPatternOption(option);
                    Navigator.pop(context);
                  },
                  trailingTile: PromptingListTile(
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
                      onChanged: (_) {
                        notifier.enterCustomPathEditor();
                        Navigator.push(
                          context,
                          ThemedPageRoute<void>(
                            builder: (context) => const HomeCustomPathPage(),
                          ),
                        );
                      },
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () {
                      notifier.enterCustomPathEditor();
                      Navigator.push(
                        context,
                        ThemedPageRoute<void>(
                          builder: (context) => const HomeCustomPathPage(),
                        ),
                      );
                    },
                  ),
                ),
              if (model.error != null) _ErrorBox(model.error!),
            ].withSpacing(kContentSpacing),
          ),
        ),
      ),
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
