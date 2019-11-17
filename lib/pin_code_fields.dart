library pin_code_fields;

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// Pin code text fields which automatically changes focus and validates
class PinCodeTextField extends StatefulWidget {
  /// length of how many cells there should be. 3-8 is recommended by me
  final int length;

  /// you already know what it does i guess :P default is false
  final bool obsecureText;

  /// returns the current typed text in the fields
  final ValueChanged<String> currentText;

  /// this defines the shape of the input fields. Default is underlined
  final PinCodeFieldShape shape;

  /// the style of the text, default is [ fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold]
  final TextStyle textStyle;

  /// background color for the whole row of pin code fields. Default is [Colors.white]
  final Color backgroundColor;

  /// Border radius of each pin code field
  final BorderRadius borderRadius;

  /// [height] for the pin code field. default is [50.0]
  final double fieldHeight;

  /// [width] for the pin code field. default is [40.0]
  final double fieldWidth;

  /// This defines how the elements in the pin code field align. Default to [MainAxisAlignment.spaceBetween]
  final MainAxisAlignment mainAxisAlignment;

  /// Colors of the input fields which have inputs. Default is [Colors.green]
  final Color activeColor;

  /// Colors of the input fields which don't have inputs. Default is [Colors.red]
  final Color inactiveColor;

  /// Border width for the each input fields. Default is [2.0]
  final double borderWidth;

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

  PinCodeTextField(
      {Key key,
      @required this.length,
      this.obsecureText = false,
      @required this.currentText,
      this.backgroundColor = Colors.white,
      this.borderRadius,
      this.fieldHeight = 50,
      this.fieldWidth = 40,
      this.activeColor = Colors.red,
      this.inactiveColor = Colors.green,
      this.borderWidth = 2,
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
      this.animationDuration = const Duration(milliseconds: 150),
      this.animationCurve = Curves.easeInOut,
      this.shape = PinCodeFieldShape.underline,
      this.animationType = AnimationType.slide,
      this.textInputType = TextInputType.visiblePassword,
      this.autoFocus = false,
      this.textStyle = const TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)})
      : super(key: key);

  @override
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<PinCodeTextField> {
  TextEditingController _textEditingController;
  FocusNode _focusNode;
  List<String> _inputList;
  int _selectedIndex = 0;
  int _currentSize = 0;
  int _previousSize = 0;
  BorderRadius borderRadius;
  @override
  void initState() {
    _checkForInvalidValues();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      var value = _textEditingController.value.text;
      if (value.length - _currentSize > 1) {
        setPastedText(value);
      } else if (value.length != _currentSize) {
        _previousSize = _currentSize;
        _currentSize = value.length;
        _selectedIndex = _currentSize;
        if (_currentSize > _previousSize) {
          setState(() {
            _inputList[_selectedIndex - 1] = value[value.length - 1];
          });
        } else if (_currentSize < _previousSize) {
          setState(() {
            _inputList[_previousSize - 1] = "";
          });
        }
        if (_currentSize == widget.length) {
          _focusNode.unfocus();
        }
        widget.currentText(value);
      }
    });
    if (widget.shape != PinCodeFieldShape.circle &&
        widget.shape != PinCodeFieldShape.underline) {
      borderRadius = widget.borderRadius;
    }
    _focusNode = FocusNode();
    _inputList = List<String>(widget.length);
    _initializeValues();
    super.initState();
  }

  void _checkForInvalidValues() {
    assert(widget.length != null && widget.length > 0);
    assert(widget.obsecureText != null);
    assert(widget.currentText != null);
    assert(widget.backgroundColor != null);
    assert(widget.fieldHeight != null && widget.fieldHeight > 0);
    assert(widget.fieldWidth != null && widget.fieldWidth > 0);
    assert(widget.activeColor != null);
    assert(widget.inactiveColor != null);
    assert(widget.borderWidth != null && widget.borderWidth >= 0);
    assert(widget.mainAxisAlignment != null);
    assert(widget.animationDuration != null);
    assert(widget.animationCurve != null);
    assert(widget.shape != null);
    assert(widget.animationType != null);
    assert(widget.textStyle != null);
    assert(widget.textInputType != null);
    assert(widget.autoFocus != null);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeValues() {
    for (int i = 0; i < _inputList.length; i++) {
      _inputList[i] = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          color: widget.backgroundColor.withOpacity(1),
          padding: const EdgeInsets.only(bottom: 4.0),
          child: AbsorbPointer(
            // this is a hidden textfield under the pin code fields. This is why we need a background color to hide it
            absorbing: true, // it prevents on tap on the text field
            child: TextField(
              controller: _textEditingController,
              focusNode: _focusNode,
              enabled: false,
              autofocus: widget.autoFocus,
              autocorrect: false,
              keyboardType: widget.textInputType,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    widget.length), // this limits the input length
              ],
              enableInteractiveSelection: false,
              showCursor: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
              ),
            ),
          ),
        ),
        Container(
          color: widget.backgroundColor.withOpacity(1),
          constraints: BoxConstraints(minHeight: 30),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            children: _generateFields(),
          ),
        ),
      ],
    );
  }

  List<Widget> _generateFields() {
    var result = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      result.add(GestureDetector(
        onTap: _onFocus,
        onLongPress: () async {
          var data = await Clipboard.getData('text/plain');
          if (data.text.isNotEmpty) {
            showDialog(
                context: context,
                builder: (context) {
                  return Platform.isAndroid
                      ? AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text("Paste Code"),
                          content: RichText(
                            text: TextSpan(
                                text: "Do you want paste this code ",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .button
                                        .color),
                                children: [
                                  TextSpan(
                                      text: data.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade600)),
                                  TextSpan(
                                      text: " ?",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .button
                                              .color))
                                ]),
                          ),
                          actions: _getActionButtons(data.text),
                        )
                      : CupertinoAlertDialog(
                          title: Text("Paste Code"),
                          content: RichText(
                            text: TextSpan(
                                text: "Do you want paste this code ",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .button
                                        .color),
                                children: [
                                  TextSpan(
                                      text: data.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade600)),
                                  TextSpan(
                                      text: " ?",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .button
                                              .color))
                                ]),
                          ),
                          actions: _getActionButtons(data.text),
                        );
                });
          }
        },
        child: AnimatedContainer(
          curve: widget.animationCurve,
          duration: widget.animationDuration,
          width: widget.fieldWidth,
          height: widget.fieldHeight,
          decoration: BoxDecoration(
              shape: widget.shape == PinCodeFieldShape.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              borderRadius: borderRadius,
              border: widget.shape == PinCodeFieldShape.underline
                  ? Border(
                      bottom: BorderSide(
                      color: _selectedIndex <= i
                          ? widget.activeColor
                          : widget.inactiveColor,
                      width: widget.borderWidth,
                    ))
                  : Border.all(
                      color: _selectedIndex <= i
                          ? widget.activeColor
                          : widget.inactiveColor,
                      width: widget.borderWidth,
                    )),
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
          )),
        ),
      ));
    }
    return result;
  }

  void _onFocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }

    FocusScope.of(context).requestFocus(_focusNode);
  }

  void setPastedText(String data) async {
    String resultedString="";
    for (int i = 0; i < min(data.length, widget.length); i++) {
      resultedString += data[i];
      if (i == 0) {
        setState(() {
          _inputList[i] = data[i];
          _previousSize = _currentSize;
          _currentSize = i;
          _selectedIndex = _currentSize;
        });
      } else {
        setState(() {
          _inputList[i] = data[i];
          _previousSize = _currentSize;
          _currentSize = i + 1;
          _selectedIndex = _currentSize;
        });
      }
    }
    setState(() {});
    widget.currentText(resultedString);
  }

  List<Widget> _getActionButtons(String data) {
    var resultList = <Widget>[];
    if (Platform.isAndroid) {
      resultList.addAll([
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Paste"),
          onPressed: () {
            _textEditingController.text = data;
            // setPastedText(data);
            Navigator.pop(context);
          },
        ),
      ]);
    } else if (Platform.isIOS) {
      resultList.addAll([
        CupertinoDialogAction(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text("Paste"),
          onPressed: () {
            _textEditingController.text = data;
            // setPastedText(data);
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
