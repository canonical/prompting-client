import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prompting_client/prompting_client.dart';
import 'package:prompting_client_ui/fake_prompting_client.dart';
import 'package:prompting_client_ui/l10n.dart';
import 'package:prompting_client_ui/pages/prompt_page.dart';
import 'package:prompting_client_ui/theme.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

const envVarSocketPath = 'PROMPTING_CLIENT_SOCKET';

Future<void> main(List<String> args) async {
  // We specify path as an empty string in order to get ubuntu_logger to skip
  // setting up a file for logging
  Logger.setup(path: '', level: LogLevel.info);
  final log = Logger('apparmor_prompt');

  await YaruWindowTitleBar.ensureInitialized();
  await windowManager.ensureInitialized();

  final parser = ArgParser()
    ..addFlag(
      'dry-run',
      help: 'Use a fake apparmor prompting client',
    )
    ..addOption(
      'test-prompt',
      help: 'Path to a JSON file containing the test prompt',
      defaultsTo: 'test/test_prompts/test_home_prompt_details.json',
    )
    ..addOption(
      'snap',
      help: 'Snap name',
    )
    ..addOption(
      'app-pid',
      help: 'Application PID',
    )
    ..addOption(
      'cgroup',
      help: 'Application cgroup',
    )
    ..addOption(
      'interface-name',
      help: 'Interface name (home, camera, audio-record)',
    );

  final ArgResults argResults;
  try {
    argResults = parser.parse(args);
  } on FormatException catch (_) {
    stdout.writeln(parser.usage);
    exit(2);
  }

  // Log parsed arguments for debugging
  if (argResults['snap'] != null) {
    log.debug('Snap name: ${argResults['snap']}');
  }
  if (argResults['app-pid'] != null) {
    log.debug('App PID: ${argResults['app-pid']}');
  }
  if (argResults['cgroup'] != null) {
    log.debug('Cgroup: ${argResults['cgroup']}');
  }

  if (argResults.flag('dry-run')) {
    log.info('Running in dry-run mode');
    final fileName = argResults['test-prompt'] as String;
    if (!File(fileName).existsSync()) {
      log.error('Test prompt file $fileName does not exist');
      exit(1);
    }
    registerService<PromptingClient>(
      () => FakeApparmorPromptingClient.fromFile(fileName),
      dispose: (service) => (service as FakeApparmorPromptingClient).dispose(),
    );
  } else {
    final socketPath = Platform.environment[envVarSocketPath];
    if (socketPath == null) {
      log.error('$envVarSocketPath not set');
      exit(1);
    }
    registerService<PromptingClient>(
      () => PromptingClient(
        InternetAddress(socketPath, type: InternetAddressType.unix),
      ),
    );
  }

  final completer = Completer();
  final cgroup = argResults['cgroup'] as String?;
  if (cgroup == null) {
    log.error('Cgroup argument is required');
    exit(1);
  }
  final currentPromptStream =
      getService<PromptingClient>().getCurrentPrompt(cgroup);
  currentPromptStream.listen(
    (promptDetails) {
      registerServiceInstance<PromptDetails>(promptDetails);
      completer.complete();
    },
    onDone: () {
      log.info('stream closed - exiting');
      exit(3);
    },
    onError: (e) {
      log.error('Caught grpc error $e - exiting');
      exit(4);
    },
  );
  await completer.future;

  await initDefaultLocale();

  // No waitUntilReadyToShow, deliberately: it probes the window state on the
  // way through, and on Linux an off-screen window reads back as iconified, so
  // it "restores" it -- putting the window on screen at the bootstrap size,
  // which is exactly what hide_on_first_map() in linux/my_application.cc took
  // it off screen to avoid.
  //
  // No minimum or maximum size either: window_manager applies those as
  // GdkWindow geometry hints, which are measured across the client-side
  // decoration shadow, while setSize and getSize speak the logical window size.
  // Mixing the two pinned the frame to kWindowWidth and left the Flutter
  // viewport 52px narrower, so the measured height never settled.
  //
  // PromptPage sizes and shows the window once it has measured the prompt.
  await windowManager.setResizable(false);

  runApp(const ProviderScope(child: PromptDialog()));
}

class PromptDialog extends StatelessWidget {
  const PromptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) => MaterialApp(
        // Non-nullable as of yaru 10.2.0, so no `?.` here.
        theme: yaru.theme.customize(),
        darkTheme: yaru.darkTheme.customize(),
        highContrastTheme: yaruHighContrastLight.customize(),
        highContrastDarkTheme: yaruHighContrastDark.customize(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        home: const PromptPage(),
      ),
    );
  }
}
