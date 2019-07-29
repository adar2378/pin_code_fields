# pin_code_fields

A flutter package which will help you to generate pin code fields. Can be useful for OTP or pin code inputs.

## Features

- Error handling
- Automatically focuses the next field
- Can be set to any length. (3-6 fields recommended)
- 3 different shapes for text fields
- Customizable

## Getting Started

<img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/pin_code.gif" width="250" height="480">

**The part how you can construct the pin code text field**

```Dart
PinCodeTextField(
      length: 6, // must be greater than 0
      obsecureText: false, //optional, default is 0
      shape: PinCodeFieldShape.round, //optional, default is underline
      onDone: (String value) {
        setState(() {
          submittedString = value;
        });
      },
      textStyle: TextStyle(fontWeight: FontWeight.bold), //optinal, default is TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)
      onErrorCheck: (bool value) {
        setState(() {
          hasError = value;
        });
      },
      shouldTriggerFucntions: changeNotifier.stream,
    );
```

**ChangeNotifier will trigger the submission. If any error found then the onErrorCheck call back will return true**

```Dart
    final changeNotifier = StreamController<Functions>();
```

**Listen to the result after calling functions. If there is no errors then onDone call back will be called**

```Dart
  changeNotifier.add(Functions.submit); // this will invoke the submission
```

**Shape can be among these 3 types**

```Dart
enum PinCodeFieldShape { box, underline, round }
```

**This full code is from the example folder. You can run the example to see.**

```Dart
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
  final changeNotifier = StreamController<Functions>();

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
      shape: PinCodeFieldShape.round,
      onDone: (value) {
        setState(() {
          submittedString = value;
        });
      },
      textStyle: TextStyle(fontWeight: FontWeight.bold),
      onErrorCheck: (value) {
        setState(() {
          hasError = value;
        });
      },
      shouldTriggerFucntions: changeNotifier.stream,
    );

    super.initState();
  }

  @override
  void dispose() {
    changeNotifier.close();

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
              SizedBox(height: 10),
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
                      changeNotifier.add(Functions
                          .submit); // at first we will check error on the press of the button.
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
}

```
