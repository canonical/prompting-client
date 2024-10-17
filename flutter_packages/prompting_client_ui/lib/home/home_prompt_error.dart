import 'package:prompting_client_ui/l10n.dart';

sealed class HomePromptError {
  const HomePromptError();

  String body(AppLocalizations l10n) => switch (this) {
        HomePromptErrorUnknown(message: final message) => message
      };
  String title(AppLocalizations l10n) => switch (this) {
        HomePromptErrorUnknown() => l10n.homePromptErrorUnknownTitle,
      };
}

class HomePromptErrorUnknown extends HomePromptError {
  HomePromptErrorUnknown(this.message);
  final String message;
}
