# [7.4.0]

- Added new attributes`readOnly`, `textGradient`, `errorTextDirection`, `errorTextMargin`, `autoUnfocus`
- Resolved blinkDebounce `setState()` after `dispose()` bug.
- Example app refactor

# [7.3.0]

- Fixed extra padding if autoValidate is not provided
- Added ScrollPadding, errorBorderColor

# [7.2.0]

- Much requested feature placeholder has been added `hintCharacter`
- `hintStyle` has been added to customize the hint TextStyle

# [7.1.0]

- Added `useExternalAutoFillGroup` to use this widget with external `AutofillGroup`
- Added `fieldOuterPadding` to add extra padding on each cells. Default to 0.0

# [7.0.0]

- Added null-safety to the main branch.

# [7.0.0-nullsafety]

### Features ✨

- Added `AutofillContextAction`, default is `AutofillContextAction.commit`

### Breaking changes ⚠️

- Migrated to null-safety.
- Minimum Flutter version is set to 1.22.0

### Fixes 🐛

- Fixed default text value not showing, #153

### Fixes 🐛

- Reopen keyboard onTap on the cells #92, thanks to https://github.com/YaroslavGS for the suggestion

# [6.1.0]

### Features ✨

- Added haptic feedback
  `enum HapticFeedbackTypes { heavy, light, medium, selection, vibrate, }`
- Added animated obscure widget support `obscuringWidget` and `blinkWhenObscuring`

### Fixes 🐛

- Fixed bug related to TextStyle not given.
- Fixed bug related to setState is being called after disposal.

[6.0.2] - Added fallback color when the cursor color fails to retrive and fixed deprecated `List` constructors.

[6.0.1] - Fixed read-only warning when field is not `enabled` & cursor animation now only triggers if `showCursor = true`

# [6.0.0]

### Features ✨

- Added Cursor
  `
  /// Whether to show cursor or not
  final bool showCursor;

  /// The color of the cursor, default to Theme.of(context).accentColor
  final Color cursorColor;

  /// width of the cursor, default to 2
  final double cursorWidth;

  /// Height of the cursor, default to FontSize + 8;
  final double cursorHeight;
  `

- Added boxhShadows

### Breaking changes ⚠️

- `autoValidate` changed according to the new version of Flutter
- Minimum Flutter version is set to 1.22.0

### Fixes 🐛

- typo fixes

# [5.2.0]

### Features ✨

- Added `obscuringCharacter`, Must not be empty. Single character is recommended.
  Default is ● - 'Black Circle' (U+25CF)

### Fixes 🐛

- Fixed typo
- Dispose error animation stream when widget is disposed

# [5.1.0]

### Features ✨

- Added `errorAnimationDuration` to customize Error animation duration.
- Added `enablePinAutofill` to enable or disable the auto-fill feature.

### Breaking changes ⚠️

- Chagned `textInputType` to more familiar `keyboardType` to change they keyboard type

### Fixes 🐛

- Fixed rootNavigator issue for paste dialogs, #101

[5.0.1] - onTap bug fixed, used root navigator for showing dialogs

# [5.0.0]

### Features ✨

- Added onSave, onTap callbacks.
- Added PastedTextStyle.
- Added iOS autofill added wtih Flutter version 1.20.0

### Breaking changes ⚠️

- Must provide context in the `appContext` parameter.
- Minimum Flutter version is set to 1.20.0

### Fixes 🐛

- Reopen keyboard onTap on the cells #92, thanks to https://github.com/YaroslavGS for the suggestion

# [4.0.0]

### Features ✨

- Added support for flutter-web

### Breaking changes ⚠️

- Replaced internal automatic OS selection for dialog styles, you can select which style you want by configuring with the DialogConfig

[3.1.2] Documentation update

[3.1.1] Documentation update

## [3.1.0]

Better performance overall

### Features ✨

- Added new parameter called `validator`, `autoValidate` & `errorTextSpace`.

### Breaking changes ⚠️

- The internal `TextField` has been changed to `TextFormField` to work with `Form`
- The debug logs will not be printed in release builds.

## [3.0.1]

Better Performance overall

### Updates ✨

- Fixed bug where calling setState will not reflect the change on the parent view

---

## [3.0.0]

Better performance overall

### Features ✨

- Added new parameter called `bool Function(String text) beforeTextPaste`, a callback method to validate if text can be pasted.
- Introduced `PinTheme` & `DialogConfig`
- Added an optional constructor parameter: `void Function(String) onCompleted`. which triggers when all fields are filled.

### Fixes 🐛

- When pressing the back button to close the keyboard, you can't open the keyboard back up again. #51
- When we long press on the OTP field to paste the code & if clipboard data is NULL, it gets crashed. #45

### Breaking changes ⚠️

- Removed all the color, cell height, width & dialogconfiguration and moved them in `PinTheme` and `DialogConfig`

[2.5.1] Documentation update

## [2.5.0]

Better Performance overall

### Updates ✨

- Added errorAnimationController to trigger shake animation. Can be used for errors.
- Added autoDisposeControllers which can be set to true for auto TextEidtingController and FocusNode disposal.
- Fixed typos & Optimzied code

---

## [2.4.0]

Better Performance overall

### Updates ✨

- Optional: Exposed TextCapitalization, TextInputAction.
- Added background color customization for each cell(SelectedCell, UnselectedCell and InactiveCell). But you must set `enableActiveFill = true`.
- Added warning messages
- Fixed typos & Optimzied code

---

[2.3.0+3] Fixed bug regarding misplaced cursor selection.

[2.3.0+2] - Fixed bug where after opening keyboard the view will not automatically scroll up.

[2.3.0+1] - Updated documentation

## [2.3.0]

Better Performance overall

### Updates ✨

- Optional: Exposed `controller` so that one can control the texts programmatically
- Updated the example code with clear and set manual text buttons.
- Fixed minor bugs and optimized code

---

[2.2.1+2] - Added two more parameters, affirmativeText and negativeText

[2.2.1+1] - Added two more parameters, dialogTitle and dialogContent

[2.2.1] - Reformatted the code, made the whole widget clickable

[2.2.0+4] - Documentation updated

[2.2.0+3] - Documentation updated

[2.2.0+2] - Allowed transparent background color

[2.2.0+1] - Documentation updated

## [2.2.0]

Better performance overall

### Features ✨

- Colors:
  - `selectedColor` is the color set on the current index. Default is `Colors.blue`
  - `disabledColor` is the color if the TextField is disabled. Default is `Colors.grey`
- Optional `focusNode` can be passed to the constructor to manage it from outside.
  - Added a listener to the focusNode which triggers a rebuild on every change so it'll reflect the correct color on each pin.
- Added a new constructor parameter called `enabled`. Default is true
- Added an optional constructor parameter: `void Function(String) onCompleted`. which triggers when all fields are filled.

### Fixes 🐛

- Colors:
  - `activeColor` and `inactiveColor` were swapped
- Keyboard does not show up onTap #4

### Breaking changes ⚠️

- Renamed `currentText` to `onChanged`

---

[2.1.1] - Fixed bug regarding ios autofill not triggering currentText callback

## [2.1.0]

### New Features 🥁🥁

- Added otp code pasting by pressing and holding the fields.
- iOS autofill support
- Revamped the example app with flare animation.
- Minor bug fixes

[2.0.4] - Added autofocus option and fixed bug regarding ugly cursor.

[2.0.3] - Fixed bug regarding keyboard not showing up after dismissing it.

[2.0.2] - Minor fixes.

[2.0.1] - Minor fixes.

## [2.0.0]

### New Features 🥁🥁

- Added new parameters such as backgroundColor, borderRadius, fieldHeight, fieldWidth, mainAxisAlignment, activeColor, inactiveColor, borderWidth, animationType, animationDuration, animationCurve, textInputType

- Supports animation while changing value of pin code field field

- Pressing backspace will focus the previous pin code field

### Breaking Changes 😥😥

- Removed onDone and onErrorCheck callbacks

- Removed shouldTriggerFucntions stream

- Removed Functions enum

- Changed PinCodeFieldShape.round to PinCodeFieldShape.circle

- Can not focus on individual pin code field anymore

[1.1.2] - Minor fixes.

[1.1.1] - Minor fixes.

## [1.1.0] - Added onDone and onError callbacks. Added 3 different types of shapes with custom TextStyle

[1.0.4] - Minor typo fixes.

[1.0.3] - Added more documentations.

[1.0.2] - Updated readme.

[1.0.1] - Changed gif file location.
