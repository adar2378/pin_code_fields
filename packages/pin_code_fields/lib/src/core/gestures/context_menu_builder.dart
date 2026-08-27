import 'package:material_ui/material_ui.dart';

/// Default context menu builder that only shows the Paste option.
///
/// For PIN/OTP fields, we typically only want paste functionality
/// and not cut/copy operations.
Widget defaultPinContextMenuBuilder(
  BuildContext context,
  EditableTextState editableTextState,
) {
  final items = editableTextState.contextMenuButtonItems;
  // Remove all items except paste
  items.removeWhere((item) => item.type != ContextMenuButtonType.paste);

  if (items.isEmpty) return const SizedBox.shrink();

  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: items,
  );
}
