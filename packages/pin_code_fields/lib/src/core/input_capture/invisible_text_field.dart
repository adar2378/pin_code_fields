import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

/// A completely invisible TextField that captures keyboard input.
///
/// This widget is positioned behind the visual PIN cells and handles
/// all keyboard input, text formatting, length limiting, and autofill.
class InvisibleTextField extends StatelessWidget {
  const InvisibleTextField({
    super.key,
    required this.editableTextKey,
    required this.controller,
    required this.focusNode,
    required this.length,
    this.readOnly = false,
    this.selectionEnabled = true,
    this.selectionControls,
    this.contextMenuBuilder,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onEditingComplete,
    this.onSelectionChanged,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20),
    this.autofillHints,
  });

  /// Key for accessing the EditableTextState.
  final GlobalKey<EditableTextState> editableTextKey;

  /// Controller for the text input.
  final TextEditingController controller;

  /// Focus node for managing keyboard focus.
  final FocusNode focusNode;

  /// Maximum number of characters (PIN length).
  final int length;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether selection gestures are enabled.
  final bool selectionEnabled;

  /// Text selection controls for copy/paste operations.
  final TextSelectionControls? selectionControls;

  /// Builder for the context menu (paste functionality).
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// The type of keyboard to display.
  final TextInputType keyboardType;

  /// Additional input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// How to capitalize text input.
  final TextCapitalization textCapitalization;

  /// The action button to display on the keyboard.
  final TextInputAction textInputAction;

  /// Called when the user submits the text.
  final ValueChanged<String>? onSubmitted;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the text selection changes.
  final SelectionChangedCallback? onSelectionChanged;

  /// The brightness of the keyboard.
  final Brightness? keyboardAppearance;

  /// Padding to apply when scrolling the field into view.
  final EdgeInsets scrollPadding;

  /// Autofill hints for the text field.
  ///
  /// Common values for PIN/OTP fields:
  /// - [AutofillHints.oneTimeCode] - For OTP/verification codes
  /// - [AutofillHints.password] - For PIN/password entry
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    // Use EditableText for core functionality with autofill support
    // Note: We use fontSize: 1 and Opacity instead of fontSize: 0.1
    // because web browsers need a properly sized text field to handle input
    return Opacity(
      opacity: 0,
      child: EditableText(
        key: editableTextKey,
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        // Invisible but properly sized for web compatibility
        style: const TextStyle(
          color: Colors.transparent,
          fontSize: 1,
        ),
        cursorColor: Colors.transparent,
        backgroundCursorColor: Colors.transparent,
        selectionColor: Colors.transparent,
        showCursor: false,
        showSelectionHandles: false,
        enableInteractiveSelection: selectionEnabled,
        selectionControls: selectionEnabled ? selectionControls : null,
        contextMenuBuilder: selectionEnabled ? contextMenuBuilder : null,
        // Input configuration
        keyboardType: keyboardType,
        inputFormatters: _buildInputFormatters(),
        autofocus: false, // Handled externally
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        onSelectionChanged: onSelectionChanged,
        keyboardAppearance: keyboardAppearance ?? Theme.of(context).brightness,
        scrollPadding: scrollPadding,
        textAlign: TextAlign.center,
        maxLines: 1,
        clipBehavior: Clip.none,
        // Autofill support
        autofillHints: autofillHints,
      ),
    );
  }

  List<TextInputFormatter> _buildInputFormatters() {
    return [
      // User formatters run first so they can normalise pasted text
      // (e.g. strip whitespace from "12 34 56") before the length limit
      // or digits-only filter discard characters.
      ...?inputFormatters,
      // Digits-only filter if numeric keyboard
      if (keyboardType == TextInputType.number)
        FilteringTextInputFormatter.digitsOnly,
      // Length limit applied last so it counts only the final characters
      LengthLimitingTextInputFormatter(length),
    ];
  }
}
