import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

/// Gets platform-specific text selection controls.
///
/// Returns appropriate selection controls based on the current platform.
TextSelectionControls getDefaultSelectionControls(BuildContext context) {
  final platform = Theme.of(context).platform;
  return switch (platform) {
    TargetPlatform.iOS ||
    TargetPlatform.macOS =>
      cupertinoTextSelectionHandleControls,
    TargetPlatform.linux ||
    TargetPlatform.windows =>
      desktopTextSelectionHandleControls,

    _ =>
      materialTextSelectionHandleControls,
  };
}
