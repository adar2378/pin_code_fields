<p align="center">
  <img width="460" src="https://i.ibb.co/X5qxF7x/export-banner.png">
</p>

<p align="center">
  <a href="https://pub.dev/packages/pin_code_fields"><img src="https://img.shields.io/pub/v/pin_code_fields"></a>
  <a href="https://pub.dev/packages/pin_code_fields/score"><img src="https://img.shields.io/pub/likes/pin_code_fields"></a>
  <a href="https://pub.dev/packages/pin_code_fields/score"><img src="https://img.shields.io/pub/points/pin_code_fields"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
</p>

A highly customizable Flutter package for PIN code and OTP input fields with beautiful design and animations. Now with a **headless architecture** for complete customization freedom!

**[Live Showcase](https://adar2378.github.io/pin_code_fields/)** — Try all features in your browser

## Demos

<table>
  <tr>
    <td align="center"><b>OTP Verification</b></td>
    <td align="center"><b>Payment PIN</b></td>
    <td align="center"><b>App Lock</b></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/main/packages/pin_code_fields/screenshots/otp_verification.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/main/packages/pin_code_fields/screenshots/payment.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/main/packages/pin_code_fields/screenshots/lock_screen.gif" width="250"/></td>
  </tr>
</table>

<table>
  <tr>
    <td align="center"><b>Creative Animations</b></td>
    <td align="center"><b>Custom Cursors</b></td>
    <td align="center"><b>Text Gradients</b></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/main/packages/pin_code_fields/screenshots/creative_animations.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/main/packages/pin_code_fields/screenshots/cursors.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/adar2378/pin_code_fields/main/packages/pin_code_fields/screenshots/gradient_texts.gif" width="250"/></td>
  </tr>
</table>

## Features

- **Headless Core**: Build completely custom PIN UIs with full control
- **Material Design Ready**: Beautiful, ready-to-use Material Design implementation
- **App-Wide Theming**: Set default PIN themes in `ThemeData` for consistent styling
- **Unified Controller**: Single `PinInputController` for text, focus, and error management
- **Multiple Shapes**: Outlined, filled, underlined, and circle styles
- **Rich Animations**: Scale, fade, slide animations for text entry
- **Error Handling**: Built-in shake animation with programmatic control
- **Autofill Support**: SMS OTP autofill for iOS and Android
- **Haptic Feedback**: Configurable haptic feedback on input
- **Form Integration**: `MaterialPinFormField` for Material + validation, `PinInputFormField` for custom UIs
- **Paste Support**: Long-press to paste from clipboard
- **Cursor Support**: Animated blinking cursor
- **Text Gradient**: Apply beautiful gradients to PIN text
- **Custom Obscuring**: Use any widget for obscured text

## Getting Started ⚡️

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  pin_code_fields: ^10.0.0
  material_ui: ^1.0.0
```

Requires **Flutter 3.44+** (tested on **Flutter 3.47**). `pin_code_fields` now depends on the standalone [`material_ui`](https://pub.dev/packages/material_ui) and [`cupertino_ui`](https://pub.dev/packages/cupertino_ui) packages introduced in Flutter 3.47.

If you are still on `package:flutter/material.dart`, run:

```bash
dart fix --apply --code=migrate_design_widgets
```

### Quick Start - Material Design

```dart
import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

MaterialPinField(
  length: 6,
  onCompleted: (pin) => print('PIN: $pin'),
  onChanged: (value) => print('Changed: $value'),
  theme: MaterialPinTheme(
    shape: MaterialPinShape.outlined,
    cellSize: Size(56, 64),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

### Custom UI - Headless Core

For complete control over the UI, use the headless `PinInput`:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

PinInput(
  length: 4,
  builder: (context, cells) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cells.map((cell) {
        return Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cell.isFocused ? Colors.blue : Colors.grey[200],
          ),
          child: Center(
            child: Text(
              cell.character ?? '',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      }).toList(),
    );
  },
  onCompleted: (pin) => print('PIN: $pin'),
)
```

## PinInputController 🎮

The unified controller for managing PIN input state:

```dart
final controller = PinInputController();

MaterialPinField(
  length: 6,
  pinController: controller,
  onCompleted: (pin) {
    if (pin != '123456') {
      controller.triggerError(); // Triggers shake + error state
    }
  },
)

// Text control
controller.setText('1234');
controller.clear();
print(controller.text);

// Error control
controller.triggerError();  // Shake animation + error state
controller.clearError();    // Clear error state
print(controller.hasError);

// Focus control
controller.requestFocus();
controller.unfocus();
print(controller.hasFocus);

// Listen to changes
controller.addListener(() {
  print('State changed');
});
```

## Material Shapes 🎨

```dart
// Outlined (default)
MaterialPinTheme(shape: MaterialPinShape.outlined)

// Filled
MaterialPinTheme(shape: MaterialPinShape.filled)

// Underlined
MaterialPinTheme(shape: MaterialPinShape.underlined)

// Circle
MaterialPinTheme(shape: MaterialPinShape.circle)
```

## App-Wide Theming 🎨

Register a default `MaterialPinTheme` in your app's `ThemeData` to use consistent PIN styling across your entire app:

### Setup

```dart
MaterialApp(
  theme: ThemeData(
    // ... other theme properties
    extensions: const [
      MaterialPinThemeExtension(
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          cellSize: Size(56, 64),
          spacing: 12,
        ),
      ),
    ],
  ),
  darkTheme: ThemeData(
    // ... other dark theme properties
    extensions: const [
      MaterialPinThemeExtension(
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          cellSize: Size(56, 64),
          spacing: 12,
        ),
      ),
    ],
  ),
)
```

### Automatic Theme Usage

When you register a `MaterialPinThemeExtension` in your `ThemeData`, `MaterialPinField` will automatically use it when no explicit `theme` parameter is provided:

```dart
MaterialPinField(
  length: 6,
  // No theme parameter - automatically uses ThemeData
)
```

### Accessing the Theme Manually

If you need to access the theme for custom logic or to override specific properties:

```dart
// Using the convenience extension
final pinTheme = Theme.of(context).materialPinTheme;

// Using the standard extension method
final pinTheme = Theme.of(context).extension<MaterialPinThemeExtension>()?.theme;

MaterialPinField(
  length: 6,
  theme: pinTheme ?? const MaterialPinTheme(),
)
```

### Light & Dark Themes

You can provide different themes for light and dark modes:

```dart
MaterialApp(
  theme: ThemeData(
    brightness: Brightness.light,
    extensions: [
      MaterialPinThemeExtension(
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          borderColor: Colors.grey,
          focusedBorderColor: Colors.blue,
        ),
      ),
    ],
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    extensions: [
      MaterialPinThemeExtension(
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          borderColor: Colors.grey.shade700,
          focusedBorderColor: Colors.blue.shade300,
        ),
      ),
    ],
  ),
)
```

## Customization Options ⚙️

### MaterialPinTheme

```dart
MaterialPinTheme(
  // Shape
  shape: MaterialPinShape.outlined,
  cellSize: Size(56, 64),
  spacing: 8,
  borderRadius: BorderRadius.circular(12),

  // Border
  borderWidth: 1.5,
  focusedBorderWidth: 2.0,
  borderColor: Colors.grey,
  focusedBorderColor: Colors.blue,
  filledBorderColor: Colors.green,
  errorColor: Colors.red,

  // Fill
  fillColor: Colors.grey[100],
  focusedFillColor: Colors.blue[50],
  filledFillColor: Colors.green[50],

  // Text
  textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  textGradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
  obscuringCharacter: '●',

  // Cursor
  showCursor: true,
  cursorColor: Colors.blue,
  cursorWidth: 2,
  animateCursor: true,

  // Animation
  entryAnimation: MaterialPinAnimation.scale,
  animationDuration: Duration(milliseconds: 150),
  animationCurve: Curves.easeOut,

  // Error
  enableErrorShake: true,
  errorAnimationDuration: Duration(milliseconds: 500),
)
```

### Obscure Text

```dart
// With character
MaterialPinField(
  length: 4,
  obscureText: true,
  blinkWhenObscuring: true,
  blinkDuration: Duration(milliseconds: 500),
  theme: MaterialPinTheme(obscuringCharacter: '●'),
)

// With custom widget
MaterialPinField(
  length: 4,
  obscureText: true,
  obscuringWidget: Icon(Icons.lock, size: 16),
)
```

### Autofill Support

```dart
MaterialPinField(
  length: 6,
  enableAutofill: true,
  autofillHints: [AutofillHints.oneTimeCode],
)
```

### Form Integration

Two form field widgets are available depending on your needs:

| Widget | Use when |
|--------|----------|
| `MaterialPinFormField` | You want Material styling + form validation out of the box |
| `PinInputFormField` | You need a fully custom UI with your own builder |

#### MaterialPinFormField (recommended)

Material Design styling with built-in form validation, error shake animation, and error text display:

```dart
Form(
  child: MaterialPinFormField(
    length: 6,
    theme: MaterialPinTheme(shape: MaterialPinShape.outlined),
    validator: (value) {
      if (value == null || value.length < 6) {
        return 'Please enter all 6 digits';
      }
      return null;
    },
    onSaved: (value) => print('Saved: $value'),
  ),
)
```

#### PinInputFormField (headless)

For fully custom UIs — you provide the builder, the form handles validation:

```dart
Form(
  child: PinInputFormField(
    length: 6,
    pinBuilder: (context, cells) => /* your custom UI */,
    validator: (value) {
      if (value == null || value.length < 6) {
        return 'Please enter all 6 digits';
      }
      return null;
    },
    onSaved: (value) => print('Saved: $value'),
  ),
)
```

## Cell Data (Headless) 📦

When using `PinInput`, the builder receives a list of `PinCellData`:

```dart
PinCellData(
  index: 0,           // Cell position (0-based)
  character: '1',     // Entered character (null if empty)
  isFilled: true,     // Has a character
  isFocused: false,   // Is the current input position
  isError: false,     // Error state active
  isDisabled: false,  // Read-only state
  isBlinking: false,  // Showing real char before obscure
)
```

## Migration from v9.x 🔄

v10.0.0 is a **major** release for Flutter 3.47: Material and Cupertino now live in standalone packages.

1. Upgrade Flutter (`flutter upgrade` to 3.47, or at least 3.44).
2. Bump the dependency to `pin_code_fields: ^10.0.0` and add `material_ui: ^1.0.0`.
3. Replace `package:flutter/material.dart` with `package:material_ui/material_ui.dart` (`dart fix --apply --code=migrate_design_widgets`).
4. If some of your dependencies still use the SDK Material library, wrap the app with `MaterialUiCompatibilityBridge`.

📖 **Full migration guide**: [migration/10.0.0/MIGRATION_GUIDE.md](https://github.com/adar2378/pin_code_fields/blob/main/packages/pin_code_fields/migration/10.0.0/MIGRATION_GUIDE.md)

## Migration from v8.x 🔄

Upgrading from v8.x? Here's a quick reference:

| v8.x | v9.0.0 |
|------|--------|
| `PinCodeTextField` | `MaterialPinField` |
| `appContext: context` | *(removed)* |
| `controller` + `focusNode` | `pinController: PinInputController()` |
| `pinTheme: PinTheme()` | `theme: MaterialPinTheme()` |
| `PinCodeFieldShape.box` | `MaterialPinShape.outlined` |
| `fieldWidth` + `fieldHeight` | `cellSize: Size(w, h)` |
| `errorAnimationController.add(...)` | `controller.triggerError()` |

📖 **Full migration guide**: [migration/9.0.0/MIGRATION_GUIDE.md](https://github.com/adar2378/pin_code_fields/blob/main/packages/pin_code_fields/migration/9.0.0/MIGRATION_GUIDE.md)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) for details.
