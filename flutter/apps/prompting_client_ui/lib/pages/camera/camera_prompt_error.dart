import 'package:prompting_client_ui/l10n.dart';

sealed class CameraPromptError {
  const CameraPromptError();

  String body(AppLocalizations l10n) => switch (this) {
        CameraPromptErrorUnknown(message: final message) => message
      };
  String title(AppLocalizations l10n) => switch (this) {
        CameraPromptErrorUnknown() => l10n.homePromptErrorUnknownTitle,
      };
}

class CameraPromptErrorUnknown extends CameraPromptError {
  CameraPromptErrorUnknown(this.message);
  final String message;
}
