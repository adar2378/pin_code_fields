import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'gestures/context_menu_builder.dart';
import 'gestures/selection_gesture_builder.dart';
import 'haptics.dart';
import 'input_capture/invisible_text_field.dart';
import 'pin_cell_data.dart';
import 'pin_controller_mixin.dart';
import 'pin_input_controller.dart';
import 'pin_input_scope.dart';

/// Builder function for custom PIN cell rendering.
typedef PinCellBuilder = Widget Function(
  BuildContext context,
  List<PinCellData> cells,
);

/// Builder function for custom semantic hint messages.
///
/// Receives the current filled count and total length to build
/// a dynamic accessibility hint.
typedef SemanticHintBuilder = String Function(
  int filledCount,
  int totalLength,
);

/// Headless PIN input widget.
///
/// This widget captures keyboard input and manages PIN state but delegates
/// ALL visual rendering to the provided [builder]. You decide exactly how
/// each cell should look - this widget just provides the data.
///
/// Example:
/// ```dart
/// PinInput(
///   length: 6,
///   builder: (context, cells) {
///     return Row(
///       children: cells.map((cell) => MyCustomCell(data: cell)).toList(),
///     );
///   },
///   onCompleted: (pin) => print('PIN: $pin'),
/// )
/// ```
class PinInput extends StatefulWidget {
  const PinInput({
    super.key,
    required this.length,
    required this.builder,
    // Controller
    this.pinController,
    this.initialValue,
    // Input behavior
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    // Behavior
    this.enabled = true,
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
    this.contextMenuBuilder = defaultPinContextMenuBuilder,
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
    // Semantics
    this.semanticLabel,
    this.semanticHintBuilder,
  })  : assert(length > 0, 'Length must be greater than 0'),
        assert(
          obscuringCharacter.length > 0,
          'Obscuring character must not be empty',
        );

  /// Number of PIN cells.
  final int length;

  /// Builder that receives cell data and returns the visual representation.
  ///
  /// This is where YOU decide how to render each cell. The builder receives
  /// a list of [PinCellData] objects containing all the state information
  /// needed to render each cell.
  final PinCellBuilder builder;

  /// Controller for the PIN input.
  ///
  /// Provides programmatic access to text, error state, and focus.
  /// If not provided, an internal controller will be created and managed.
  final PinInputController? pinController;

  /// Initial value for the PIN input.
  ///
  /// If provided, the PIN field will start with this value pre-filled.
  /// This is a convenience parameter - you can also set initial value
  /// via the controller: `PinInputController(text: '1234')`.
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

  /// Whether the field is enabled.
  ///
  /// When `false`, the field is visually grayed out and does not accept input.
  /// This is different from [readOnly], which prevents editing but maintains
  /// the normal visual appearance.
  ///
  /// Flutter convention:
  /// - `enabled: false` - grayed out, no interaction
  /// - `readOnly: true` - looks normal, but can't edit
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
  /// This callback is triggered when the field gains focus and the clipboard
  /// contains content that could be pasted. By default, content is considered
  /// valid if it:
  /// - Has the same length as the PIN field
  /// - Contains only digits (when [keyboardType] is [TextInputType.number])
  ///
  /// Use this to show a "Paste 123456?" prompt or auto-paste confirmation.
  ///
  /// Example:
  /// ```dart
  /// PinInput(
  ///   length: 6,
  ///   onClipboardFound: (text) {
  ///     showDialog(
  ///       context: context,
  ///       builder: (context) => AlertDialog(
  ///         title: Text('Paste code?'),
  ///         content: Text('Found: $text'),
  ///         actions: [
  ///           TextButton(
  ///             onPressed: () => Navigator.pop(context),
  ///             child: Text('Cancel'),
  ///           ),
  ///           TextButton(
  ///             onPressed: () {
  ///               controller.text = text;
  ///               Navigator.pop(context);
  ///             },
  ///             child: Text('Paste'),
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   },
  /// )
  /// ```
  final ValueChanged<String>? onClipboardFound;

  /// Custom validator for clipboard content.
  ///
  /// If provided, this function is used instead of the default validation
  /// to determine if clipboard content should trigger [onClipboardFound].
  ///
  /// Return `true` if the content is valid and should trigger the callback.
  ///
  /// Example:
  /// ```dart
  /// PinInput(
  ///   length: 6,
  ///   clipboardValidator: (text, length) {
  ///     // Accept any 6-character alphanumeric code
  ///     return text.length == length &&
  ///            RegExp(r'^[A-Z0-9]+$').hasMatch(text);
  ///   },
  ///   onClipboardFound: (text) => print('Found: $text'),
  /// )
  /// ```
  final bool Function(String text, int length)? clipboardValidator;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the PIN is complete (all cells filled).
  final ValueChanged<String>? onCompleted;

  /// Called when the user submits (keyboard action button).
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
  ///
  /// Example:
  /// ```dart
  /// PinInput(
  ///   length: 6,
  ///   onTapOutside: (event) {
  ///     FocusScope.of(context).unfocus();
  ///   },
  /// )
  /// ```
  final void Function(PointerDownEvent event)? onTapOutside;

  /// The mouse cursor to show when hovering over the widget.
  ///
  /// Defaults to [SystemMouseCursors.text] when enabled.
  final MouseCursor? mouseCursor;

  /// The brightness of the keyboard.
  final Brightness? keyboardAppearance;

  /// Padding when scrolling the field into view.
  final EdgeInsets scrollPadding;

  /// Whether to enable autofill (e.g., SMS OTP autofill).
  ///
  /// When enabled, the system may automatically fill in OTP codes
  /// received via SMS or suggest saved PINs/passwords.
  final bool enableAutofill;

  /// Action to perform when the autofill context is disposed.
  ///
  /// - [AutofillContextAction.commit]: Tell the system to save the data
  ///   (useful for password managers to save PINs/passwords)
  /// - [AutofillContextAction.cancel]: Tell the system to discard the data
  ///   (appropriate for one-time codes like OTP)
  final AutofillContextAction autofillContextAction;

  /// Semantic label for accessibility.
  ///
  /// This label is announced by screen readers to describe the PIN field.
  /// If not provided, a default label based on the field length is used.
  ///
  /// Example:
  /// ```dart
  /// PinInput(
  ///   length: 6,
  ///   semanticLabel: 'Enter 6-digit verification code',
  ///   // ...
  /// )
  /// ```
  final String? semanticLabel;

  /// Builder for custom semantic hint messages.
  ///
  /// This allows customization of the accessibility hint announced by screen
  /// readers, which is useful for:
  /// - **Localization**: Translate hints to different languages
  /// - **Custom terminology**: Use "characters" instead of "digits"
  /// - **Context-specific guidance**: Provide custom instructions
  ///
  /// The builder receives:
  /// - `filledCount`: Number of cells currently filled
  /// - `totalLength`: Total number of cells in the PIN field
  ///
  /// If not provided, defaults to English hints like:
  /// - "Enter 3 more digits" (when incomplete)
  /// - "PIN complete" (when filled)
  ///
  /// Example - Localization:
  /// ```dart
  /// PinInput(
  ///   length: 6,
  ///   semanticHintBuilder: (filled, total) {
  ///     final remaining = total - filled;
  ///     return remaining > 0
  ///         ? 'Introduzca $remaining ${remaining == 1 ? 'dígito' : 'dígitos'} más'
  ///         : 'PIN completo';
  ///   },
  /// )
  /// ```
  ///
  /// Example - Custom terminology:
  /// ```dart
  /// PinInput(
  ///   length: 4,
  ///   semanticHintBuilder: (filled, total) {
  ///     final remaining = total - filled;
  ///     return remaining > 0
  ///         ? 'Enter $remaining more ${remaining == 1 ? 'character' : 'characters'}'
  ///         : 'Code complete';
  ///   },
  /// )
  /// ```
  ///
  /// Example - Static hint:
  /// ```dart
  /// PinInput(
  ///   length: 6,
  ///   semanticHintBuilder: (_, __) => 'Enter your security code',
  /// )
  /// ```
  final SemanticHintBuilder? semanticHintBuilder;

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput>
    with TickerProviderStateMixin, PinControllerMixin
    implements TextSelectionGestureDetectorBuilderDelegate {
  // Constants
  static const _fallbackFocusDelay = Duration(milliseconds: 50);

  // Gesture handling
  late TextSelectionGestureDetectorBuilder _gestureBuilder;

  // Delegate properties
  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled =>
      widget.enabled && widget.enablePaste && !widget.readOnly;

  @override
  bool get forcePressEnabled => false;

  // State
  bool _isError = false;
  int _previousLength = 0;
  final Set<int> _justEnteredIndices = {};
  final Set<int> _justRemovedIndices = {};

  // Blink effect
  Timer? _blinkTimer;
  bool _isBlinking = false;

  // Convenience getters for underlying text controller and focus node
  TextEditingController get _textController =>
      effectiveController.textController;
  FocusNode get _focusNode => effectiveController.focusNode;

  @override
  void initState() {
    super.initState();
    _initPinController();
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    _gestureBuilder = TextSelectionGestureDetectorBuilder(delegate: this);
    _handleAutoFocus();
  }

  void _initPinController() {
    // 1. Create or assign controller (mixin handles ownership and initial value)
    initPinController(
      externalController: widget.pinController,
      initialValue: widget.initialValue,
    );

    // 2. Setup listeners for error sync and text changes
    _attachControllerListeners();

    // 3. Validate and correct initial text if needed
    _validateInitialText();

    // 4. Initialize length tracking
    _previousLength = _textController.text.length;
  }

  /// Attaches listeners to the controller for error state synchronization.
  void _attachControllerListeners() {
    effectiveController.attach(onErrorTriggered: _triggerErrorAnimation);
    effectiveController.addListener(_onPinControllerChanged);
  }

  /// Detaches listeners from the controller.
  void _detachControllerListeners() {
    effectiveController.removeListener(_onPinControllerChanged);
    effectiveController.detach();
  }

  /// Validates that initial text doesn't exceed the PIN length.
  void _validateInitialText() {
    final currentText = _textController.text;
    final limitedText = _getLimitedText(currentText);

    if (limitedText != currentText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _textController.text = limitedText;
        }
      });
    }
  }

  void _onPinControllerChanged() {
    if (mounted) {
      // Sync error state from controller
      final controllerHasError = effectiveController.hasError;
      if (_isError != controllerHasError) {
        setState(() => _isError = controllerHasError);
      }
    }
  }

  void _triggerErrorAnimation() {
    if (mounted) {
      setState(() => _isError = true);
    }
  }

  void _handleAutoFocus() {
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_focusNode.hasFocus) {
          _requestFocusSafely();
        }
      });
    }

    // Set initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _textController.selection = TextSelection.collapsed(
          offset: _textController.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant PinInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Pin controller change
    if (widget.pinController != oldWidget.pinController) {
      // Use mixin's reinit with cleanup callback
      reinitPinController(
        newExternalController: widget.pinController,
        oldExternalController: oldWidget.pinController,
        initialValue: widget.initialValue,
        onBeforeDispose: () {
          _textController.removeListener(_onTextChanged);
          _focusNode.removeListener(_onFocusChanged);
          _detachControllerListeners();
        },
      );

      // Setup new controller
      _attachControllerListeners();
      _textController.addListener(_onTextChanged);
      _focusNode.addListener(_onFocusChanged);
    }

    // Length change
    if (widget.length != oldWidget.length) {
      _onTextChanged();
    }
  }

  @override
  void dispose() {
    _detachControllerListeners();
    _blinkTimer?.cancel();
    _textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    disposePinController();
    super.dispose();
  }

  void _requestFocusSafely() {
    if (mounted && _focusNode.context != null) {
      FocusScope.of(context).requestFocus(_focusNode);
    } else if (mounted) {
      Future.delayed(_fallbackFocusDelay, () {
        if (mounted && _focusNode.context != null) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      });
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      editableTextKey.currentState?.hideToolbar();
    } else {
      // Defer clipboard check to avoid running during the synchronous
      // focus-change callback. This prevents blocking the UI thread when
      // iOS delays clipboard access (e.g. after app-resume / biometric).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNode.hasFocus) {
          _checkClipboard();
        }
      });
    }
    if (mounted) setState(() {});
  }

  // ------------------------------------------------------------------
  // Safe clipboard access
  // ------------------------------------------------------------------

  /// Maximum time to wait for a native clipboard response before giving up.
  /// On iOS the system clipboard prompt can stall the main thread; capping
  /// the wait prevents Sentry-reported App Hangs.
  static const _clipboardTimeout = Duration(milliseconds: 500);

  /// Reads the clipboard with a timeout guard.
  ///
  /// Returns the plain-text content, or `null` if the read fails, times out,
  /// or yields empty data. Never throws.
  Future<String?> _safeClipboardRead() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain)
          .timeout(
            _clipboardTimeout,
            onTimeout: () => null,
          );
      final text = clipboardData?.text;
      return (text != null && text.isNotEmpty) ? text : null;
    } catch (_) {
      // Clipboard access may fail on some platforms; silently ignore.
      return null;
    }
  }

  // ------------------------------------------------------------------
  // Paste action (user-initiated from context menu)
  // ------------------------------------------------------------------

  Future<void> _handlePasteAction(EditableTextState editableTextState) async {
    editableTextState.hideToolbar();

    final clipboardText = await _safeClipboardRead();
    if (clipboardText == null) return;

    // Respect user-provided clipboard validation for paste acceptance.
    if (widget.clipboardValidator != null &&
        !widget.clipboardValidator!(clipboardText, widget.length)) {
      return;
    }

    final limitedText = _getLimitedText(clipboardText);
    if (limitedText.isEmpty) return;

    if (!mounted) return;
    _textController.value = TextEditingValue(
      text: limitedText,
      selection: TextSelection.collapsed(offset: limitedText.length),
    );
  }

  Widget _buildDeferredPasteMenu(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: [
        ContextMenuButtonItem(
          type: ContextMenuButtonType.paste,
          onPressed: () => _handlePasteAction(editableTextState),
        ),
      ],
    );
  }

  EditableTextContextMenuBuilder? _resolveContextMenuBuilder() {
    if (!selectionEnabled) return null;
    if (identical(widget.contextMenuBuilder, defaultPinContextMenuBuilder)) {
      // Avoid eager clipboard reads in default long-press flow on iOS.
      return _buildDeferredPasteMenu;
    }
    return widget.contextMenuBuilder;
  }

  // ------------------------------------------------------------------
  // Clipboard probing (auto-detect on focus)
  // ------------------------------------------------------------------

  /// Checks the clipboard for valid PIN content and triggers callback if found.
  ///
  /// Called after focus is gained. The read is guarded by [_safeClipboardRead]
  /// so a slow or blocked clipboard never hangs the UI.
  Future<void> _checkClipboard() async {
    if (widget.onClipboardFound == null) return;

    final text = await _safeClipboardRead();
    if (text == null) return;

    final isValid = _validateClipboardContent(text);
    if (isValid && mounted) {
      widget.onClipboardFound?.call(text);
    }
  }

  /// Validates clipboard content for PIN suitability.
  bool _validateClipboardContent(String text) {
    // Use custom validator if provided
    if (widget.clipboardValidator != null) {
      return widget.clipboardValidator!(text, widget.length);
    }

    // Default validation
    // 1. Check length matches
    if (text.length != widget.length) return false;

    // 2. If numeric keyboard, check for digits only
    if (widget.keyboardType == TextInputType.number) {
      return RegExp(r'^[0-9]+$').hasMatch(text);
    }

    // 3. For other keyboard types, accept any text of correct length
    return true;
  }

  void _onTextChanged() {
    if (!mounted) return;

    // Haptic feedback
    if (widget.enableHapticFeedback) {
      triggerHaptic(widget.hapticFeedbackType);
    }

    // Clear error on input (if enabled)
    if (_isError && widget.clearErrorOnInput) {
      _isError = false;
      effectiveController.setErrorState(false);
      setState(() {});
    }

    final currentText = _textController.text;
    final limitedText = _getLimitedText(currentText);

    // Correct text if needed
    if (currentText != limitedText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _textController.value = TextEditingValue(
            text: limitedText,
            selection: TextSelection.collapsed(offset: limitedText.length),
          );
        }
      });
      return;
    }

    final currentLength = limitedText.length;

    // Track transition signals
    _updateTransitionSignals(currentLength);

    // Callbacks
    widget.onChanged?.call(limitedText);

    // Completion check
    if (currentLength == widget.length && _previousLength < widget.length) {
      widget.onCompleted?.call(limitedText);
      if (widget.autoDismissKeyboard) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }

    _previousLength = currentLength;

    // Blink effect
    _handleBlinkEffect();

    setState(() {});
  }

  void _updateTransitionSignals(int currentLength) {
    _justEnteredIndices.clear();
    _justRemovedIndices.clear();

    if (currentLength > _previousLength) {
      // Characters were entered
      for (int i = _previousLength; i < currentLength; i++) {
        _justEnteredIndices.add(i);
      }
    } else if (currentLength < _previousLength) {
      // Characters were removed
      for (int i = currentLength; i < _previousLength; i++) {
        _justRemovedIndices.add(i);
      }
    }

    // Clear transition signals after one frame
    if (_justEnteredIndices.isNotEmpty || _justRemovedIndices.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _justEnteredIndices.clear();
            _justRemovedIndices.clear();
          });
        }
      });
    }
  }

  void _handleBlinkEffect() {
    if (!widget.obscureText || !widget.blinkWhenObscuring) return;

    _blinkTimer?.cancel();
    _isBlinking = true;

    _blinkTimer = Timer(widget.blinkDuration, () {
      if (mounted) {
        setState(() => _isBlinking = false);
      }
    });
  }

  String _getLimitedText(String text) {
    String filteredText = text;
    if (widget.keyboardType == TextInputType.number) {
      filteredText = text.replaceAll(RegExp(r'[^0-9]'), '');
    }
    return filteredText.length > widget.length
        ? filteredText.substring(0, widget.length)
        : filteredText;
  }

  void _handleSelectionChanged(
    TextSelection selection,
    SelectionChangedCause? cause,
  ) {
    if (widget.readOnly) return;
    // Force selection to end
    if (_textController.selection.baseOffset != _textController.text.length ||
        _textController.selection.extentOffset != _textController.text.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _textController.selection = TextSelection.collapsed(
            offset: _textController.text.length,
          );
        }
      });
    }
  }

  List<PinCellData> _buildCells() {
    final text = _textController.text;
    final cells = <PinCellData>[];
    final isComplete = text.length == widget.length;
    // When complete, focus the last cell; otherwise focus the next empty cell
    final focusedIndex = isComplete ? text.length - 1 : text.length;

    for (int i = 0; i < widget.length; i++) {
      final isFilled = i < text.length;
      final isFocused = _focusNode.hasFocus && i == focusedIndex;
      final isLastEntered = i == text.length - 1 && text.isNotEmpty;
      final isFollowing = i > focusedIndex;

      cells.add(PinCellData(
        index: i,
        character: isFilled ? text[i] : null,
        isFilled: isFilled,
        isFocused: isFocused,
        isError: _isError,
        isDisabled: !widget.enabled,
        isFollowing: isFollowing,
        isComplete: isComplete,
        wasJustEntered: _justEnteredIndices.contains(i),
        wasJustRemoved: _justRemovedIndices.contains(i),
        isBlinking: widget.obscureText &&
            widget.blinkWhenObscuring &&
            isLastEntered &&
            _isBlinking,
      ));
    }

    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells();
    final selectionControls = widget.selectionControls ??
        (selectionEnabled ? getDefaultSelectionControls(context) : null);

    Widget content = MouseRegion(
      cursor: widget.mouseCursor ??
          (widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic),
      child: GestureDetector(
        onTap: () {
          if (widget.enabled && !_focusNode.hasFocus && !widget.readOnly) {
            _requestFocusSafely();
          }
          widget.onTap?.call();
        },
        onLongPress: widget.onLongPress,
        child: _gestureBuilder.buildGestureDetector(
          behavior: HitTestBehavior.translucent,
          child: PinInputScope(
            cells: cells,
            obscureText: widget.obscureText,
            obscuringCharacter: widget.obscuringCharacter,
            hasFocus: _focusNode.hasFocus,
            requestFocus: _requestFocusSafely,
            child: Stack(
              children: [
                // User's custom UI
                widget.builder(context, cells),

                // Invisible input layer - positioned at top so auto-scroll
                // shows the full PIN field above the keyboard
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InvisibleTextField(
                    editableTextKey: editableTextKey,
                    controller: _textController,
                    focusNode: _focusNode,
                    length: widget.length,
                    readOnly: widget.readOnly,
                    selectionEnabled: selectionEnabled,
                    selectionControls: selectionControls,
                    contextMenuBuilder: _resolveContextMenuBuilder(),
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    textCapitalization: widget.textCapitalization,
                    textInputAction: widget.textInputAction,
                    onSubmitted: widget.onSubmitted,
                    onEditingComplete: widget.onEditingComplete,
                    onSelectionChanged: _handleSelectionChanged,
                    keyboardAppearance: widget.keyboardAppearance,
                    scrollPadding: widget.scrollPadding,
                    autofillHints:
                        widget.enableAutofill ? widget.autofillHints : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Wrap with AutofillGroup if autofill is enabled
    if (widget.enableAutofill) {
      content = AutofillGroup(
        onDisposeAction: widget.autofillContextAction,
        child: content,
      );
    }

    // Wrap with TapRegion if onTapOutside is provided
    if (widget.onTapOutside != null) {
      content = TapRegion(
        onTapOutside: widget.onTapOutside,
        child: content,
      );
    }

    // Wrap with Semantics for accessibility
    final currentText = _textController.text;
    final filledCount = currentText.length;
    final semanticValue = widget.obscureText
        ? '●' * filledCount // Don't reveal obscured text
        : currentText;

    // Suppress hint when disabled so the platform can announce "dimmed" unobstructed.
    final semanticHint = widget.enabled
        ? (widget.semanticHintBuilder?.call(filledCount, widget.length) ??
            (filledCount < widget.length
                ? 'Enter ${widget.length - filledCount} more ${widget.length - filledCount == 1 ? 'digit' : 'digits'}'
                : 'PIN complete'))
        : null;

    return Semantics(
      label: widget.semanticLabel ?? '${widget.length}-digit PIN code field',
      value: semanticValue.isNotEmpty ? semanticValue : null,
      hint: semanticHint,
      textField: true,
      enabled: widget.enabled,
      focused: widget.enabled && _focusNode.hasFocus,
      obscured: widget.obscureText,
      child: content,
    );
  }
}
