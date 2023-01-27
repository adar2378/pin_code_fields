part of pin_code_fields;

class DialogConfig {
  /// title of the [AlertDialog] while pasting the code. Default to [Paste Code]
  final String? dialogTitle;

  /// content of the [AlertDialog] while pasting the code. Default to ["Do you want to paste this code "]
  final String? dialogContent;

  /// Affirmative action text for the [AlertDialog]. Default to "Paste"
  final String? affirmativeText;

  /// Negative action text for the [AlertDialog]. Default to "Cancel"
  final String? negativeText;

  /// The default dialog theme, should it be iOS or other(including web and Android)
  final Platform platform;

  DialogConfig._internal({
    this.dialogContent,
    this.dialogTitle,
    this.affirmativeText,
    this.negativeText,
    this.platform = Platform.other,
  });

  factory DialogConfig({
    String? affirmativeText,
    String? dialogContent,
    String? dialogTitle,
    String? negativeText,
    Platform? platform,
  }) {
    return DialogConfig._internal(
      affirmativeText: affirmativeText ?? "Paste",
      dialogContent: dialogContent ?? "Do you want to paste this code ",
      dialogTitle: dialogTitle ?? "Paste Code",
      negativeText: negativeText ?? "Cancel",
      platform: platform ?? Platform.other,
    );
  }
}
