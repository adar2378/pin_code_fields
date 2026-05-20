## 9.4.0

 - **FIX**: suppress semantic hint and focused state when disabled (#427).
 - **FIX**: reorder inputFormatters so user formatters run before length limit.
 - **FIX**: reorder inputFormatters so user formatters run before length limit.
 - **FEAT**: add semanticHintBuilder for customizable accessibility hints.
 - **FEAT**: add custom input formatters demo.
 - **FEAT**: add mainAxisSize property for flexible sizing.
 - **FEAT**: add custom input formatters demo.

## 9.3.0

 - **FEAT**: add `semanticHintBuilder` parameter for customizable accessibility hints.
   - Enables localization of screen reader hints to different languages
   - Supports custom terminology (e.g., "characters" instead of "digits")
   - Allows static hints for context-specific guidance
   - Maintains backward compatibility with default English hints
   - Fixes #424

## 9.2.0

 - **FIX**: reorder inputFormatters so user formatters run before length limit.

# Changelog

## [9.1.0] - Theme Extension & Material Form Field

### Features ✨

- **Theme Extension**: Added `MaterialPinThemeExtension` for embedding `MaterialPinTheme` in `ThemeData`
  - Register a default PIN theme at the app level using `ThemeData.extensions`
  - Access the theme anywhere with `Theme.of(context).materialPinTheme`
  - Supports light/dark theme configurations
  - `MaterialPinField` automatically uses the global theme when no explicit `theme` is provided
  - Added example demo showing app-wide theming usage
- **MaterialPinFormField**: New Material Design form field with built-in `Form` validation
  - Combines `MaterialPinField` styling with `FormField` capabilities (`validator`, `onSaved`, `autovalidateMode`)
  - Dual error states: controller errors trigger shake animation, form validation shows error text below the field
  - Theme resolution from widget prop, `ThemeData` extension, or default
  - `reset()` clears both text and controller error state

### Bug Fixes 🐛

- **PinInputFormField**: Added missing parameters that exist in `PinInput` — `onClipboardFound`, `clipboardValidator`, `onLongPress`, `onTapOutside`, `mouseCursor`, `semanticLabel`

### Documentation 📚

- Updated README with "App-Wide Theming" section
- Added code examples for theme extension setup and usage

---

## [9.0.0] - Major Architecture Refactor

### Breaking Changes ⚠️

This is a complete rewrite with a new headless architecture. Migration required.

- **New Headless Architecture**: The package now provides both a headless core (`PinInput`) and a Material Design implementation (`MaterialPinField`)
- **Unified Controller**: `PinInputController` replaces separate `TextEditingController`, `FocusNode`, and `errorAnimationController`
- **Theme System**: New `MaterialPinTheme` with automatic `ColorScheme` resolution
- **Renamed Parameters**: See migration guide below

### Features ✨

- **Headless Core**: Build completely custom PIN UIs with `PinInput` and `PinCellData`
- **Material Design Ready**: Use `MaterialPinField` for beautiful, ready-to-use PIN fields
- **PinInputController**: Single controller for text, focus, and error state management
  - `setText()`, `clear()`, `text` - Text control
  - `triggerError()`, `clearError()`, `hasError` - Error control
  - `requestFocus()`, `unfocus()`, `hasFocus` - Focus control
- **Improved Animations**: Scale, fade, slide, and none animation types
- **All Cell Shapes**: Outlined, filled, underlined, and circle
- **Text Gradient**: Apply gradients to PIN text via `MaterialPinTheme.textGradient`
- **Custom Obscuring Widget**: Use any widget for obscuring with `obscuringWidget`
- **Form Integration**: `PinInputFormField` for form validation
- **SMS Autofill**: Full autofill support with `enableAutofill` and `autofillHints`
- **Haptic Feedback**: Configurable haptic feedback types
- **Accessibility (Semantics)**: Full screen reader support with `semanticLabel` parameter
  - Announces field purpose (e.g., "6-digit PIN code field")
  - Provides hints about remaining digits
  - Masks values when obscured for privacy
  - Exposes enabled/focused states
- **`cursorAlignment`**: Position custom cursor widgets within cells (e.g., underscore at bottom)
- **`onClipboardFound`**: Callback when clipboard contains valid PIN-like content on focus
- **`onTapOutside`**: Callback when user taps outside the field
- **`errorText` & `errorBuilder`**: Custom error display below the PIN field
- **`followingFillColor` & `followingBorderColor`**: Style for cells after the focused cell
- **`completeFillColor`, `completeBorderColor` & `completeTextStyle`**: Style when all cells are filled

### Bug Fixes 🐛

- **iOS App Hang fix**: All `Clipboard.getData` calls are now guarded with a 500 ms timeout so a stalled native clipboard never blocks the UI thread
- **Focus-triggered clipboard probe deferred**: `_checkClipboard()` dispatched via `addPostFrameCallback` instead of running synchronously inside the focus listener
- **Long-press paste deferred**: Default context menu no longer triggers an eager clipboard read; clipboard data is read only after the user explicitly taps Paste
- **Centralised safe clipboard helper**: All clipboard reads go through `_safeClipboardRead()` with `try/catch` + `.timeout()`
- **Focus on complete**: Last cell now shows focused state when PIN is complete and field is focused
- **Cursor alignment**: Fixed custom cursor positioning - removed internal `Center` widget that was overriding alignment
- **Web input**: Fixed text input not working on web by adjusting invisible text field configuration
- **Controller notifications**: Fixed `PinInputController` not notifying listeners on focus/text changes

### Example App 📱

- Added comprehensive use case demos (OTP verification, PIN setup, PIN login, payment confirmation, invite codes, app lock screen)
- Added feature demos for all customization options
- Added interactive **Playground** for real-time customization of all options

### Documentation 📚

- Updated README with demo GIFs showcasing all features
- Added static screenshots for pub.dev gallery

### Migration Guide

#### Parameter Renames

| Old Name | New Name |
|----------|----------|
| `controller` | `pinController.textController` |
| `focusNode` | `pinController.focusNode` |
| `useHapticFeedback` | `enableHapticFeedback` |
| `hapticFeedbackTypes` | `hapticFeedbackType` |
| `animationType` | `theme.entryAnimation` |
| `enableContextMenu` | `enablePaste` |
| `errorAnimationController` | `pinController.triggerError()` |
| `pinTheme` | `theme` (MaterialPinTheme) |
| `enablePinAutofill` | `enableAutofill` |

#### Basic Migration

**Before (v8.x):**
```dart
PinCodeTextField(
  appContext: context,
  length: 6,
  controller: textController,
  focusNode: focusNode,
  pinTheme: PinTheme(
    shape: PinCodeFieldShape.box,
    activeColor: Colors.blue,
  ),
  onChanged: (value) {},
  onCompleted: (value) {},
)
```

**After (v9.0):**
```dart
final pinController = PinInputController();

MaterialPinField(
  length: 6,
  pinController: pinController,
  theme: MaterialPinTheme(
    shape: MaterialPinShape.outlined,
    focusedBorderColor: Colors.blue,
  ),
  onChanged: (value) {},
  onCompleted: (value) {},
)
```

#### Error Handling Migration

**Before:**
```dart
final errorController = StreamController<ErrorAnimationType>();
errorController.add(ErrorAnimationType.shake);
```

**After:**
```dart
final pinController = PinInputController();
pinController.triggerError();  // Triggers shake + sets error state
pinController.clearError();    // Clears error state
```

---

## [8.0.1]

- Added `activeBorderWidth`, `selectedBorderWidth`, `inactiveBorderWidth`, `disabledBorderWidth`, `errorBorderWidth`

## [8.0.0]

- Updated Dart SDK constraint `sdk: ">=2.12.0 <4.0.0"`
- Use `PinCodePlatform` instead `Platform` enum
- Numerous bug fixes, thanks to each and every contributor for resolving issues

## [7.4.0]

- Added new attributes `readOnly`, `textGradient`, `errorTextDirection`, `errorTextMargin`, `autoUnfocus`
- Resolved blinkDebounce `setState()` after `dispose()` bug
- Example app refactor

## [7.3.0]

- Fixed extra padding if autoValidate is not provided
- Added ScrollPadding, errorBorderColor

## [7.2.0]

- Much requested feature placeholder has been added `hintCharacter`
- `hintStyle` has been added to customize the hint TextStyle

## [7.1.0]

- Added `useExternalAutoFillGroup` to use this widget with external `AutofillGroup`
- Added `fieldOuterPadding` to add extra padding on each cells. Default to 0.0

## [7.0.0]

- Added null-safety to the main branch

## [6.1.0]

- Added haptic feedback
- Added animated obscure widget support `obscuringWidget` and `blinkWhenObscuring`

## [6.0.0]

- Added Cursor support
- Added boxShadows
- Minimum Flutter version is set to 1.22.0

## [5.0.0]

- Added iOS autofill with Flutter version 1.20.0
- Added onSave, onTap callbacks
- Added PastedTextStyle

## [4.0.0]

- Added support for flutter-web

## [3.0.0]

- Introduced `PinTheme` & `DialogConfig`
- Added `beforeTextPaste` callback
- Added `onCompleted` callback

## [2.0.0]

- Added animations while changing value
- Added multiple customization parameters
- Pressing backspace focuses previous field
