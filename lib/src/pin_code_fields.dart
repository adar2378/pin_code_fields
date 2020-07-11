part of pin_code_fields;

/// Pin code text fields which automatically changes focus and validates
class PinCodeTextField extends StatefulWidget {
  /// length of how many cells there should be. 3-8 is recommended by me
  final int length;

  /// you already know what it does i guess :P default is false
  final bool obsecureText;

  /// returns the current typed text in the fields
  final ValueChanged<String> onChanged;

  /// returns the typed text when all pins are set
  final ValueChanged<String> onCompleted;

  /// returns the typed text when user presses done/next action on the keyboard
  final ValueChanged<String> onSubmitted;

  /// the style of the text, default is [ fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold]
  final TextStyle textStyle;

  /// background color for the whole row of pin code fields. Default is [Colors.white]
  final Color backgroundColor;

  /// This defines how the elements in the pin code field align. Default to [MainAxisAlignment.spaceBetween]
  final MainAxisAlignment mainAxisAlignment;

  /// [AnimationType] for the text to appear in the pin code field. Default is [AnimationType.slide]
  final AnimationType animationType;

  /// Duration for the animation. Default is [Duration(milliseconds: 150)]
  final Duration animationDuration;

  /// [Curve] for the animation. Default is [Curves.easeInOut]
  final Curve animationCurve;

  /// [TextInputType] for the pin code fields. default is [TextInputType.visiblePassword]
  final TextInputType textInputType;

  /// If the pin code field should be autofocused or not. Default is [false]
  final bool autoFocus;

  /// Should pass a [FocusNode] to manage it from the parent
  final FocusNode focusNode;

  /// A list of [TextInputFormatter] that goes to the TextField
  final List<TextInputFormatter> inputFormatters;

  /// Enable or disable the Field. Default is [true]
  final bool enabled;

  /// [TextEditingController] to control the text manually. Sets a default [TextEditingController()] object if none given
  final TextEditingController controller;

  /// Enabled Color fill for individual pin fields, default is [false]
  final bool enableActiveFill;

  /// Auto dismiss the keyboard upon inputting the value for the last field. Default is [true]
  final bool autoDismissKeyboard;

  /// Auto dispose the [controller] and [FocusNode] upon the destruction of widget from the widget tree. Default is [true]
  final bool autoDisposeControllers;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  /// Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  /// - Copied from 'https://api.flutter.dev/flutter/services/TextCapitalization-class.html'
  /// Default is [TextCapitalization.none]
  final TextCapitalization textCapitalization;

  final TextInputAction textInputAction;

  /// Triggers the error animation
  final StreamController<ErrorAnimationType> errorAnimationController;

  /// Callback method to validate if text can be pasted. This is helpful when we need to validate text before pasting.
  /// e.g. validate if text is number. Default will be pasted as received.
  final bool Function(String text) beforeTextPaste;

  /// Configuration for paste dialog. Read more [DialogConfig]
  final DialogConfig dialogConfig;

  /// Theme for the pin cells. Read more [PinTheme]
  final PinTheme pinTheme;

  /// Brightness dark or light choices for iOS keyboard.
  final Brightness keyboardAppearance;

  /// Validator for the [TextFormField]
  final FormFieldValidator<String> validator;

  /// enables auto validation for the [TextFormField]
  /// Default is false
  final bool autoValidate;

  /// The vertical padding from the [PinCodeTextField] to the error text
  /// Default is 16.
  final double errorTextSpace;

  PinCodeTextField({
    Key key,
    @required this.length,
    this.controller,
    this.obsecureText = false,
    @required this.onChanged,
    this.onCompleted,
    this.backgroundColor = Colors.white,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.animationType = AnimationType.slide,
    this.textInputType = TextInputType.visiblePassword,
    this.autoFocus = false,
    this.focusNode,
    this.enabled = true,
    this.inputFormatters = const <TextInputFormatter>[],
    this.textStyle = const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    this.enableActiveFill = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.autoDismissKeyboard = true,
    this.autoDisposeControllers = true,
    this.onSubmitted,
    this.errorAnimationController,
    this.beforeTextPaste,
    this.dialogConfig,
    this.pinTheme = const PinTheme.defaults(),
    this.keyboardAppearance = Brightness.light,
    this.validator,
    this.autoValidate = false,
    this.errorTextSpace = 16,
  }) : super(key: key);

  @override
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<PinCodeTextField>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingController;
  FocusNode _focusNode;
  List<String> _inputList;
  int _selectedIndex = 0;
  BorderRadius borderRadius;

  // AnimationController for the error animation
  AnimationController _controller;

  // Animation for the error animation
  Animation<Offset> _offsetAnimation;
  DialogConfig get _dialogConfig => widget.dialogConfig == null
      ? DialogConfig()
      : DialogConfig(
          affirmativeText: widget.dialogConfig.affirmativeText,
          dialogContent: widget.dialogConfig.dialogContent,
          dialogTitle: widget.dialogConfig.dialogTitle,
          negativeText: widget.dialogConfig.negativeText);
  PinTheme get _pinTheme => widget.pinTheme ?? PinTheme();

  @override
  void initState() {
    if (!kReleaseMode) {
      print(
          "IF YOU WANT TO USE COLOR FILL FOR EACH CELL THEN SET enableActiveFill = true");
    }

    _checkForInvalidValues();
    _assignController();
    if (_pinTheme.shape != PinCodeFieldShape.circle &&
        _pinTheme.shape != PinCodeFieldShape.underline) {
      borderRadius = _pinTheme.borderRadius;
    }
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    }); // Rebuilds on every change to reflect the correct color on each field.
    _inputList = List<String>(widget.length);
    _initializeValues();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(.1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    if (widget.errorAnimationController != null) {
      widget.errorAnimationController.stream.listen((errorAnimation) {
        if (errorAnimation == ErrorAnimationType.shake) {
          _controller.forward();
        }
      });
    }
    super.initState();
  }

  // validating all the values
  void _checkForInvalidValues() {
    assert(widget.length != null && widget.length > 0);
    assert(widget.obsecureText != null);
    assert(_pinTheme.fieldHeight != null && _pinTheme.fieldHeight > 0);
    assert(_pinTheme.fieldWidth != null && _pinTheme.fieldWidth > 0);
    assert(_pinTheme.activeColor != null);
    assert(_pinTheme.inactiveColor != null);
    assert(widget.backgroundColor != null);
    assert(_pinTheme.borderWidth != null && _pinTheme.borderWidth >= 0);
    assert(widget.mainAxisAlignment != null);
    assert(widget.animationDuration != null);
    assert(widget.animationCurve != null);
    assert(_pinTheme.shape != null);
    assert(widget.animationType != null);
    assert(widget.textStyle != null);
    assert(widget.textInputType != null);
    assert(widget.autoFocus != null);
    assert(_dialogConfig.affirmativeText != null &&
        _dialogConfig.affirmativeText.isNotEmpty);
    assert(_dialogConfig.negativeText != null &&
        _dialogConfig.negativeText.isNotEmpty);
    assert(_dialogConfig.dialogTitle != null &&
        _dialogConfig.dialogTitle.isNotEmpty);
    assert(_dialogConfig.dialogContent != null &&
        _dialogConfig.dialogContent.isNotEmpty);
    assert(widget.enableActiveFill != null);
    assert(_pinTheme.activeFillColor != null);
    assert(_pinTheme.inactiveFillColor != null);
    assert(_pinTheme.selectedFillColor != null);
    assert(widget.textCapitalization != null);
    assert(widget.textInputAction != null);
    assert(widget.autoDisposeControllers != null);
    assert(widget.autoValidate != null);
  }

  // Assigning the text controller, if empty assiging a new one.
  void _assignController() {
    if (widget.controller == null) {
      _textEditingController = TextEditingController();
    } else {
      _textEditingController = widget.controller;
    }
    _textEditingController.addListener(() {
      var currentText = _textEditingController.text;

      if (widget.enabled && _inputList.join("") != currentText) {
        if (currentText.length >= widget.length) {
          if (widget.onCompleted != null) {
            if (currentText.length > widget.length) {
              // removing extra text longer than the length
              currentText = currentText.substring(0, widget.length);
            }
            //  delay the onComplete event handler to give the onChange event handler enough time to complete
            Future.delayed(Duration(milliseconds: 300),
                () => widget.onCompleted(currentText));
          }

          if (widget.autoDismissKeyboard) _focusNode.unfocus();
        }
        if (widget.onChanged != null) {
          widget.onChanged(currentText);
        }
      }

      _setTextToInput(currentText);
    });
  }

  @override
  void dispose() {
    if (widget.autoDisposeControllers) {
      _textEditingController.dispose();
      _focusNode.dispose();
      if (!kReleaseMode) {
        print(
            "*** Disposing _textEditingController and _focusNode, To disable this feature please set autoDisposeControllers = false***");
      }
    }
    _controller.dispose();
    super.dispose();
  }

  void _initializeValues() {
    for (int i = 0; i < _inputList.length; i++) {
      _inputList[i] = "";
    }
  }

  // selects the right color for the field
  Color _getColorFromIndex(int index) {
    if (!widget.enabled) {
      return _pinTheme.disabledColor;
    }
    if (((_selectedIndex == index) ||
            (_selectedIndex == index + 1 && index + 1 == widget.length)) &&
        _focusNode.hasFocus) {
      return _pinTheme.selectedColor;
    } else if (_selectedIndex > index) {
      return _pinTheme.activeColor;
    }
    return _pinTheme.inactiveColor;
  }

// selects the right fill color for the field
  Color _getFillColorFromIndex(int index) {
    if (!widget.enabled) {
      return _pinTheme.disabledColor;
    }
    if (((_selectedIndex == index) ||
            (_selectedIndex == index + 1 && index + 1 == widget.length)) &&
        _focusNode.hasFocus) {
      return _pinTheme.selectedFillColor;
    } else if (_selectedIndex > index) {
      return _pinTheme.activeFillColor;
    }
    return _pinTheme.inactiveFillColor;
  }

  Future<void> _showPasteDialog(String pastedText) {
    var formattedPastedText = pastedText
        .trim()
        .substring(0, min(pastedText.trim().length, widget.length));
    return showDialog(
      context: context,
      builder: (context) {
        return Platform.isAndroid
            ? AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(_dialogConfig.dialogTitle),
                content: RichText(
                  text: TextSpan(
                    text: _dialogConfig.dialogContent,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.button.color),
                    children: [
                      TextSpan(
                        text: formattedPastedText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                        ),
                      ),
                      TextSpan(
                        text: " ?",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.button.color,
                        ),
                      )
                    ],
                  ),
                ),
                actions: _getActionButtons(formattedPastedText),
              )
            : CupertinoAlertDialog(
                title: Text(_dialogConfig.dialogTitle),
                content: RichText(
                  text: TextSpan(
                    text: _dialogConfig.dialogContent,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.button.color,
                    ),
                    children: [
                      TextSpan(
                        text: formattedPastedText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                        ),
                      ),
                      TextSpan(
                        text: " ?",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.button.color,
                        ),
                      )
                    ],
                  ),
                ),
                actions: _getActionButtons(formattedPastedText),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        // adding the extra space at the bottom to show the error text from validator
        height: widget.pinTheme.fieldHeight + widget.errorTextSpace,
        color: widget.backgroundColor,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            AbsorbPointer(
              // this is a hidden textfield under the pin code fields.
              absorbing: true, // it prevents on tap on the text field
              child: TextFormField(
                textInputAction: widget.textInputAction,
                controller: _textEditingController,
                focusNode: _focusNode,
                enabled: widget.enabled,
                autofocus: widget.autoFocus,
                autocorrect: false,
                keyboardType: widget.textInputType,
                keyboardAppearance: widget.keyboardAppearance,
                textCapitalization: widget.textCapitalization,
                validator: widget.validator,
                autovalidate: widget.autoValidate,
                inputFormatters: [
                  ...widget.inputFormatters,
                  LengthLimitingTextInputFormatter(
                    widget.length,
                  ), // this limits the input length
                ],
                // trigger on the complete event handler from the keyboard
                onFieldSubmitted: widget.onSubmitted,
                enableInteractiveSelection: false,
                showCursor: true,
                // this cursor must remain hidden
                cursorColor: widget.backgroundColor,
                // using same as background color so tha it can blend into the view
                cursorWidth: 0.01,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0),
                  border: InputBorder.none,
                  fillColor: widget.backgroundColor,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(
                  color: Colors.transparent,
                  height: .01,
                  fontSize:
                      0.01, // it is a hidden textfield which should remain transparent and extremely small
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _onFocus,
                onLongPress: widget.enabled
                    ? () async {
                        var data = await Clipboard.getData("text/plain");
                        if (data?.text?.isNotEmpty ?? false) {
                          if (widget.beforeTextPaste != null) {
                            if (widget.beforeTextPaste(data.text)) {
                              _showPasteDialog(data.text);
                            }
                          } else {
                            _showPasteDialog(data.text);
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

  List<Widget> _generateFields() {
    var result = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      result.add(
        AnimatedContainer(
          curve: widget.animationCurve,
          duration: widget.animationDuration,
          width: _pinTheme.fieldWidth,
          height: _pinTheme.fieldHeight,
          decoration: BoxDecoration(
            color: widget.enableActiveFill
                ? _getFillColorFromIndex(i)
                : Colors.transparent,
            shape: _pinTheme.shape == PinCodeFieldShape.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: borderRadius,
            border: _pinTheme.shape == PinCodeFieldShape.underline
                ? Border(
                    bottom: BorderSide(
                      color: _getColorFromIndex(i),
                      width: _pinTheme.borderWidth,
                    ),
                  )
                : Border.all(
                    color: _getColorFromIndex(i),
                    width: _pinTheme.borderWidth,
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
              child: Text(
                widget.obsecureText && _inputList[i].isNotEmpty
                    ? "●"
                    : _inputList[i],
                key: ValueKey(_inputList[i]),
                style: widget.textStyle,
              ),
            ),
          ),
        ),
      );
    }
    return result;
  }

  void _onFocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      Future.delayed(const Duration(microseconds: 1),
          () => FocusScope.of(context).requestFocus(_focusNode));
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void _setTextToInput(String data) async {
    var replaceInputList = List<String>(widget.length);

    for (int i = 0; i < widget.length; i++) {
      replaceInputList[i] = data.length > i ? data[i] : "";
    }

    setState(() {
      _selectedIndex = data.length;
      _inputList = replaceInputList;
    });
  }

  List<Widget> _getActionButtons(String pastedText) {
    var resultList = <Widget>[];
    if (Platform.isAndroid) {
      resultList.addAll([
        FlatButton(
          child: Text(_dialogConfig.negativeText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(_dialogConfig.affirmativeText),
          onPressed: () {
            _textEditingController.text = pastedText;
            Navigator.pop(context);
          },
        ),
      ]);
    } else if (Platform.isIOS) {
      resultList.addAll([
        CupertinoDialogAction(
          child: Text(_dialogConfig.negativeText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text(_dialogConfig.affirmativeText),
          onPressed: () {
            _textEditingController.text = pastedText;
            Navigator.pop(context);
          },
        ),
      ]);
    }
    return resultList;
  }
}

enum AnimationType { scale, slide, fade, none }

enum PinCodeFieldShape { box, underline, circle }

enum ErrorAnimationType { shake }
