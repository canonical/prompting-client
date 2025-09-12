import 'package:prompting_client_ui/l10n.dart';

sealed class MicrophonePromptError {
  const MicrophonePromptError();

  String body(AppLocalizations l10n) => switch (this) {
        MicrophonePromptErrorUnknown(message: final message) => message
      };
  String title(AppLocalizations l10n) => switch (this) {
        MicrophonePromptErrorUnknown() => l10n.homePromptErrorUnknownTitle,
      };
}

class MicrophonePromptErrorUnknown extends MicrophonePromptError {
  MicrophonePromptErrorUnknown(this.message);
  final String message;
}
