part of pin_code_fields;

enum PinCodePlatform {
  /// Using this enum value will make the use of [Cupertino Alert Dialog] while
  /// showing paste dialog.
  ///
  /// [Cupertino Alert Dialog]: https://api.flutter.dev/flutter/cupertino/CupertinoAlertDialog-class.html
  iOS,

  /// Using this enum value will make the use of [Material Alert Dialog] while
  /// showing paste dialog.
  ///
  /// [Material Alert Dialog]: https://api.flutter.dev/flutter/material/AlertDialog-class.html
  other,
}
