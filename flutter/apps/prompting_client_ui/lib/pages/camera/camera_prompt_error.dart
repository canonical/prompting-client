sealed class CameraPromptError {
  const CameraPromptError();

  String body() => switch (this) {
        CameraPromptErrorUnknown(message: final message) => message
      };
  String title() => switch (this) {
        CameraPromptErrorUnknown() => 'Camera Error',
      };
}

class CameraPromptErrorUnknown extends CameraPromptError {
  CameraPromptErrorUnknown(this.message);
  final String message;
}
