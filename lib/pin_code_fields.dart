library pin_code_fields;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pin code text fields which automatically changes focus and validates
class PinCodeTextField extends StatefulWidget {
  /// length of how many cells there should be. 3-8 is recommended by me
  final int length;

  /// you already know what it does i guess :P
  final bool obsecureText;

  /// this stream will decide which functions to be called from [functions]
  final Stream shouldTriggerFucntions;

  /// this sink will add value to a streamcontroller about the result after calling a function inside [PinCodeTextField]
  final Sink getValues;
  PinCodeTextField(
      {this.length,
      this.obsecureText,
      this.shouldTriggerFucntions,
      this.getValues});

  @override
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

enum functions { checkError, getSubmittedString, doNothing }

class _PinCodeTextFieldState extends State<PinCodeTextField> {
  /// list of total [FocusNode] depending on the total length that the user put in, which is obviously [widget.length]
  List<FocusNode> listOfFocusNodes;

  /// list of total [TextEditingController]
  List<TextEditingController> listOfControllers;

  /// error text for each of the cells
  List<String> errorTexts;

  /// this [StreamSubscription] will listen to the changes in our [widget.shouldTriggerFucntions]
  StreamSubscription streamSubscription;

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

  @override
  void initState() {
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
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              errorText:
                  errorTexts[i], // if null then no error, else will show error
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: Colors.green)),
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

  /// listener fucntion of [streamSubscription]
  void _onData(event) {
    if (event == functions.checkError) {
      widget.getValues.add(checkError().toString());
    } else if (event == functions.getSubmittedString) {
      widget.getValues.add(submitTotalString());
    } else if (event == functions.doNothing) {
      widget.getValues.add("");
    }
  }
}
