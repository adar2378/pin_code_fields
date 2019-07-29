library pin_code_fields;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pin code text fields which automatically changes focus and validates
class PinCodeTextField extends StatefulWidget {
  /// length of how many cells there should be. 3-8 is recommended by me
  final int length;

  /// you already know what it does i guess :P default is false
  final bool obsecureText;

  /// this stream will decide which functions to be called from [functions]
  final Stream shouldTriggerFucntions;

  /// callback which will be triggered if there is no error and will return the complete string
  final ValueChanged<String> onDone;

  /// this callback will return value if there is any error or not
  final ValueChanged<bool> onErrorCheck;

  /// this defines the shape of the input fields. Default is underlined
  final PinCodeFieldShape shape;

  /// the style of the text, default is [fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold]
  final TextStyle textStyle;
  PinCodeTextField(
      {@required this.length,
      this.obsecureText = false,
      @required this.shouldTriggerFucntions,
      @required this.onDone,
      @required this.onErrorCheck,
      this.shape = PinCodeFieldShape.underline,
      this.textStyle = const TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)});

  @override
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

enum Functions { submit, idle }

enum PinCodeFieldShape { box, underline, round }

class _PinCodeTextFieldState extends State<PinCodeTextField> {
  /// list of total [FocusNode] depending on the total length that the user put in, which is obviously [widget.length]
  List<FocusNode> listOfFocusNodes;

  /// list of total [TextEditingController]
  List<TextEditingController> listOfControllers;

  /// error text for each of the cells
  List<String> errorTexts;

  /// this [StreamSubscription] will listen to the changes in our [widget.shouldTriggerFucntions]
  StreamSubscription streamSubscription;
  var border;
  var focusedBorder;
  PinCodeFieldShape shape;
  @override
  void dispose() {
    streamSubscription.cancel();
    _disposeControllers();
    super.dispose();
  }

  _disposeControllers() {
    for (int i = 0; i < listOfControllers.length; i++) {
      listOfControllers[i].dispose();
    }
  }

  final _borderSideValue = BorderSide(width: 1.5, color: Colors.green);
  _setUpShape() {
    shape = widget.shape;

    if (shape == PinCodeFieldShape.box) {
      border = OutlineInputBorder();
      focusedBorder = OutlineInputBorder(borderSide: _borderSideValue);
    } else if (shape == PinCodeFieldShape.underline) {
      border = UnderlineInputBorder();
      focusedBorder = UnderlineInputBorder(borderSide: _borderSideValue);
    } else if (shape == PinCodeFieldShape.round) {
      border = OutlineInputBorder(borderRadius: BorderRadius.circular(25));
      focusedBorder = OutlineInputBorder(
          borderSide: _borderSideValue,
          borderRadius: BorderRadius.circular(25));
    }
  }

  @override
  void initState() {
    _setUpShape();
    assert(widget.length > 0);
    listOfFocusNodes =
        List<FocusNode>.generate(widget.length, (index) => FocusNode());
    listOfControllers = List<TextEditingController>.generate(
        widget.length, (index) => TextEditingController());
    errorTexts = List<String>.generate(widget.length, (index) => null);
    streamSubscription = widget.shouldTriggerFucntions.listen(_onData);
    super.initState();
  }

  /// generating the [TextField]s
  List<Widget> _generateTextFields() {
    var resultList = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      resultList.add(
        Flexible(
          flex: 2,
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  1), // this limits the input length of each TextField to be '1'
            ],
            onChanged: (value) {
              if (value.length == 1) {
                if (errorTexts[i] != null) {
                  setState(() {
                    errorTexts[i] =
                        null; // changing the state of the errorTexts
                  });
                }
                // changing focus after user enters an input
                if (i != widget.length - 1) {
                  FocusScope.of(context).requestFocus(listOfFocusNodes[i + 1]);
                } else {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              }
            },
            obscureText: widget.obsecureText,
            controller: listOfControllers[i],
            focusNode: listOfFocusNodes[i],
            textAlign: TextAlign.center,
            style: widget.textStyle,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: border,
              errorText:
                  errorTexts[i], // if null then no error, else will show error
              focusedBorder: focusedBorder,
            ),
          ),
        ),
      );
      if (i != widget.length - 1) {
        resultList.add(Spacer());
      }
    }
    return resultList;
  }

  /// checks errors, will return true if there is any error. and also will make the textField red.
  bool checkError() {
    bool errorFound = false;
    for (int i = 0; i < listOfControllers.length; i++) {
      if (listOfControllers[i].text == null ||
          listOfControllers[i].text.length == 0) {
        errorFound = true;
        setState(() {
          errorTexts[i] = "";
        });
      } else {
        if (errorTexts[i] != null) {
          setState(() {
            errorTexts[i] = null;
          });
        }
      }
    }
    return errorFound;
  }

  /// will return the total string by appending all the strings of each cells
  String submitTotalString() {
    String result = "";
    for (int i = 0; i < listOfControllers.length; i++) {
      result += listOfControllers[i].text;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _generateTextFields(),
    );
  }

  /// listener fucntion of [streamSubscription] and calling the callbacks
  void _onData(event) {
    if (event == Functions.submit) {
      if (checkError()) {
        widget.onErrorCheck(true);
      } else {
        widget.onErrorCheck(false);
        widget.onDone(submitTotalString());
      }
    }
  }
}
