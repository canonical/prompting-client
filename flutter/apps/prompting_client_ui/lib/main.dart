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
import 'package:yaru/yaru.dart';

const envVarSocketPath = 'PROMPTING_CLIENT_SOCKET';

Future<void> main(List<String> args) async {
  // We specify path as an empty string in order to get ubuntu_logger to skip
  // setting up a file for logging
  Logger.setup(path: '', level: LogLevel.info);
  final log = Logger('apparmor_prompt');

  await YaruWindowTitleBar.ensureInitialized();

  final parser = ArgParser()
    ..addFlag(
      'dry-run',
      help: 'Use a fake apparmor prompting client',
    )
    ..addOption(
      'test-prompt',
      help: 'Path to a JSON file containing the test prompt',
      defaultsTo: 'test/test_prompts/test_home_prompt_details.json',
    );

  final ArgResults argResults;
  try {
    argResults = parser.parse(args);
  } on FormatException catch (_) {
    stdout.writeln(parser.usage);
    exit(2);
  }

  if (argResults.flag('dry-run')) {
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
  final currentPromptStream = getService<PromptingClient>().getCurrentPrompt();
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

  runApp(const ProviderScope(child: PromptDialog()));
}

class PromptDialog extends StatelessWidget {
  const PromptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) => MaterialApp(
        theme: yaru.theme?.customize(),
        darkTheme: yaru.darkTheme?.customize(),
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
