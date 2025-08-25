part of pin_code_fields;

enum PinCodeFieldShape { box, underline, circle }

enum ErrorAnimationType { shake, clear }

class PinCodeTextField extends StatefulWidget {
  final BuildContext appContext;
  final List<BoxShadow>? boxShadows;
  final int length;
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? obscuringWidget;
  final bool useHapticFeedback;
  final HapticFeedbackTypes hapticFeedbackTypes;
  final bool blinkWhenObscuring;
  final Duration blinkDuration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextStyle? textStyle;
  final TextStyle? pastedTextStyle;
  final Color? backgroundColor;
  final MainAxisAlignment mainAxisAlignment;
  final AnimationType animationType;
  final Duration animationDuration;
  final Curve animationCurve;
  final TextInputType keyboardType;
  final bool autoFocus;
  final FocusNode? focusNode;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final TextEditingController? controller;
  final bool enableActiveFill;
  final bool autoDismissKeyboard;
  final bool autoDisposeControllers;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final StreamController<ErrorAnimationType>? errorAnimationController;
  final bool Function(String? text)? beforeTextPaste;
  final Function? onTap;
  final bool showPasteConfirmationDialog;
  final DialogConfig? dialogConfig;
  final PinTheme pinTheme;
  final Brightness? keyboardAppearance;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final AutovalidateMode autovalidateMode;
  final double errorTextSpace;
  final EdgeInsets errorTextMargin;
  final TextDirection errorTextDirection;
  final bool enablePinAutofill;
  final int errorAnimationDuration;
  final bool showCursor;
  final Color? cursorColor;
  final double cursorWidth;
  final double? cursorHeight;
  final AutofillContextAction onAutoFillDisposeAction;
  final bool useExternalAutoFillGroup;
  final String? hintCharacter;
  final TextStyle? hintStyle;
  final EdgeInsets scrollPadding;
  final Gradient? textGradient;
  final bool readOnly;
  final bool autoUnfocus;
  final IndexedWidgetBuilder? separatorBuilder;
  final TextStyle? errorTextStyle;
  final OutlineInputBorder? focusedErrorBorder;
  final OutlineInputBorder? errorBorder;

  PinCodeTextField(
      {Key? key,
      required this.appContext,
      required this.length,
      this.controller,
      this.obscureText = false,
      this.obscuringCharacter = '●',
      this.obscuringWidget,
      this.blinkWhenObscuring = false,
      this.blinkDuration = const Duration(milliseconds: 500),
      this.onChanged,
      this.onCompleted,
      this.backgroundColor,
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
      this.animationDuration = const Duration(milliseconds: 150),
      this.animationCurve = Curves.easeInOut,
      this.animationType = AnimationType.slide,
      this.keyboardType = TextInputType.visiblePassword,
      this.autoFocus = false,
      this.focusNode,
      this.onTap,
      this.enabled = true,
      this.inputFormatters = const <TextInputFormatter>[],
      this.textStyle,
      this.useHapticFeedback = false,
      this.hapticFeedbackTypes = HapticFeedbackTypes.light,
      this.pastedTextStyle,
      this.enableActiveFill = false,
      this.textCapitalization = TextCapitalization.none,
      this.textInputAction = TextInputAction.done,
      this.autoDismissKeyboard = true,
      this.autoDisposeControllers = true,
      this.onSubmitted,
      this.onEditingComplete,
      this.errorAnimationController,
      this.beforeTextPaste,
      this.showPasteConfirmationDialog = true,
      this.dialogConfig,
      this.pinTheme = const PinTheme.defaults(),
      this.keyboardAppearance,
      this.validator,
      this.onSaved,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.errorTextSpace = 16,
      this.errorTextDirection = TextDirection.ltr,
      this.errorTextMargin = EdgeInsets.zero,
      this.enablePinAutofill = true,
      this.errorAnimationDuration = 500,
      this.boxShadows,
      this.showCursor = true,
      this.cursorColor,
      this.cursorWidth = 2,
      this.cursorHeight,
      this.hintCharacter,
      this.hintStyle,
      this.textGradient,
      this.readOnly = false,
      this.autoUnfocus = true,
      this.errorTextStyle,
      this.focusedErrorBorder,
      this.errorBorder,
      this.onAutoFillDisposeAction = AutofillContextAction.commit,
      this.useExternalAutoFillGroup = false,
      this.scrollPadding = const EdgeInsets.all(20),
      this.separatorBuilder})
      : assert(obscuringCharacter.isNotEmpty),
        super(key: key);

  @override
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<PinCodeTextField>
    with TickerProviderStateMixin {
  TextEditingController? _textEditingController;
  FocusNode? _focusNode;
  late List<String> _inputList;
  int _selectedIndex = 0;
  BorderRadius? borderRadius;

  // Whether the character has blinked
  bool _hasBlinked = false;

  // AnimationController for the error animation
  late AnimationController _controller;

  late AnimationController _cursorController;

  StreamSubscription<ErrorAnimationType>? _errorAnimationSubscription;
  bool isInErrorMode = false;

  // Animation for the error animation
  late Animation<Offset> _offsetAnimation;

  late Animation<double> _cursorAnimation;
  DialogConfig get _dialogConfig => widget.dialogConfig == null
      ? DialogConfig()
      : DialogConfig(
          affirmativeText: widget.dialogConfig!.affirmativeText,
          dialogContent: widget.dialogConfig!.dialogContent,
          dialogTitle: widget.dialogConfig!.dialogTitle,
          negativeText: widget.dialogConfig!.negativeText,
          platform: widget.dialogConfig!.platform,
        );
  PinTheme get _pinTheme => widget.pinTheme;

  Timer? _blinkDebounce;

  TextStyle get _textStyle => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ).merge(widget.textStyle);

  TextStyle get _hintStyle => _textStyle
      .copyWith(
        color: _pinTheme.disabledColor,
      )
      .merge(widget.hintStyle);

  bool get _hintAvailable => widget.hintCharacter != null;

  @override
  void initState() {
    super.initState();
    // if (!kReleaseMode) {
    //   print(
    //       "IF YOU WANT TO USE COLOR FILL FOR EACH CELL THEN SET enableActiveFill = true");
    // }

    _checkForInvalidValues();
    _assignController();
    if (_pinTheme.shape != PinCodeFieldShape.circle &&
        _pinTheme.shape != PinCodeFieldShape.underline) {
      borderRadius = _pinTheme.borderRadius;
    }
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode!.addListener(() {
      _setState(() {});
    }); // Rebuilds on every change to reflect the correct color on each field.
    _inputList = List<String>.filled(widget.length, "");

    _hasBlinked = true;

    _cursorController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _cursorAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _cursorController,
      curve: Curves.easeIn,
    ));
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.errorAnimationDuration),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(.1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    if (widget.showCursor) {
      _cursorController.repeat();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    if (widget.errorAnimationController != null) {
      _errorAnimationSubscription =
          widget.errorAnimationController!.stream.listen((errorAnimation) {
        if (errorAnimation == ErrorAnimationType.shake) {
          _controller.forward();

          _setState(() => isInErrorMode = true);
        } else if (errorAnimation == ErrorAnimationType.clear) {
          _setState(() => isInErrorMode = false);
        }
      });
    }
    // If a default value is set in the TextEditingController, then set to UI
    if (_textEditingController!.text.isNotEmpty)
      _setTextToInput(_textEditingController!.text);
  }

  // validating all the values
  void _checkForInvalidValues() {
    assert(widget.length > 0);
    assert(_pinTheme.fieldHeight > 0);
    assert(_pinTheme.fieldWidth > 0);
    assert(_pinTheme.activeBorderWidth >= 0);
    assert(_pinTheme.selectedBorderWidth >= 0);
    assert(_pinTheme.inactiveBorderWidth >= 0);
    assert(_pinTheme.disabledBorderWidth >= 0);
    assert(_pinTheme.errorBorderWidth >= 0);
    assert(_dialogConfig.affirmativeText != null &&
        _dialogConfig.affirmativeText!.isNotEmpty);
    assert(_dialogConfig.negativeText != null &&
        _dialogConfig.negativeText!.isNotEmpty);
    assert(_dialogConfig.dialogTitle != null &&
        _dialogConfig.dialogTitle!.isNotEmpty);
    assert(_dialogConfig.dialogContent != null &&
        _dialogConfig.dialogContent!.isNotEmpty);
  }

  runHapticFeedback() {
    switch (widget.hapticFeedbackTypes) {
      case HapticFeedbackTypes.heavy:
        HapticFeedback.heavyImpact();
        break;

      case HapticFeedbackTypes.medium:
        HapticFeedback.mediumImpact();
        break;

      case HapticFeedbackTypes.light:
        HapticFeedback.lightImpact();
        break;

      case HapticFeedbackTypes.selection:
        HapticFeedback.selectionClick();
        break;

      case HapticFeedbackTypes.vibrate:
        HapticFeedback.vibrate();
        break;

      default:
        break;
    }
  }

  void _paste(String text) {
    _textEditingController!.text = text;
  }

  void _setState(void Function() function) {
    if (mounted) {
      setState(function);
    }
  }

  void _onFocus() {
    if (widget.autoUnfocus) {
      if (_focusNode!.hasFocus &&
          MediaQuery.of(widget.appContext).viewInsets.bottom == 0) {
        _focusNode!.unfocus();
        Future.delayed(
            const Duration(microseconds: 1), () => _focusNode!.requestFocus());
      } else {
        _focusNode!.requestFocus();
      }
    } else {
      _focusNode!.requestFocus();
    }
  }

  void _setTextToInput(String data) async {
    var replaceInputList = List<String>.filled(widget.length, "");

    for (int i = 0; i < widget.length; i++) {
      replaceInputList[i] = data.length > i ? data[i] : "";
    }

    _setState(() {
      _selectedIndex = data.length;
      _inputList = replaceInputList;
    });
  }

  List<Widget> _getActionButtons(String pastedText) {
    var resultList = <Widget>[];
    if (_dialogConfig.platform == PinCodePlatform.iOS) {
      resultList.addAll([
        CupertinoDialogAction(
          child: Text(_dialogConfig.negativeText!),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        CupertinoDialogAction(
          child: Text(_dialogConfig.affirmativeText!),
          onPressed: () {
            _paste(pastedText);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ]);
    } else {
      resultList.addAll([
        TextButton(
          child: Text(_dialogConfig.negativeText!),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        TextButton(
          child: Text(_dialogConfig.affirmativeText!),
          onPressed: () {
            _paste(pastedText);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ]);
    }
    return resultList;
  }

  List<Widget> _generateFields() {
    var result = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      result.add(
        Container(
            padding: _pinTheme.fieldOuterPadding,
            child: AnimatedContainer(
              curve: widget.animationCurve,
              duration: widget.animationDuration,
              width: _pinTheme.fieldWidth,
              height: _pinTheme.fieldHeight,
              decoration: BoxDecoration(
                color: widget.enableActiveFill
                    ? _getFillColorFromIndex(i)
                    : Colors.transparent,
                boxShadow: (_pinTheme.activeBoxShadows != null ||
                        _pinTheme.inActiveBoxShadows != null)
                    ? _getBoxShadowFromIndex(i)
                    : widget.boxShadows,
                shape: _pinTheme.shape == PinCodeFieldShape.circle
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                borderRadius: borderRadius,
                border: _pinTheme.shape == PinCodeFieldShape.underline
                    ? Border(
                        bottom: BorderSide(
                          color: _getColorFromIndex(i),
                          width: _getBorderWidthForIndex(i),
                        ),
                      )
                    : Border.all(
                        color: _getColorFromIndex(i),
                        width: _getBorderWidthForIndex(i),
                      ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  switchInCurve: widget.animationCurve,
                  switchOutCurve: widget.animationCurve,
                  duration: widget.animationDuration,
                  transitionBuilder: (child, animation) {
                    if (widget.animationType == AnimationType.scale) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    } else if (widget.animationType == AnimationType.fade) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    } else if (widget.animationType == AnimationType.none) {
                      return child;
                    } else {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, .5),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    }
                  },
                  child: buildChild(i),
                ),
              ),
            )),
      );
      if (widget.separatorBuilder != null && i != widget.length - 1) {
        result.add(widget.separatorBuilder!(context, i));
      }
    }
    return result;
  }

  // Assigning the text controller, if empty assigning a new one.
  void _assignController() {
    _textEditingController = widget.controller ?? TextEditingController();

    _textEditingController?.addListener(_textEditingControllerListener);
  }

  void _textEditingControllerListener() {
    if (widget.useHapticFeedback) {
      runHapticFeedback();
    }

    if (isInErrorMode) {
      _setState(() => isInErrorMode = false);
    }

    _debounceBlink();

    var currentText = _textEditingController!.text;

    if (widget.enabled && _inputList.join("") != currentText) {
      if (currentText.length >= widget.length) {
        if (widget.onCompleted != null) {
          if (currentText.length > widget.length) {
            // removing extra text longer than the length
            currentText = currentText.substring(0, widget.length);
          }
          //  delay the onComplete event handler to give the onChange event handler enough time to complete
          Future.delayed(Duration(milliseconds: 300),
              () => widget.onCompleted!(currentText));
        }

        if (widget.autoDismissKeyboard) _focusNode!.unfocus();
      }
      _setTextToInput(currentText);

      widget.onChanged?.call(currentText);
    }
  }

  void _debounceBlink() {
    // set has blinked to false and back to true
    // after duration
    if (widget.blinkWhenObscuring &&
        _textEditingController!.text.length >
            _inputList.where((x) => x.isNotEmpty).length) {
      _setState(() {
        _hasBlinked = false;
      });

      if (_blinkDebounce?.isActive ?? false) {
        _blinkDebounce!.cancel();
      }

      _blinkDebounce = Timer(widget.blinkDuration, () {
        _setState(() {
          _hasBlinked = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _textEditingController!.removeListener(_textEditingControllerListener);
    if (widget.autoDisposeControllers) {
      _textEditingController!.dispose();
      _focusNode!.dispose();
      // if (!kReleaseMode) {
      //   print(
      //       "*** Disposing _textEditingController and _focusNode, To disable this feature please set autoDisposeControllers = false***");
      // }
    }

    _errorAnimationSubscription?.cancel();

    _cursorController.dispose();

    _controller.dispose();
    super.dispose();
  }

  // selects the right color for the field
  Color _getColorFromIndex(int index) {
    if (!widget.enabled) {
      return _pinTheme.disabledColor;
    }
    if (((_selectedIndex == index) ||
            (_selectedIndex == index + 1 && index + 1 == widget.length)) &&
        _focusNode!.hasFocus) {
      return _pinTheme.selectedColor;
    } else if (_selectedIndex > index) {
      Color relevantActiveColor = _pinTheme.activeColor;
      if (isInErrorMode) relevantActiveColor = _pinTheme.errorBorderColor;
      return relevantActiveColor;
    }

    Color relevantInActiveColor = _pinTheme.inactiveColor;
    if (isInErrorMode) relevantInActiveColor = _pinTheme.errorBorderColor;
    return relevantInActiveColor;
  }

  double _getBorderWidthForIndex(int index) {
    if (!widget.enabled) {
      return _pinTheme.disabledBorderWidth;
    }

    if (((_selectedIndex == index) ||
            (_selectedIndex == index + 1 && index + 1 == widget.length)) &&
        _focusNode!.hasFocus) {
      return _pinTheme.selectedBorderWidth;
    } else if (_selectedIndex > index) {
      double relevantActiveBorderWidth = _pinTheme.activeBorderWidth;
      if (isInErrorMode) relevantActiveBorderWidth = _pinTheme.errorBorderWidth;
      return relevantActiveBorderWidth;
    }

    double relevantActiveBorderWidth = _pinTheme.inactiveBorderWidth;
    if (isInErrorMode) relevantActiveBorderWidth = _pinTheme.errorBorderWidth;
    return relevantActiveBorderWidth;
  }

  List<BoxShadow>? _getBoxShadowFromIndex(int index) {
    if (_selectedIndex == index) {
      return _pinTheme.activeBoxShadows;
    } else if (_selectedIndex > index) {
      return _pinTheme.inActiveBoxShadows;
    }

    return [];
  }

  Widget _renderPinField({
    @required int? index,
  }) {
    assert(index != null);

    bool showObscured = !widget.blinkWhenObscuring ||
        (widget.blinkWhenObscuring && _hasBlinked) ||
        index != _inputList.where((x) => x.isNotEmpty).length - 1;

    if (widget.obscuringWidget != null) {
      if (showObscured) {
        if (_inputList[index!].isNotEmpty) {
          return widget.obscuringWidget!;
        }
      }
    }

    if (_inputList[index!].isEmpty && _hintAvailable) {
      return Text(
        widget.hintCharacter!,
        key: ValueKey(_inputList[index]),
        style: _hintStyle,
      );
    }

    final text =
        widget.obscureText && _inputList[index].isNotEmpty && showObscured
            ? widget.obscuringCharacter
            : _inputList[index];
    return widget.textGradient != null
        ? Gradiented(
            gradient: widget.textGradient!,
            child: Text(
              text,
              key: ValueKey(_inputList[index]),
              style: _textStyle.copyWith(color: Colors.white),
            ),
          )
        : Text(
            text,
            key: ValueKey(_inputList[index]),
            style: _textStyle,
          );
  }

// selects the right fill color for the field
  Color _getFillColorFromIndex(int index) {
    if (!widget.enabled) {
      return _pinTheme.disabledColor;
    }
    if (((_selectedIndex == index) ||
            (_selectedIndex == index + 1 && index + 1 == widget.length)) &&
        _focusNode!.hasFocus) {
      return _pinTheme.selectedFillColor;
    } else if (_selectedIndex > index) {
      return _pinTheme.activeFillColor;
    }
    return _pinTheme.inactiveFillColor;
  }

  /// Builds the widget to be shown
  Widget buildChild(int index) {
    if (((_selectedIndex == index) ||
            (_selectedIndex == index + 1 && index + 1 == widget.length)) &&
        _focusNode!.hasFocus &&
        widget.showCursor) {
      final cursorColor = widget.cursorColor ??
          Theme.of(widget.appContext).textSelectionTheme.cursorColor ??
          Theme.of(context).colorScheme.onSecondary;
      final cursorHeight = widget.cursorHeight ?? _textStyle.fontSize! + 8;

      if ((_selectedIndex == index + 1 && index + 1 == widget.length)) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: _textStyle.fontSize! / 1.5),
                child: FadeTransition(
                  opacity: _cursorAnimation,
                  child: CustomPaint(
                    size: Size(0, cursorHeight),
                    painter: CursorPainter(
                      cursorColor: cursorColor,
                      cursorWidth: widget.cursorWidth,
                    ),
                  ),
                ),
              ),
            ),
            _renderPinField(
              index: index,
            ),
          ],
        );
      } else
        return Center(
          child: FadeTransition(
            opacity: _cursorAnimation,
            child: CustomPaint(
              size: Size(0, cursorHeight),
              painter: CursorPainter(
                cursorColor: cursorColor,
                cursorWidth: widget.cursorWidth,
              ),
            ),
          ),
        );
    }
    return _renderPinField(
      index: index,
    );
  }

  Future<void> _showPasteDialog(String pastedText) {
    final formattedPastedText = pastedText
        .trim()
        .substring(0, min(pastedText.trim().length, widget.length));

    final defaultPastedTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSecondary,
    );

    return showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => _dialogConfig.platform == PinCodePlatform.iOS
          ? CupertinoAlertDialog(
              title: Text(_dialogConfig.dialogTitle!),
              content: RichText(
                text: TextSpan(
                  text: _dialogConfig.dialogContent,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge!.color,
                  ),
                  children: [
                    TextSpan(
                      text: formattedPastedText,
                      style: widget.pastedTextStyle ?? defaultPastedTextStyle,
                    ),
                    TextSpan(
                      text: "?",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelLarge!.color,
                      ),
                    )
                  ],
                ),
              ),
              actions: _getActionButtons(formattedPastedText),
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(_dialogConfig.dialogTitle!),
              content: RichText(
                text: TextSpan(
                  text: _dialogConfig.dialogContent,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.labelLarge!.color),
                  children: [
                    TextSpan(
                      text: formattedPastedText,
                      style: widget.pastedTextStyle ?? defaultPastedTextStyle,
                    ),
                    TextSpan(
                      text: " ?",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelLarge!.color,
                      ),
                    )
                  ],
                ),
              ),
              actions: _getActionButtons(formattedPastedText),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Directionality textField = Directionality(
      textDirection: widget.errorTextDirection,
      child: Padding(
        padding: widget.errorTextMargin,
        child: TextFormField(
          textInputAction: widget.textInputAction,
          controller: _textEditingController,
          focusNode: _focusNode,
          enabled: widget.enabled,
          autofillHints: widget.enablePinAutofill && widget.enabled
              ? <String>[AutofillHints.oneTimeCode]
              : null,
          autofocus: widget.autoFocus,
          autocorrect: false,
          keyboardType: widget.keyboardType,
          keyboardAppearance: widget.keyboardAppearance,
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
          onSaved: widget.onSaved,
          autovalidateMode: widget.autovalidateMode,
          inputFormatters: [
            ...widget.inputFormatters,
            LengthLimitingTextInputFormatter(
              widget.length,
            ), // this limits the input length
          ],
          // trigger on the complete event handler from the keyboard
          onFieldSubmitted: widget.onSubmitted,
          onEditingComplete: widget.onEditingComplete,
          enableInteractiveSelection: false,
          showCursor: false,
          // using same as background color so tha it can blend into the view
          cursorWidth: 0.01,
          decoration: InputDecoration(
            errorStyle: widget.errorTextStyle,
            focusedErrorBorder: widget.focusedErrorBorder,
            errorBorder: widget.errorBorder,
            contentPadding: const EdgeInsets.all(0),
            border: InputBorder.none,
            fillColor: widget.backgroundColor,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          style: TextStyle(
            color: Colors.transparent,
            height: .01,
            fontSize: kIsWeb
                ? 1
                : 0.01, // it is a hidden textfield which should remain transparent and extremely small
          ),
          scrollPadding: widget.scrollPadding,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
        ),
      ),
    );

    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        // adding the extra space at the bottom to show the error text from validator
        height: (widget.autovalidateMode == AutovalidateMode.disabled &&
                widget.validator == null)
            ? widget.pinTheme.fieldHeight
            : widget.pinTheme.fieldHeight + widget.errorTextSpace,
        color: widget.backgroundColor,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            AbsorbPointer(
              // this is a hidden textfield under the pin code fields.
              absorbing: true, // it prevents on tap on the text field
              child: widget.useExternalAutoFillGroup
                  ? textField
                  : AutofillGroup(
                      onDisposeAction: widget.onAutoFillDisposeAction,
                      child: textField,
                    ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (widget.onTap != null) widget.onTap!();
                  _onFocus();
                },
                onLongPress: widget.enabled
                    ? () async {
                        var data = await Clipboard.getData("text/plain");
                        if (data?.text?.isNotEmpty ?? false) {
                          if (widget.beforeTextPaste != null) {
                            if (widget.beforeTextPaste!(data!.text)) {
                              widget.showPasteConfirmationDialog
                                  ? _showPasteDialog(data.text!)
                                  : _paste(data.text!);
                            }
                          } else {
                            widget.showPasteConfirmationDialog
                                ? _showPasteDialog(data!.text!)
                                : _paste(data!.text!);
                          }
                        }
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: widget.mainAxisAlignment,
                  children: _generateFields(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
