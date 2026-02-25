import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/haptics.dart';
import '../core/pin_controller_mixin.dart';
import '../core/pin_input.dart';
import '../core/pin_input_controller.dart';
import 'animations/error_shake.dart';
import 'layout/material_pin_row.dart';
import 'theme/material_pin_theme.dart';
import 'theme/material_pin_theme_extension.dart';

/// A ready-to-use Material Design PIN field.
///
/// This widget provides a complete, styled PIN input experience using
/// Material Design principles. It wraps [PinInput] with Material-styled
/// cells and animations.
///
/// Example:
/// ```dart
/// MaterialPinField(
///   length: 6,
///   onCompleted: (pin) => print('PIN: $pin'),
///   theme: MaterialPinTheme(
///     shape: MaterialPinShape.outlined,
///     cellSize: Size(56, 64),
///   ),
/// )
/// ```
class MaterialPinField extends StatefulWidget {
  const MaterialPinField({
    super.key,
    required this.length,
    this.theme,
    // Controller
    this.pinController,
    this.initialValue,
    // Input behavior
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.enableAutofill = false,
    this.autofillContextAction = AutofillContextAction.commit,
    // Behavior
    this.enabled = true,
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
    // Error display
    this.errorText,
    this.errorBuilder,
    this.errorTextStyle,
    // Accessibility
    this.semanticLabel,
  }) : assert(length > 0, 'Length must be greater than 0');

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

  /// Initial value for the PIN input.
  ///
  /// If provided, the PIN field will start with this value pre-filled.
  final String? initialValue;

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
  ///
  /// When enabled, the field will be wrapped in an [AutofillGroup] to support
  /// SMS OTP autofill and password managers.
  final bool enableAutofill;

  /// The action to take when the autofill context is disposed.
  ///
  /// - [AutofillContextAction.commit]: Save the autofilled data (default)
  /// - [AutofillContextAction.cancel]: Discard the autofilled data
  final AutofillContextAction autofillContextAction;

  /// Whether the field is enabled.
  ///
  /// When `false`, the field is visually grayed out and does not accept input.
  /// This is different from [readOnly], which prevents editing but maintains
  /// the normal visual appearance.
  final bool enabled;

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

  /// Custom widget to show when obscuring text.
  ///
  /// If provided, this widget will be displayed instead of the
  /// [MaterialPinTheme.obscuringCharacter] when [obscureText] is true.
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
  /// This callback is triggered when the field gains focus and the clipboard
  /// contains content that could be pasted. Use this to show a "Paste 123456?"
  /// prompt or auto-paste confirmation.
  ///
  /// See [PinInput.onClipboardFound] for more details.
  final ValueChanged<String>? onClipboardFound;

  /// Custom validator for clipboard content.
  ///
  /// If provided, this function is used instead of the default validation
  /// to determine if clipboard content should trigger [onClipboardFound].
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
  /// This can be used to dismiss the keyboard or trigger validation.
  /// See [PinInput.onTapOutside] for more details.
  final void Function(PointerDownEvent event)? onTapOutside;

  /// Hint character to show in empty cells.
  ///
  /// Overrides [MaterialPinTheme.hintCharacter] if provided.
  /// If [hintWidget] is provided, this is ignored.
  final String? hintCharacter;

  /// Custom widget to show in empty cells.
  ///
  /// When provided, this widget is displayed instead of [hintCharacter].
  final Widget? hintWidget;

  /// Style for hint character.
  ///
  /// Overrides [MaterialPinTheme.hintStyle] if provided.
  final TextStyle? hintStyle;

  /// Optional builder for separators between cells.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// How the cells should be aligned horizontally.
  ///
  /// Defaults to [MainAxisAlignment.center].
  final MainAxisAlignment mainAxisAlignment;

  /// How the cells should be aligned vertically.
  ///
  /// Defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// How much horizontal space the row of cells should occupy.
  ///
  /// Defaults to [MainAxisSize.min], which sizes the row to fit the cells.
  /// Use [MainAxisSize.max] to expand the row to fill available space.
  final MainAxisSize mainAxisSize;

  /// The mouse cursor to show when hovering over the widget.
  ///
  /// Defaults to [SystemMouseCursors.text] when enabled.
  final MouseCursor? mouseCursor;

  /// The brightness of the keyboard.
  final Brightness? keyboardAppearance;

  /// Padding when scrolling the field into view.
  final EdgeInsets scrollPadding;

  /// Error text to display below the PIN field.
  ///
  /// When provided along with [errorBuilder], the error widget will be displayed
  /// below the PIN cells. If only [errorText] is provided without [errorBuilder],
  /// a default error text widget is displayed.
  ///
  /// The error is only shown when [PinInputController.hasError] is true.
  final String? errorText;

  /// Custom builder for error display.
  ///
  /// When provided, this builder is used to create the error widget displayed
  /// below the PIN cells. The builder receives the [errorText] (which may be null).
  ///
  /// Example:
  /// ```dart
  /// MaterialPinField(
  ///   errorText: 'Invalid code',
  ///   errorBuilder: (errorText) => Row(
  ///     mainAxisSize: MainAxisSize.min,
  ///     children: [
  ///       Icon(Icons.error, color: Colors.red, size: 16),
  ///       SizedBox(width: 4),
  ///       Text(errorText ?? 'Error', style: TextStyle(color: Colors.red)),
  ///     ],
  ///   ),
  /// )
  /// ```
  final Widget Function(String? errorText)? errorBuilder;

  /// Text style for the default error text display.
  ///
  /// Only used when [errorText] is provided without [errorBuilder].
  /// If not specified, uses the theme's error color with body text style.
  final TextStyle? errorTextStyle;

  /// Semantic label for accessibility.
  ///
  /// This label is announced by screen readers to describe the PIN field.
  /// If not provided, a default label based on the field length is used
  /// (e.g., "6-digit PIN code field").
  ///
  /// Example:
  /// ```dart
  /// MaterialPinField(
  ///   length: 6,
  ///   semanticLabel: 'Enter verification code',
  ///   // ...
  /// )
  /// ```
  final String? semanticLabel;

  @override
  State<MaterialPinField> createState() => _MaterialPinFieldState();
}

class _MaterialPinFieldState extends State<MaterialPinField>
    with PinControllerMixin {
  final GlobalKey<ErrorShakeState> _shakeKey = GlobalKey<ErrorShakeState>();

  bool _previousHasError = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    // Use mixin for controller initialization
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
  void didUpdateWidget(MaterialPinField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller change using mixin
    if (widget.pinController != oldWidget.pinController) {
      reinitPinController(
        newExternalController: widget.pinController,
        oldExternalController: oldWidget.pinController,
        initialValue: widget.initialValue,
        onBeforeDispose: () {
          effectiveController.removeListener(_onControllerChanged);
        },
      );
      // Setup new controller
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
  Widget build(BuildContext context) {
    final theme = widget.theme ??
        Theme.of(context).materialPinTheme ??
        const MaterialPinTheme();
    final resolvedTheme = theme.resolve(context);
    final hasError = effectiveController.hasError;
    final showError =
        hasError && (widget.errorText != null || widget.errorBuilder != null);

    Widget pinInput = PinInput(
      length: widget.length,
      pinController: effectiveController,
      // Note: initialValue is handled by the mixin during controller init
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
      onChanged: widget.onChanged,
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

    // Wrap with error display if needed
    if (widget.errorBuilder != null || widget.errorText != null) {
      pinInput = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pinInput,
          // Error widget with animated visibility
          AnimatedSize(
            duration: resolvedTheme.animationDuration,
            curve: resolvedTheme.animationCurve,
            child: showError
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildErrorWidget(context, resolvedTheme),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
    }

    return ErrorShake(
      key: _shakeKey,
      duration: resolvedTheme.errorAnimationDuration,
      enabled: resolvedTheme.enableErrorShake,
      child: pinInput,
    );
  }

  Widget _buildErrorWidget(BuildContext context, MaterialPinThemeData theme) {
    // Use custom builder if provided
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(widget.errorText);
    }

    // Default error text display
    final errorStyle = widget.errorTextStyle ??
        Theme.of(context).textTheme.bodySmall?.copyWith(
              color: theme.errorColor,
            ) ??
        TextStyle(color: theme.errorColor, fontSize: 12);

    return Text(
      widget.errorText ?? '',
      style: errorStyle,
    );
  }
}
