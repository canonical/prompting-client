import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/l10n_x.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_data_model.dart';
import 'package:prompting_client_ui/widgets/form_widgets.dart';

class HomePatternOptions extends ConsumerWidget {
  const HomePatternOptions({
    required this.title,
    super.key,
    this.showSubtitles = false,
    this.trailingTile,
    this.options,
    this.onChanged,
  });

  final String title;
  final bool showSubtitles;
  final Widget? trailingTile;
  final Iterable<PatternOption>? options;
  final void Function(PatternOption?)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homePromptDataModelProvider);
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return RadioButtonList<PatternOption>(
      title: title,
      options: (options ?? model.visiblePatternOptions).toList(),
      optionTitle: (option) => option.localize(l10n),
      optionSubtitle: (option) {
        if (showSubtitles) {
          return Text(
            option.pathPattern,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          );
        }
        if (option.homePatternType == HomePatternType.customPath) {
          return Text(
            model.customPath,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          );
        }
        return null;
      },
      groupValue: model.patternOption,
      onChanged: onChanged ?? notifier.setPatternOption,
      trailingTile: trailingTile,
    );
  }
}
