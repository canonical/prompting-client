import 'package:flutter/material.dart' hide Action;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_data_model.dart';
import 'package:prompting_client_ui/widgets/iterable_extensions.dart';
import 'package:prompting_client_ui/widgets/tile_constants.dart';

class HomeCustomPathPage extends ConsumerWidget {
  const HomeCustomPathPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialCustomPath =
        ref.read(homePromptDataModelProvider.select((m) => m.customPath));
    final notifier = ref.read(homePromptDataModelProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: () {
                      notifier.cancelCustomPathEditor();
                      Navigator.pop(context);
                    },
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
                onPressed: () {
                  notifier.saveCustomPath();
                  // Pop back to standard page (pop both custom path and more options pages)
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(l10n.homeCustomPathSaveButton),
              ),
            ].withSpacing(kContentSpacing),
          ),
        ),
      ),
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
