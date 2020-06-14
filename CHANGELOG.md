[3.1.2] Documentation update

[3.1.1] Documentation update

## [3.1.0]

Better performance overall

### Features  ✨
- Added new parameter called `validator`, `autoValidate` & `errorTextSpace`. 

### Breaking changes ⚠️  
- The internal `TextField` has been changed to `TextFormField` to work with `Form`
- The debug logs will not be printed in release builds.

## [3.0.1]

Better Performance overall

### Updates  ✨
 - Fixed bug where calling setState will not reflect the change on the parent view
 

---

## [3.0.0]

Better performance overall

### Features  ✨
- Added new parameter called `bool Function(String text) beforeTextPaste`, a callback method to validate if text can be pasted. 
- Introduced `PinTheme` & `DialogConfig`
- Added an optional constructor parameter: `void Function(String) onCompleted`. which triggers when all fields are filled.

### Fixes  🐛
- When pressing the back button to close the keyboard, you can't open the keyboard back up again. #51
- When we long press on the OTP field to paste the code & if clipboard data is NULL, it gets crashed. #45

### Breaking changes ⚠️  
- Removed all the color, cell height, width & dialogconfiguration and moved them in `PinTheme` and `DialogConfig`

[2.5.1] Documentation update

## [2.5.0]

Better Performance overall

### Updates  ✨
 - Added errorAnimationController to trigger shake animation. Can be used for errors.
 - Added autoDisposeControllers which can be set to true for auto TextEidtingController and FocusNode disposal.
 - Fixed typos & Optimzied code
 

---

## [2.4.0]

Better Performance overall

### Updates  ✨
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

### Updates  ✨

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

### Features  ✨
- Colors:
  - `selectedColor` is the color set on the current index. Default is `Colors.blue`
  - `disabledColor` is the color if the TextField is disabled. Default is `Colors.grey`
- Optional `focusNode` can be passed to the constructor to manage it from outside.
  - Added a listener to the focusNode which triggers a rebuild on every change so it'll reflect the correct color on each pin.
- Added a new constructor parameter called `enabled`. Default is true
- Added an optional constructor parameter: `void Function(String) onCompleted`. which triggers when all fields are filled.

### Fixes  🐛
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
