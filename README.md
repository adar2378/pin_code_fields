# pin_code_fields

<a href = "https://pub.dev/packages/pin_code_fields"><img src="https://img.shields.io/pub/v/pin_code_fields"></a>

A flutter package which will help you to generate pin code fields. Can be useful for OTP or pin code inputs 🤓🤓

## Features 💚

- Automatically focuses the next field on typing and focuses previous field on deletation
- Can be set to any length. (3-6 fields recommended)
- 3 different shapes for text fields
- Highly customizable
- 3 different types of animation for input texts
- Animated active, inactive field color switching
- Get currently typed text and use your condition to validate it. (for example: if (currentText.length != 6 || currentText != "<your desired code>"))

## Properties

```Dart
/// length of how many cells there should be. 4-6 is recommended by me
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
```

## Getting Started

#### Demo

<img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/pin_code.gif" width="250" height="480">

#### Different Shapes

<img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/pic1.png" width="250" height="480"><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/pic2.png" width="250" height="480"><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/pic3.png" width="250" height="480">

**The pin code text field widget example**

```Dart
PinCodeTextField(
  length: 6,
  obsecureText: false,
  animationType: AnimationType.fade,
  shape: PinCodeFieldShape.box,
  animationDuration: Duration(milliseconds: 300),
  borderRadius: BorderRadius.circular(5),
  fieldHeight: 50,
  fieldWidth: 40,
  currentText: (value) {
    setState(() {
      currentText = value;
    });
  },
)
```

**Shape can be among these 3 types**

```Dart
enum PinCodeFieldShape { box, underline, circle }
```

**Animations can be among these 3 types**

```Dart
enum AnimationType { scale, slide, fade, none }
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

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
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
                  child: PinCodeTextField(
                    length: 6,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.underline,
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    currentText: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                // error showing widget
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(color: Colors.red.shade300, fontSize: 15),
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
                    onPressed: () {
                      // conditions for validating
                      if (currentText.length != 6 || currentText != "towtow") {
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        setState(() {
                          hasError = false;
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Aye!!"),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      }
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
            ],
          ),
        ),
      ),
    );
  }
}
```
