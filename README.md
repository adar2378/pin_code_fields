<p align="center">
  <img width="460"  src="https://i.ibb.co/X5qxF7x/export-banner.png">
</p>

<a href = "https://pub.dev/packages/pin_code_fields"><img src="https://img.shields.io/pub/v/pin_code_fields"></a>

<a href = "https://www.patreon.com/bePatron?u=26622525"><img src = "https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="250"></a>

A flutter package which will help you to generate pin code fields with beautiful design and animations. Can be useful for OTP or pin code inputs 🤓🤓

## Features 💚

- Automatically focuses the next field on typing and focuses previous field on deletation
- Cursor support ⚡️
- Can be set to any length. (3-6 fields recommended)
- 3 different shapes for text fields
- Highly customizable
- 3 different types of animation for input texts
- Animated active, inactive, selected and disabled field color switching
- Autofocus option
- Otp-code pasting from clipboard
- iOS autofill support
- Error animation. Currently have shake animation only. Watch the example app for how to integrate.
- Works with Flutter's Form. You can use Form validator right off the bat.
- Get currently typed text and use your condition to validate it. (for example: if (currentText.length != 6 || currentText != "your desired code"))
- Haptic Feedback support
- Animated obscure widget support
- Single placeholder text

## Getting Started ⚡️

#### Demo

<img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/demo_media/example.gif" width="320" height="480"> <img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/demo_media/paste_android.gif" width="240" height="480"> <img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/demo_media/paste_ios.gif" width="240" height="480">

#### Different Shapes

<img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/demo_media/box.png" width="250" height="480"><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/demo_media/circle.png" width="250" height="480"><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/master/demo_media/underline.png" width="250" height="480">

## Notes

- To enable "Fill color" for each cells, `enableActiveFill` must be set to `true`. The default value is `false`.
- To change the keyboard type, for example to use only number keyboard, or only for email use `keyboardType` parameter, default is [TextInputType.visiblePassword]
- `FocosNode` and `TextEditingController` will get disposed automatically. Use `autoDisposeControllers = false` to disable it.
- to use v5.0.0 or above, developers must have Flutter SDK 1.20.0 or above.
- to use v6.0.0 or above, developers must have Flutter SDK 1.22.0 or above.

## Properties 🔖

```Dart
  /// The [BuildContext] of the application
  final BuildContext appContext;

  ///Box Shadow for Pincode
  final List<BoxShadow>? boxShadows;

  /// length of how many cells there should be. 3-8 is recommended by me
  final int length;

  /// you already know what it does i guess :P default is false
  final bool obscureText;

  /// Character used for obscuring text if obscureText is true.
  ///
  /// Must not be empty. Single character is recommended.
  ///
  /// Default is ● - 'Black Circle' (U+25CF)
  final String obscuringCharacter;

  /// Widget used to obscure text
  ///
  /// it overrides the obscuringCharacter
  final Widget? obscuringWidget;

  /// Whether to use haptic feedback or not
  ///
  ///
  final bool useHapticFeedback;

  /// Haptic Feedback Types
  ///
  /// heavy, medium, light links to respective impacts
  /// selection - selectionClick, vibrate - vibrate
  /// check [HapticFeedback] for more
  final HapticFeedbackTypes hapticFeedbackTypes;

  /// Decides whether typed character should be
  /// briefly shown before being obscured
  final bool blinkWhenObscuring;

  /// Blink Duration if blinkWhenObscuring is set to true
  final Duration blinkDuration;

  /// returns the current typed text in the fields
  final ValueChanged<String> onChanged;

  /// returns the typed text when all pins are set
  final ValueChanged<String>? onCompleted;

  /// returns the typed text when user presses done/next action on the keyboard
  final ValueChanged<String>? onSubmitted;

  /// the style of the text, default is [ fontSize: 20, fontWeight: FontWeight.bold]
  final TextStyle? textStyle;

  /// the style of the pasted text, default is [fontWeight: FontWeight.bold] while
  /// [TextStyle.color] is [ThemeData.colorScheme.onSecondary]
  final TextStyle? pastedTextStyle;

  /// background color for the whole row of pin code fields.
  final Color? backgroundColor;

  /// This defines how the elements in the pin code field align. Default to [MainAxisAlignment.spaceBetween]
  final MainAxisAlignment mainAxisAlignment;

  /// [AnimationType] for the text to appear in the pin code field. Default is [AnimationType.slide]
  final AnimationType animationType;

  /// Duration for the animation. Default is [Duration(milliseconds: 150)]
  final Duration animationDuration;

  /// [Curve] for the animation. Default is [Curves.easeInOut]
  final Curve animationCurve;

  /// [TextInputType] for the pin code fields. default is [TextInputType.visiblePassword]
  final TextInputType keyboardType;

  /// If the pin code field should be autofocused or not. Default is [false]
  final bool autoFocus;

  /// Should pass a [FocusNode] to manage it from the parent
  final FocusNode? focusNode;

  /// A list of [TextInputFormatter] that goes to the TextField
  final List<TextInputFormatter> inputFormatters;

  /// Enable or disable the Field. Default is [true]
  final bool enabled;

  /// [TextEditingController] to control the text manually. Sets a default [TextEditingController()] object if none given
  final TextEditingController? controller;

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
  final StreamController<ErrorAnimationType>? errorAnimationController;

  /// Callback method to validate if text can be pasted. This is helpful when we need to validate text before pasting.
  /// e.g. validate if text is number. Default will be pasted as received.
  final bool Function(String? text)? beforeTextPaste;

  /// Method for detecting a pin_code form tap
  /// work with all form windows
  final Function? onTap;

  /// Configuration for paste dialog. Read more [DialogConfig]
  final DialogConfig? dialogConfig;

  /// Theme for the pin cells. Read more [PinTheme]
  final PinTheme pinTheme;

  /// Brightness dark or light choices for iOS keyboard.
  final Brightness? keyboardAppearance;

  /// Validator for the [TextFormField]
  final FormFieldValidator<String>? validator;

  /// An optional method to call with the final value when the form is saved via
  /// [FormState.save].
  final FormFieldSetter<String>? onSaved;

  /// enables auto validation for the [TextFormField]
  /// Default is [AutovalidateMode.onUserInteraction]
  final AutovalidateMode autovalidateMode;

  /// The vertical padding from the [PinCodeTextField] to the error text
  /// Default is 16.
  final double errorTextSpace;

  /// Margin for the error text
  /// Default is [EdgeInsets.zero].
  final EdgeInsets errorTextMargin;

  /// [TextDirection] to control a direction in which text flows.
  /// Default is [TextDirection.ltr]
  final TextDirection errorTextDirection;

  /// Enables pin autofill for TextFormField.
  /// Default is true
  final bool enablePinAutofill;

  /// Error animation duration
  final int errorAnimationDuration;

  /// Whether to show cursor or not
  final bool showCursor;

  /// The color of the cursor, default to Theme.of(context).accentColor
  final Color? cursorColor;

  /// width of the cursor, default to 2
  final double cursorWidth;

  /// Height of the cursor, default to FontSize + 8;
  final double? cursorHeight;

  /// Autofill cleanup action
  final AutofillContextAction onAutoFillDisposeAction;

  /// Use external [AutoFillGroup]
  final bool useExternalAutoFillGroup;

  /// Displays a hint or placeholder in the field if it's value is empty.
  /// It only appears if it's not null. Single character is recommended.
  final String? hintCharacter;

  /// the style of the [hintCharacter], default is [fontSize: 20, fontWeight: FontWeight.bold]
  /// and it also uses the [textStyle]'s properties
  /// [TextStyle.color] is [Colors.grey]
  final TextStyle? hintStyle;

  /// ScrollPadding follows the same property as TextField's ScrollPadding, default to
  /// const EdgeInsets.all(20),
  final EdgeInsets scrollPadding;

  /// Text gradient for Pincode
  final Gradient? textGradient;

  /// Makes the pin cells readOnly
  final bool readOnly;

  /// Enable auto unfocus
  final bool autoUnfocus;
```

**PinTheme**

```Dart
/// Colors of the input fields which have inputs. Default is [Colors.green]
  final Color activeColor;

  /// Color of the input field which is currently selected. Default is [Colors.blue]
  final Color selectedColor;

  /// Colors of the input fields which don't have inputs. Default is [Colors.red]
  final Color inactiveColor;

  /// Colors of the input fields if the [PinCodeTextField] is disabled. Default is [Colors.grey]
  final Color disabledColor;

  /// Colors of the input fields which have inputs. Default is [Colors.green]
  final Color activeFillColor;

  /// Color of the input field which is currently selected. Default is [Colors.blue]
  final Color selectedFillColor;

  /// Colors of the input fields which don't have inputs. Default is [Colors.red]
  final Color inactiveFillColor;

  /// Color of the input field when in error mode. Default is [Colors.redAccent]
  final Color errorBorderColor;

  /// Border radius of each pin code field
  final BorderRadius borderRadius;

  /// [height] for the pin code field. default is [50.0]
  final double fieldHeight;

  /// [width] for the pin code field. default is [40.0]
  final double fieldWidth;

  /// Border width for the each input fields. Default is [2.0]
  final double borderWidth;

  /// this defines the shape of the input fields. Default is underlined
  final PinCodeFieldShape shape;
```

**DialogConfig**

```Dart
/// title of the [AlertDialog] while pasting the code. Default to [Paste Code]
  final String dialogTitle;

  /// content of the [AlertDialog] while pasting the code. Default to ["Do you want to paste this code "]
  final String dialogContent;

  /// Affirmative action text for the [AlertDialog]. Default to "Paste"
  final String affirmativeText;

  /// Negative action text for the [AlertDialog]. Default to "Cancel"
  final String negativeText;

  /// The default dialog theme, should it be iOS or other(including web and Android)
  final Platform platform; //enum Platform { iOS, other } other indicates for web and android
```

## Contributors ✨

Thanks to everyone whoever suggested their thoughts to improve this package. And special thanks goes to these people:

<table>
  <tr>
    <td align="center"><a href="https://github.com/EmmanuelVlad"><img src="https://avatars0.githubusercontent.com/u/21370666?v=3" width="100px;" alt="Emmanuel Vlad"/><br /><sub><b>Emmanuel Vlad</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields" title="Documentation">📖</a><a href="https://github.com/adar2378/pin_code_fields/commits?author=EmmanuelVlad" title="Code">💻</a></td>
<td align="center"><a href="https://atiq.info/"><img src="https://atiq.info/images/logo.png" width="100px;" alt="Atiq"/><br /><sub><b>Atiqur Rahaman</b></sub></a><br /><a href="https://www.2dimensions.com/a/atiq31416/files/flare/otp-verification/preview" title="UX & Flare Animation">🎨</a></td>
<td align="center"><a href="https://github.com/milind-mevada-stl"><img src="https://avatars2.githubusercontent.com/u/29375516?v=3" width="100px;" alt="Milind Mevada"/><br /><sub><b>Milind Mevada</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields" title="Documentation">📖</a><a href="https://github.com/adar2378/pin_code_fields/commits?author=milind-mevada-stl" title="Code">💻</a></td>
<td align="center"><a href="https://github.com/RemeJuan"><img src="https://avatars1.githubusercontent.com/u/864552?v=3" width="100px;" alt="Reme Le Hane"/><br /><sub><b>Reme Le Hane</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields" title="Documentation">📖</a><a href="https://github.com/adar2378/pin_code_fields/commits?author=RemeJuan" title="Code">💻</a></td>
<td align="center"><a href="https://github.com/TabooSun"><img src="https://avatars2.githubusercontent.com/u/31196825?v=3" width="100px;" alt="TabooSun"/><br /><sub><b>TabooSun</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=TabooSun" title="Code">💻</<a></td>
<td align="center"><a href="https://github.com/thallessantos"><img src="https://avatars2.githubusercontent.com/u/13054457?v=3" width="100px;" alt="Thalles Santos"/><br /><sub><b>Thalles Santos</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=thallessantos" title="Code">💻</a></td>
<td align="center"><a href="https://github.com/ItamarMu"><img src="https://avatars2.githubusercontent.com/u/27651221?v=3" width="100px;" alt="ItamarMu"/><br /><sub><b>ItamarMu</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=ItamarMu" title="Code">💻</a></td>
<td align="center"><a href="https://github.com/ThinkDigitalSoftware"><img src="https://avatars3.githubusercontent.com/u/23037821?v=3" width="100px;" alt="Jonathan White"/><br /><sub><b>ThinkDigitalSoftware</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=ThinkDigitalSoftware" title="Code">💻</a></td>
  </tr>

  <tr>
  <td align="center"><a href="https://github.com/JeffryHermanto"><img src="https://avatars0.githubusercontent.com/u/35820325?v=3" width="100px;" alt="Jeffry Hermanto"/><br /><sub><b>Jeffry Hermanto</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=JeffryHermanto" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/ItamarMu"><img src="https://avatars3.githubusercontent.com/u/27651221?v=3" width="100px;" alt="ItamarMu"/><br /><sub><b>ItamarMu</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=ItamarMu" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/ened"><img src="https://avatars0.githubusercontent.com/u/269860?v=3" width="100px;" alt="Sebastian Roth"/><br /><sub><b>Sebastian Roth</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=ened" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/darkang3lz92"><img src="https://avatars3.githubusercontent.com/u/33158127?v=3" width="100px;" alt="Dango Mango"/><br /><sub><b>Dango Mango</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=darkang3lz92" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/Frezyx"><img src="https://avatars1.githubusercontent.com/u/40857927?v=3" width="100px;" alt="Stanislav Ilin"/><br /><sub><b>Stanislav Ilin</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=Frezyx" title="Code">💻</a></td>
   <td align="center"><a href="https://github.com/VarunBarad"><img src="https://avatars0.githubusercontent.com/u/8678857?v=3" width="100px;" alt="Varun Barad"/><br /><sub><b>Varun Barad</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=VarunBarad" title="Code">💻</a></td>
   <td align="center"><a href="https://github.com/mohak852"><img src="https://avatars0.githubusercontent.com/u/58987025?v=3" width="100px;" alt="Mohak Shrivastava"/><br /><sub><b>Mohak Shrivastava</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=mohak852" title="Code">💻</a></td>
   <td align="center"><a href="https://github.com/ItamarMu"><img src="https://avatars0.githubusercontent.com/u/27651221?v=3" width="100px;" alt="ItamarMu"/><br /><sub><b>ItamarMu</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=ItamarMu" title="Code">💻</a></td>
   <td align="center"><a href="https://github.com/Margarets00"><img src="https://avatars0.githubusercontent.com/u/39041161?v=3" width="100px;" alt="Kim Minju"/><br /><sub><b>Kim Minju</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=Margarets00" title="Code">💻</a></td>
  </tr>

  <tr>
  <td align="center"><a href="https://github.com/JSBmanD"><img src="https://avatars3.githubusercontent.com/u/5402335?s=400&v=4" width="100px;" alt="Dmitry Vakhnin"/><br /><sub><b>Dmitry Vakhnin</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=JSBmanD" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/serendipity1004"><img src="https://avatars3.githubusercontent.com/u/20388249?s=400" width="100px;" alt="serendipity1004"/><br /><sub><b>Jiho Choi</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=serendipity1004" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/jobfeikens"><img src="https://avatars.githubusercontent.com/u/25356841?s=400&u=3f23a86b454b541fbcd88c9ed4a5f36df914dd03&v=4" width="100px;" alt="jobfeikens"/><br /><sub><b>Job</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=jobfeikens" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/BrunoEleodoro"><img src="https://avatars2.githubusercontent.com/u/20596317?s=400" width="100px;" alt="BrunoEleodoro"/><br /><sub><b>Bruno Eleodoro Roza</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=BrunoEleodoro" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/tgbarker"><img src="https://avatars.githubusercontent.com/u/2621350?s=400&v=4" width="100px;" alt="tgbarker"/><br /><sub><b>tgbarker</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=tgbarker" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/karabanovbs"><img src="https://avatars.githubusercontent.com/u/14288495?s=400&v=4" width="100px;" alt="karabanovbs"/><br /><sub><b>karabanovbs</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=karabanovbs" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/adarsh-technocrat"><img src="https://avatars.githubusercontent.com/u/14288495?s=400&v=4" width="100px;" alt="adarsh-technocrat"/><br /><sub><b>Adarsh kumar singh</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=adarsh-technocrat" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/adrianFarkas"><img src="https://avatars.githubusercontent.com/u/45693911?v=4" width="100px;" alt="adrianFarkas"/><br /><sub><b>Farkas Adrián</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=adrianFarkas" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/grafovdenis"><img src="https://avatars.githubusercontent.com/u/20505376?v=4" width="100px;" alt="grafovdenis"/><br /><sub><b>Denis Grafov</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=grafovdenis" title="Code">💻</a></td>
  
  </tr>
  <tr>
  <td align="center"><a href="https://github.com/ItzNotABug"><img src="https://avatars.githubusercontent.com/u/20625965?v=4" width="100px;" alt="ItzNotABug"/><br /><sub><b>DarShan</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=ItzNotABug" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/dhruvanbhalara"><img src="https://avatars.githubusercontent.com/u/53393418?v=4" width="100px;" alt="dhruvanbhalara"/><br /><sub><b>Dhruvan Bhalara</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=dhruvanbhalara" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/rodion-m"><img src="https://avatars.githubusercontent.com/u/36400912?v=4" width="100px;" alt="rodion-m"/><br /><sub><b>Rodion Mostovoy</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=rodion-m" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/nerotyc"><img src="https://avatars.githubusercontent.com/u/25231329?v=4" width="100px;" alt="nerotyc"/><br /><sub><b>Robin Holzinger</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=nerotyc" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/Graaggas"><img src="https://avatars.githubusercontent.com/u/24309240?v=4" width="100px;" alt="Graaggas"/><br /><sub><b>Deyew Vladimir</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=Graaggas" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/Add00w"><img src="https://avatars.githubusercontent.com/u/35359329?v=4" width="100px;" alt="Add00w"/><br /><sub><b>Abdullahi A. Addow</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=Add00w" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/vlkonoshenko"><img src="https://avatars.githubusercontent.com/u/15077780?v=4" width="100px;" alt="vlkonoshenko"/><br /><sub><b>Konoshenko Vlad</b></sub></a><br /><a href="https://github.com/adar2378/pin_code_fields/commits?author=vlkonoshenko" title="Code">💻</a></td>
  </tr>
</table>

**The pin code text field widget example**

```Dart
PinCodeTextField(
  length: 6,
  obscureText: false,
  animationType: AnimationType.fade,
  pinTheme: PinTheme(
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(5),
    fieldHeight: 50,
    fieldWidth: 40,
    activeFillColor: Colors.white,
  ),
  animationDuration: Duration(milliseconds: 300),
  backgroundColor: Colors.blue.shade50,
  enableActiveFill: true,
  errorAnimationController: errorController,
  controller: textEditingController,
  onCompleted: (v) {
    print("Completed");
  },
  onChanged: (value) {
    print(value);
    setState(() {
      currentText = value;
    });
  },
  beforeTextPaste: (text) {
    print("Allowing to paste $text");
    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
    //but you can show anything you want here, like your pop up saying wrong paste format or etc
    return true;
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

**Haptic Feedbacks can be among these 5 types**

```Dart
enum HapticFeedbackTypes {
  heavy,
  light,
  medium,
  selection,
  vibrate,
}

```

**Trigger Error animation**<br>

1. Create a StreamController<ErrorAnimationType>

```Dart
StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
```

2. And pass the controller like this.

```Dart
PinCodeTextField(
  length: 6,
  obscureText: false,
  animationType: AnimationType.fade,
  animationDuration: Duration(milliseconds: 300),
  errorAnimationController: errorController, // Pass it here
  onChanged: (value) {
    setState(() {
      currentText = value;
    });
  },
)
```

3. Then you can trigger the animation just by writing this:

```Dart
errorController.add(ErrorAnimationType.shake); // This will shake the pin code field
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

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: FlareActor(
                  "assets/otp.flr",
                  animation: "otp",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
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
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 50,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      backgroundColor: Colors.blue.shade50,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
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
                      formKey.currentState.validate();
                      // conditions for validating
                      if (currentText.length != 6 || currentText != "towtow") {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
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
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  ),
                  FlatButton(
                    child: Text("Set Text"),
                    onPressed: () {
                      textEditingController.text = "123456";
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
```
