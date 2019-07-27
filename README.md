# pin_code_fields

A flutter package which will help you to generate pin code fields.

## Features

- Error handling
- Automatic focuses the next field
- Can be set to any length. (3-6 fields recommended)

## Getting Started

<img src="https://github.com/adar2378/pin_code_fields/blob/master/pin_code.gif" width="250" height="480">

The part where you can construct the pin code text field 
``` Dart
PinCodeTextField(
      length: 6,
      obsecureText: false,
      getValues: changeNoticer.sink,
      shouldTriggerFucntions: changeNotifier.stream,
    );
```
This full code is from the example folder. You can run the example to see.

``` Dart
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PinCodeVerificationScreen(
          "+8801376221100"), // a random number, please don't call xD
    );
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  PinCodeVerificationScreen(this.phoneNumber);
  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  /// this [StreamController] will take input of which function should be called
  final changeNotifier = StreamController.broadcast();

  /// this [Streamcontroller] will return the value after executing the fucntion
  final changeNoticer = StreamController.broadcast();
  PinCodeTextField pinCodeTextFieldWidget;
  bool hasError = false;
  String submittedString = "";

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    pinCodeTextFieldWidget = PinCodeTextField(
      length: 6,
      obsecureText: false,
      getValues: changeNoticer.sink,
      shouldTriggerFucntions: changeNotifier.stream,
    );

    changeNoticer.stream.listen(_onData);
    changeNotifier.add(functions.doNothing);
    super.initState();
  }

  @override
  void dispose() {
    changeNotifier.close();
    changeNoticer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Image.asset(
                'assets/verify.png',
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: pinCodeTextFieldWidget),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError
                      ? "*Please fill up all the cells and press VERIFY again"
                      : "",
                  style: TextStyle(color: Colors.red.shade300, fontSize: 12),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Color(0xFF91D3B3),
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () async {
                      /// check the [_onData] fucntion to understand better
                      changeNotifier.add(functions
                          .checkError); // at first we will check error on the press of the button.
                    },
                    child: Center(
                        child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              Center(
                  child: Text(
                submittedString,
                style: TextStyle(fontSize: 18),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _onData(event) {
    print("dispatched event: $event");
    // if event == false that means there is no error. the error checking was called during the button press
    if (event == "false") {
      if (hasError) {
        setState(() {
          hasError = false;
        });
      }

      // if no error then we can get the string
      changeNotifier.add(functions.getSubmittedString);
    } else if (event == "true") {
      if (!hasError) {
        setState(() {
          hasError = true;
        });
      }
    } else if (event.length > 0) {
      // there can be 3 situations in total in this code, 1. it will return false .2 return true and 3. will return the string
      // so if it is not true or false then it must be the string which we called by passing fucntions.getSubmittedString in the changeNotifier
      print("Submitted text $event");
      setState(() {
        submittedString = event;
      });
    }
  }
}
```
