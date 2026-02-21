import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:measure_size_builder/measure_size_builder.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/app/prompt_model.dart';
import 'package:prompting_client_ui/pages/camera/camera_prompt_page.dart';
import 'package:prompting_client_ui/pages/home/home_prompt_page.dart';
import 'package:prompting_client_ui/pages/microphone/microphone_prompt_page.dart';
import 'package:prompting_client_ui/theme.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';
import 'package:window_manager/window_manager.dart';

final _log = Logger('prompt_page');

class PromptPage extends ConsumerWidget {
  const PromptPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prompt = ref.watch(currentPromptProvider);

    // Home prompts use dynamic resize (min 400x670), camera/mic prompts use fixed size.
    final allowDynamicResize = prompt is PromptDetailsHome;

    final minWidth = allowDynamicResize
        ? homePromptWindowSize.width
        : defaultWindowSize.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: MeasureSizeBuilder(
          builder: (context, size) {
            _log.debug(
              'SizeChangedLayoutNotification received: (${size.width}, ${size.height})',
            );
            if (allowDynamicResize) {
              final constrainedSize = Size(
                size.width.clamp(homePromptWindowSize.width, double.infinity),
                size.height.clamp(homePromptWindowSize.height, double.infinity),
              );
              _ensureWindowSize(constrainedSize);
            } else {
              _ensureWindowSize(defaultWindowSize);
            }

            return Consumer(
              builder: (context, ref, _) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.size != null && allowDynamicResize) {
                    final constrainedSize = Size(
                      context.size!.width.clamp(homePromptWindowSize.width, double.infinity),
                      context.size!.height.clamp(homePromptWindowSize.height, double.infinity),
                    );
                    _ensureWindowSize(constrainedSize);
                  }
                });
                return SizeChangedLayoutNotifier(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: minWidth),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: switch (prompt) {
                        PromptDetailsHome() => const HomePromptPage(),
                        PromptDetailsCamera() => const CameraPromptPage(),
                        PromptDetailsMicrophone() =>
                          const MicrophonePromptPage(),
                      },
                    ),
                  ),
                );
              },
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

  if (size.width < 100 || size.height < 100) return;

  do {
    _log.debug('Setting window size to (${size.width}, ${size.height})');
    await windowManager.setSize(size);
    await Future.delayed(delay);
  } while (await windowManager.getSize() != size && retries++ < maxRetries);
  if (retries >= maxRetries) {
    _log.error('Failed to set window size to (${size.width}, ${size.height})');
  } else {
    _log.debug('Window size set to (${size.width}, ${size.height})');
  }
}
