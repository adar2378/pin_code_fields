# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**pin_code_fields** is a Flutter package for creating highly customizable PIN code and OTP input fields. Version 9.0.0 introduces a **headless architecture** with separate core logic and Material Design implementation.

- **Repository**: https://github.com/adar2378/pin_code_fields
- **Min SDK**: Dart 3.5.0, Flutter 3.0.0+
- **Dependencies**: Only Flutter SDK (minimal dependencies approach)

## Monorepo Structure

This project uses **melos** for monorepo management:

```
pin_code_fields/                    # Repository root
├── melos.yaml                      # Melos configuration
├── pubspec.yaml                    # Workspace root (not publishable)
├── CLAUDE.md                       # This file
├── docs/
│   └── FEATURE_COMPARISON.md       # Feature tracking document
└── packages/
    └── pin_code_fields/            # Main publishable package
        ├── lib/
        │   ├── pin_code_fields.dart    # Single export file
        │   └── src/
        │       ├── core/               # Headless input engine
        │       └── material/           # Material Design implementation
        ├── test/
        ├── example/
        ├── pubspec.yaml
        ├── README.md
        ├── CHANGELOG.md
        └── LICENSE
```

## Development Commands

### With Melos (Recommended)

```bash
# Bootstrap workspace (install dependencies, link packages)
melos bootstrap

# Run tests
melos test

# Run analyzer
melos analyze

# Format code
melos format
```

### Direct Flutter Commands

```bash
# From packages/pin_code_fields/
flutter test
flutter analyze
flutter pub publish --dry-run
```

### Running Example

```bash
cd packages/pin_code_fields/example
flutter run
```

## Architecture

The package uses a **headless architecture** with two layers:

### Layer 1: Core (`src/core/`)

Headless input engine with zero visual opinion. Provides:

- **`PinInput`**: Main headless widget that captures input and provides cell data via builder
- **`PinCellData`**: Immutable data model describing each cell's state
- **`PinInputController`**: Unified controller for text, focus, and error management
- **`PinInputScope`**: InheritedWidget for dependency injection
- **`PinInputFormField`**: Form integration wrapper

Key files:
```
src/core/
├── pin_input.dart              # Main headless widget
├── pin_cell_data.dart          # Cell state data model
├── pin_input_controller.dart   # Unified controller
├── pin_input_scope.dart        # InheritedWidget for DI
├── haptics.dart                # Haptic feedback utilities
├── form/
│   └── pin_input_form_field.dart
├── input_capture/
│   └── invisible_text_field.dart   # Hidden EditableText
└── gestures/
    ├── selection_gesture_builder.dart
    └── context_menu_builder.dart
```

### Layer 2: Material (`src/material/`)

Ready-to-use Material Design implementation built on core:

- **`MaterialPinField`**: Main Material widget
- **`MaterialPinTheme`**: Theme configuration with ColorScheme resolution
- **`MaterialPinCell`**: Individual cell with animations
- **Shape decorations**: Outlined, filled, underlined, circle

Key files:
```
src/material/
├── material_pin_field.dart     # Main Material widget
├── theme/
│   └── material_pin_theme.dart # Theme + resolved data
├── cells/
│   ├── material_pin_cell.dart
│   └── material_cell_content.dart
├── shapes/
│   ├── outlined_decoration.dart
│   ├── filled_decoration.dart
│   ├── underlined_decoration.dart
│   └── circle_decoration.dart
├── animations/
│   ├── entry_animations.dart
│   ├── cursor_blink.dart
│   └── error_shake.dart
└── layout/
    └── material_pin_row.dart
```

## Key Components

### PinCellData

Immutable data model for each cell:

```dart
PinCellData(
  index: 0,           // Cell position (0-based)
  character: '1',     // Entered character (null if empty)
  isFilled: true,     // Has a character
  isFocused: false,   // Is the current input position
  isError: false,     // Error state active
  isDisabled: false,  // Read-only state
  wasJustEntered: false,  // Character typed this frame
  wasJustRemoved: false,  // Character deleted this frame
  isBlinking: false,  // Showing real char before obscure
)
```

### PinInputController

Unified controller replacing separate TextEditingController, FocusNode, and error stream:

```dart
final controller = PinInputController();

// Text control
controller.setText('1234');
controller.clear();
print(controller.text);

// Error control
controller.triggerError();  // Triggers shake + error state
controller.clearError();    // Clears error state
print(controller.hasError);

// Focus control
controller.requestFocus();
controller.unfocus();
print(controller.hasFocus);

// Access underlying controllers
controller.textController;  // TextEditingController
controller.focusNode;       // FocusNode
```

### MaterialPinTheme

Theme with automatic ColorScheme resolution:

```dart
MaterialPinTheme(
  shape: MaterialPinShape.outlined,
  cellSize: Size(56, 64),
  spacing: 8,
  borderRadius: BorderRadius.circular(12),
  // Colors (null = resolve from ColorScheme)
  borderColor: null,
  focusedBorderColor: null,
  errorColor: null,
  // Animation
  entryAnimation: MaterialPinAnimation.scale,
  animationDuration: Duration(milliseconds: 150),
)
```

## Design Patterns

### 1. Headless UI Pattern

Core provides data, consumer provides UI:

```dart
PinInput(
  length: 4,
  builder: (context, cells) {
    // Full control over rendering
    return Row(
      children: cells.map((cell) => MyCustomCell(cell)).toList(),
    );
  },
)
```

### 2. TextSelectionGestureDetectorBuilder

Used for native paste menu support:

```dart
class _PinInputState extends State<PinInput>
    implements TextSelectionGestureDetectorBuilderDelegate
```

### 3. Controller Attachment Pattern

PinInputController uses internal callbacks for widget communication:

```dart
// In PinInputController
void attach({VoidCallback? onErrorTriggered}) {
  _onErrorTriggered = onErrorTriggered;
}

// In _PinInputState
_effectivePinController.attach(onErrorTriggered: _triggerErrorAnimation);
```

### 4. Theme Resolution

MaterialPinTheme resolves null colors from ColorScheme:

```dart
MaterialPinThemeData resolve(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  return MaterialPinThemeData(
    borderColor: borderColor ?? colorScheme.outline,
    focusedBorderColor: focusedBorderColor ?? colorScheme.primary,
    // ...
  );
}
```

## Input Flow

```
User Types → Invisible EditableText → TextEditingController
    → Controller Listener → Haptic Feedback
    → Update Cell Data → Rebuild via setState
    → Call onChanged/onCompleted callbacks
```

## Important Implementation Details

### Input Formatting Order

In `InvisibleTextField._buildInputFormatters()`:
1. Custom user-provided formatters (`inputFormatters`) - Applied FIRST so they can normalise pasted text (e.g. strip whitespace)
2. `FilteringTextInputFormatter.digitsOnly` - Applied if `keyboardType == TextInputType.number`
3. `LengthLimitingTextInputFormatter(length)` - Applied LAST so it counts only the final characters

### Blink Effect for Obscured Text

When `blinkWhenObscuring` is true:
1. User types character
2. `_isBlinking = true`, real character shown
3. After `blinkDuration`, `_isBlinking = false`
4. Obscured content shown with AnimatedSwitcher transition

### Error Shake Animation

Managed by `ErrorShake` widget wrapping `PinInput`:
- Triggered via `PinInputController.triggerError()`
- Uses `SlideTransition` with elastic curve
- Duration configurable via `MaterialPinTheme.errorAnimationDuration`

## Common Pitfalls to Avoid

1. **Always check `mounted`** before setState after async operations
2. **Don't modify controller** during listener execution - use post-frame callback
3. **Dispose controllers** if you own them (PinInputController handles this internally)
4. **Use theme for colors** - don't hardcode in cell widgets
5. **Test on multiple platforms** - behaviors differ on iOS, Android, Web, Desktop

## Testing

Tests are in `packages/pin_code_fields/test/`:

```bash
cd packages/pin_code_fields
flutter test
```

Current test coverage:
- `pin_cell_data_test.dart` - PinCellData model tests
- `pin_input_test.dart` - PinInput widget tests

## Usage Examples

### Material Design (Quick)

```dart
import 'package:pin_code_fields/pin_code_fields.dart';

MaterialPinField(
  length: 6,
  pinController: controller,
  onCompleted: (pin) => print('PIN: $pin'),
  theme: MaterialPinTheme(
    shape: MaterialPinShape.outlined,
  ),
)
```

### Custom UI (Headless)

```dart
import 'package:pin_code_fields/pin_code_fields.dart';

PinInput(
  length: 4,
  builder: (context, cells) {
    return Row(
      children: cells.map((cell) => Container(
        width: 50,
        height: 50,
        color: cell.isFocused ? Colors.blue : Colors.grey,
        child: Center(child: Text(cell.character ?? '')),
      )).toList(),
    );
  },
)
```

## Feature Status

See `docs/FEATURE_COMPARISON.md` for complete feature tracking.

All features from v8.x are implemented:
- ✅ All cell shapes (outlined, filled, underlined, circle)
- ✅ All animations (scale, fade, slide, none)
- ✅ Error shake animation
- ✅ Obscure text with custom widget
- ✅ Text gradient
- ✅ Autofill support
- ✅ Haptic feedback
- ✅ Form integration
- ✅ Paste support
