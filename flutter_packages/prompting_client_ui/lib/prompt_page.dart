import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:measure_size_builder/measure_size_builder.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/home/home_prompt_page.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/prompt_model.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

final _log = Logger('prompt_page');

class PromptPage extends ConsumerWidget {
  const PromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prompt = ref.watch(currentPromptProvider);

    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text(AppLocalizations.of(context).promptTitle),
        isMaximizable: false,
        isMinimizable: false,
        isClosable: false,
      ),
      body: SingleChildScrollView(
        child: MeasureSizeBuilder(
          builder: (context, size) {
            _log.debug('SizeChangedLayoutNotification received: $size');
            if (size.width >= 100 && size.height >= 100) {
              _ensureWindowSize(
                Size(
                  size.width,
                  size.height + kYaruTitleBarHeight,
                ),
              );
            }

            return SizeChangedLayoutNotifier(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: switch (prompt) {
                    PromptDetailsHome() => const HomePromptPage(),
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _ensureWindowSize(Size size) async {
  const delay = Duration(milliseconds: 100);
  const maxRetries = 10;
  var retries = 0;
  do {
    _log.debug('Setting window size to $size');
    await windowManager.setSize(size);
    await Future.delayed(delay);
  } while (await windowManager.getSize() != size && retries++ < maxRetries);
  if (retries >= maxRetries) {
    _log.error('Failed to set window size to $size');
  } else {
    _log.debug('Window size set to $size');
  }
}
