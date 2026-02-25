import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/haptics.dart';
import '../../core/pin_controller_mixin.dart';
import '../../core/pin_input.dart';
import '../../core/pin_input_controller.dart';
import '../animations/error_shake.dart';
import '../layout/material_pin_row.dart';
import '../theme/material_pin_theme.dart';
import '../theme/material_pin_theme_extension.dart';

/// A Material Design PIN field with [Form] integration.
///
/// This widget combines the styling of [MaterialPinField] with the form
/// validation capabilities of [FormField]. It supports both controller-driven
/// error states (shake animation) and form validation errors (error text below).
///
/// ## Dual Error States
///
/// 1. **Controller error** — triggered via `controller.triggerError()`, produces
///    a shake animation on the field.
/// 2. **Form validation error** — triggered by form validation, displays error
///    text below the field.
///
/// Both error states coexist independently.
///
/// Example:
/// ```dart
/// final formKey = GlobalKey<FormState>();
/// final controller = PinInputController();
///
/// Form(
///   key: formKey,
///   child: MaterialPinFormField(
///     length: 6,
///     pinController: controller,
///     theme: MaterialPinTheme(
///       shape: MaterialPinShape.outlined,
///     ),
///     validator: (value) {
///       if (value == null || value.length < 6) {
///         return 'Please enter all 6 digits';
///       }
///       return null;
///     },
///     onCompleted: (pin) {
///       if (!formKey.currentState!.validate()) {
///         controller.triggerError(); // Shake animation
///       }
///     },
///   ),
/// )
/// ```
class MaterialPinFormField extends FormField<String> {
  MaterialPinFormField({
    super.key,
    required this.length,
    this.theme,
    // Controller
    this.pinController,
    super.initialValue,
    // Input behavior
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.enableAutofill = false,
    this.autofillContextAction = AutofillContextAction.commit,
    // Behavior
    super.enabled,
    this.autoFocus = false,
    this.readOnly = false,
    this.autoDismissKeyboard = true,
    this.clearErrorOnInput = true,
    this.obscureText = false,
    this.obscuringWidget,
    this.blinkWhenObscuring = true,
    this.blinkDuration = const Duration(milliseconds: 500),
    // Haptics
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = HapticFeedbackType.light,
    // Gestures
    this.enablePaste = true,
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
    // Hint (overrides theme)
    this.hintCharacter,
    this.hintWidget,
    this.hintStyle,
    // Layout
    this.separatorBuilder,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    // Cursor
    this.mouseCursor,
    // Keyboard
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20),
    // Accessibility
    this.semanticLabel,
    // Form field
    super.validator,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.restorationId,
    // Form error display
    this.formErrorStyle,
    this.formErrorSpace = 8.0,
  })  : assert(length > 0, 'Length must be greater than 0'),
        super(
          builder: (FormFieldState<String> field) {
            final state = field as _MaterialPinFormFieldState;
            return state._buildContent(field.context);
          },
        );

  /// Number of PIN cells.
  final int length;

  /// Theme configuration for the PIN field.
  ///
  /// If null, the theme will be resolved from [ThemeData.extensions] using
  /// [MaterialPinThemeExtension], or fall back to `const MaterialPinTheme()`.
  final MaterialPinTheme? theme;

  /// Controller for the PIN input.
  ///
  /// Provides programmatic access to text, error state, and focus.
  /// If not provided, an internal controller is created.
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

  /// Whether to enable autofill functionality.
  final bool enableAutofill;

  /// The action to take when the autofill context is disposed.
  final AutofillContextAction autofillContextAction;

  /// Whether to auto-focus on mount.
  final bool autoFocus;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether to dismiss the keyboard when PIN is complete.
  final bool autoDismissKeyboard;

  /// Whether to automatically clear error state when user types.
  final bool clearErrorOnInput;

  /// Whether to obscure the entered text.
  final bool obscureText;

  /// Custom widget to show when obscuring text.
  final Widget? obscuringWidget;

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

  /// Hint character to show in empty cells.
  final String? hintCharacter;

  /// Custom widget to show in empty cells.
  final Widget? hintWidget;

  /// Style for hint character.
  final TextStyle? hintStyle;

  /// Optional builder for separators between cells.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// How the cells should be aligned horizontally.
  final MainAxisAlignment mainAxisAlignment;

  /// How the cells should be aligned vertically.
  final CrossAxisAlignment crossAxisAlignment;

  /// How much horizontal space the row of cells should occupy.
  ///
  /// Defaults to [MainAxisSize.min], which sizes the row to fit the cells.
  /// Use [MainAxisSize.max] to expand the row to fill available space.
  final MainAxisSize mainAxisSize;

  /// The mouse cursor to show when hovering over the widget.
  final MouseCursor? mouseCursor;

  /// The brightness of the keyboard.
  final Brightness? keyboardAppearance;

  /// Padding when scrolling the field into view.
  final EdgeInsets scrollPadding;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Style for form validation error text displayed below the field.
  ///
  /// If not specified, uses the theme's error color with body text style.
  final TextStyle? formErrorStyle;

  /// Space between PIN field and form validation error text.
  ///
  /// Defaults to 8.0.
  final double formErrorSpace;

  @override
  FormFieldState<String> createState() => _MaterialPinFormFieldState();
}

class _MaterialPinFormFieldState extends FormFieldState<String>
    with PinControllerMixin {
  final GlobalKey<ErrorShakeState> _shakeKey = GlobalKey<ErrorShakeState>();

  bool _previousHasError = false;

  @override
  MaterialPinFormField get widget => super.widget as MaterialPinFormField;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    initPinController(
      externalController: widget.pinController,
      initialValue: widget.initialValue,
    );
    effectiveController.addListener(_onControllerChanged);
    _previousHasError = effectiveController.hasError;
  }

  void _onControllerChanged() {
    // Trigger shake when error state transitions from false to true
    final currentHasError = effectiveController.hasError;
    if (currentHasError && !_previousHasError) {
      _shakeKey.currentState?.shake();
    }
    _previousHasError = currentHasError;
  }

  @override
  void didUpdateWidget(MaterialPinFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.pinController != oldWidget.pinController) {
      reinitPinController(
        newExternalController: widget.pinController,
        oldExternalController: oldWidget.pinController,
        initialValue: widget.initialValue,
        onBeforeDispose: () {
          effectiveController.removeListener(_onControllerChanged);
        },
      );
      effectiveController.addListener(_onControllerChanged);
      _previousHasError = effectiveController.hasError;
    }
  }

  @override
  void dispose() {
    effectiveController.removeListener(_onControllerChanged);
    disposePinController();
    super.dispose();
  }

  @override
  void reset() {
    effectiveController.text = widget.initialValue ?? '';
    effectiveController.clearError();
    super.reset();
  }

  Widget _buildContent(BuildContext context) {
    final theme = widget.theme ??
        Theme.of(context).materialPinTheme ??
        const MaterialPinTheme();
    final resolvedTheme = theme.resolve(context);

    Widget pinInput = PinInput(
      length: widget.length,
      pinController: effectiveController,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      autofillHints: widget.autofillHints,
      enableAutofill: widget.enableAutofill,
      autofillContextAction: widget.autofillContextAction,
      enabled: widget.enabled,
      autoFocus: widget.autoFocus,
      readOnly: widget.readOnly,
      autoDismissKeyboard: widget.autoDismissKeyboard,
      clearErrorOnInput: widget.clearErrorOnInput,
      obscureText: widget.obscureText,
      obscuringCharacter: resolvedTheme.obscuringCharacter,
      blinkWhenObscuring: widget.blinkWhenObscuring,
      blinkDuration: widget.blinkDuration,
      enableHapticFeedback: widget.enableHapticFeedback,
      hapticFeedbackType: widget.hapticFeedbackType,
      enablePaste: widget.enablePaste,
      onClipboardFound: widget.onClipboardFound,
      clipboardValidator: widget.clipboardValidator,
      onChanged: (value) {
        didChange(value);
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
      semanticLabel: widget.semanticLabel,
      builder: (context, cells) {
        return MaterialPinRow(
          cells: cells,
          theme: resolvedTheme,
          obscureText: widget.obscureText,
          obscuringWidget: widget.obscuringWidget,
          hintCharacter: widget.hintCharacter,
          hintWidget: widget.hintWidget,
          hintStyle: widget.hintStyle,
          separatorBuilder: widget.separatorBuilder,
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
        );
      },
    );

    // Wrap with form error display
    pinInput = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        pinInput,
        AnimatedSize(
          duration: resolvedTheme.animationDuration,
          curve: resolvedTheme.animationCurve,
          child: hasError
              ? Padding(
                  padding: EdgeInsets.only(top: widget.formErrorSpace),
                  child: _buildFormError(context, resolvedTheme),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );

    return ErrorShake(
      key: _shakeKey,
      duration: resolvedTheme.errorAnimationDuration,
      enabled: resolvedTheme.enableErrorShake,
      child: pinInput,
    );
  }

  Widget _buildFormError(BuildContext context, MaterialPinThemeData theme) {
    final errorStyle = widget.formErrorStyle ??
        Theme.of(context).textTheme.bodySmall?.copyWith(
              color: theme.errorColor,
            ) ??
        TextStyle(color: theme.errorColor, fontSize: 12);

    return Text(
      errorText ?? '',
      style: errorStyle,
    );
  }
}
