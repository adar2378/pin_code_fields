import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../haptics.dart';
import '../pin_controller_mixin.dart';
import '../pin_input.dart';
import '../pin_input_controller.dart';

/// A [FormField] wrapper for [PinInput] that enables form validation.
///
/// This widget provides all the standard form field functionality including
/// validation, onSaved callbacks, and auto-validation modes.
///
/// Example:
/// ```dart
/// Form(
///   child: PinInputFormField(
///     length: 6,
///     builder: (context, cells) => Row(
///       children: cells.map((c) => MyCell(data: c)).toList(),
///     ),
///     validator: (value) {
///       if (value == null || value.length < 6) {
///         return 'Please enter all 6 digits';
///       }
///       return null;
///     },
///   ),
/// )
/// ```
///
/// To programmatically control the form field, provide a [pinController]:
/// ```dart
/// final controller = PinInputController();
///
/// PinInputFormField(
///   length: 6,
///   pinController: controller,
///   builder: (context, cells) => ...,
/// )
///
/// // Later:
/// controller.setText('1234');
/// controller.triggerError();
/// ```
class PinInputFormField extends FormField<String> {
  PinInputFormField({
    super.key,
    required this.length,
    required this.pinBuilder,
    // Controller
    this.pinController,
    // Input behavior
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    // Behavior
    super.enabled,
    this.autoFocus = false,
    this.readOnly = false,
    this.autoDismissKeyboard = true,
    this.clearErrorOnInput = true,
    this.obscureText = false,
    this.obscuringCharacter = '●',
    this.blinkWhenObscuring = true,
    this.blinkDuration = const Duration(milliseconds: 500),
    // Haptics
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = HapticFeedbackType.light,
    // Gestures
    this.enablePaste = true,
    this.selectionControls,
    this.contextMenuBuilder,
    // Clipboard
    this.onClipboardFound,
    this.clipboardValidator,
    // Callbacks
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onLongPress,
    this.onTapOutside,
    // Cursor
    this.mouseCursor,
    // Keyboard
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20),
    // Autofill
    this.enableAutofill = false,
    this.autofillContextAction = AutofillContextAction.commit,
    // Accessibility
    this.semanticLabel,
    // Form field
    super.validator,
    super.onSaved,
    super.initialValue,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.restorationId,
    // Error display
    this.errorTextSpace = 16.0,
    this.errorTextStyle,
  }) : super(
          builder: (FormFieldState<String> field) {
            final state = field as _PinInputFormFieldState;
            final widget = state.widget;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PinInput(
                  length: widget.length,
                  builder: widget.pinBuilder,
                  pinController: state.effectiveController,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  inputFormatters: widget.inputFormatters,
                  textCapitalization: widget.textCapitalization,
                  autofillHints: widget.autofillHints,
                  enabled: widget.enabled,
                  autoFocus: widget.autoFocus,
                  readOnly: widget.readOnly,
                  autoDismissKeyboard: widget.autoDismissKeyboard,
                  clearErrorOnInput: widget.clearErrorOnInput,
                  obscureText: widget.obscureText,
                  obscuringCharacter: widget.obscuringCharacter,
                  blinkWhenObscuring: widget.blinkWhenObscuring,
                  blinkDuration: widget.blinkDuration,
                  enableHapticFeedback: widget.enableHapticFeedback,
                  hapticFeedbackType: widget.hapticFeedbackType,
                  enablePaste: widget.enablePaste,
                  selectionControls: widget.selectionControls,
                  contextMenuBuilder: widget.contextMenuBuilder,
                  onClipboardFound: widget.onClipboardFound,
                  clipboardValidator: widget.clipboardValidator,
                  onChanged: (value) {
                    field.didChange(value);
                    widget.onChanged?.call(value);
                  },
                  onCompleted: widget.onCompleted,
                  onSubmitted: widget.onSubmitted,
                  onEditingComplete: widget.onEditingComplete,
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  onTapOutside: widget.onTapOutside,
                  mouseCursor: widget.mouseCursor,
                  keyboardAppearance: widget.keyboardAppearance,
                  scrollPadding: widget.scrollPadding,
                  enableAutofill: widget.enableAutofill,
                  autofillContextAction: widget.autofillContextAction,
                  semanticLabel: widget.semanticLabel,
                ),
                if (field.hasError) ...[
                  SizedBox(height: widget.errorTextSpace),
                  Text(
                    field.errorText!,
                    style: widget.errorTextStyle ??
                        TextStyle(
                          color: Theme.of(field.context).colorScheme.error,
                          fontSize: 12,
                        ),
                  ),
                ],
              ],
            );
          },
        );

  /// Number of PIN cells.
  final int length;

  /// Builder that receives cell data and returns the visual representation.
  ///
  /// Note: Named `pinBuilder` instead of `builder` to avoid conflict with
  /// the inherited [FormField.builder] which has a different signature.
  final PinCellBuilder pinBuilder;

  /// Controller for the PIN input.
  ///
  /// If not provided, an internal controller will be created.
  final PinInputController? pinController;

  /// The type of keyboard to display.
  final TextInputType keyboardType;

  /// The action button to display on the keyboard.
  final TextInputAction textInputAction;

  /// Additional input formatters to apply.
  final List<TextInputFormatter>? inputFormatters;

  /// How to capitalize text input.
  final TextCapitalization textCapitalization;

  /// Autofill hints for the text field.
  final Iterable<String>? autofillHints;

  /// Whether to auto-focus on mount.
  final bool autoFocus;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether to dismiss the keyboard when PIN is complete.
  final bool autoDismissKeyboard;

  /// Whether to automatically clear error state when user types.
  ///
  /// When `true` (default), any error state is cleared as soon as the user
  /// enters a new character. Set to `false` if you want the error to persist
  /// until explicitly cleared via `controller.clearError()`.
  final bool clearErrorOnInput;

  /// Whether to obscure the entered text.
  final bool obscureText;

  /// Character used to obscure text.
  final String obscuringCharacter;

  /// Whether to briefly show the character before obscuring.
  final bool blinkWhenObscuring;

  /// Duration to show the character before obscuring.
  final Duration blinkDuration;

  /// Whether to trigger haptic feedback on input.
  final bool enableHapticFeedback;

  /// Type of haptic feedback to trigger.
  final HapticFeedbackType hapticFeedbackType;

  /// Whether to enable paste functionality.
  final bool enablePaste;

  /// Custom text selection controls.
  final TextSelectionControls? selectionControls;

  /// Builder for the context menu (paste functionality).
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Called when the clipboard contains valid PIN-like content on focus.
  ///
  /// See [PinInput.onClipboardFound] for more details.
  final ValueChanged<String>? onClipboardFound;

  /// Custom validator for clipboard content.
  ///
  /// See [PinInput.clipboardValidator] for more details.
  final bool Function(String text, int length)? clipboardValidator;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the PIN is complete.
  final ValueChanged<String>? onCompleted;

  /// Called when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the widget is tapped.
  final VoidCallback? onTap;

  /// Called when the widget is long pressed.
  final VoidCallback? onLongPress;

  /// Called when user taps outside the field.
  ///
  /// See [PinInput.onTapOutside] for more details.
  final void Function(PointerDownEvent event)? onTapOutside;

  /// The mouse cursor to show when hovering over the widget.
  ///
  /// Defaults to [SystemMouseCursors.text] when enabled.
  final MouseCursor? mouseCursor;

  /// The brightness of the keyboard.
  final Brightness? keyboardAppearance;

  /// Padding when scrolling the field into view.
  final EdgeInsets scrollPadding;

  /// Whether to enable autofill.
  final bool enableAutofill;

  /// Action to perform when autofill context is disposed.
  final AutofillContextAction autofillContextAction;

  /// Semantic label for accessibility.
  ///
  /// See [PinInput.semanticLabel] for more details.
  final String? semanticLabel;

  /// Space between PIN input and error text.
  final double errorTextSpace;

  /// Style for error text.
  final TextStyle? errorTextStyle;

  @override
  FormFieldState<String> createState() => _PinInputFormFieldState();
}

class _PinInputFormFieldState extends FormFieldState<String>
    with PinControllerMixin {
  @override
  PinInputFormField get widget => super.widget as PinInputFormField;

  @override
  void initState() {
    super.initState();
    // Use mixin for controller initialization
    initPinController(
      externalController: widget.pinController,
      initialValue: widget.initialValue,
    );
  }

  @override
  void didUpdateWidget(PinInputFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller change using mixin
    if (widget.pinController != oldWidget.pinController) {
      reinitPinController(
        newExternalController: widget.pinController,
        oldExternalController: oldWidget.pinController,
        initialValue: widget.initialValue,
      );
    }

    // Handle initial value change
    if (widget.initialValue != oldWidget.initialValue) {
      setValue(widget.initialValue);
    }
  }

  @override
  void dispose() {
    disposePinController();
    super.dispose();
  }

  @override
  void reset() {
    effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }
}
