/// Code snippets for the showcase code examples section.
abstract final class CodeSnippets {
  static const quickStart =
      '''import 'package:pin_code_fields/pin_code_fields.dart';

MaterialPinField(
  length: 6,
  onCompleted: (pin) => print('PIN: \$pin'),
  theme: MaterialPinTheme(
    shape: MaterialPinShape.outlined,
    cellSize: Size(56, 64),
    borderRadius: BorderRadius.circular(12),
  ),
)''';

  static const controller = '''final controller = PinInputController();

// Set text programmatically
controller.setText('1234');

// Clear
controller.clear();

// Trigger error shake
controller.triggerError();

// Clear error state
controller.clearError();

// Focus management
controller.requestFocus();
controller.unfocus();

// Read state
print(controller.text);      // "1234"
print(controller.hasFocus);  // true/false
print(controller.hasError);  // true/false

// Don't forget to dispose!
controller.dispose();''';

  static const headless =
      '''import 'package:pin_code_fields/pin_code_fields.dart';

PinInput(
  length: 4,
  builder: (context, cells) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cells.map((cell) {
        return Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: cell.isFocused
                ? Colors.blue.withOpacity(0.1)
                : Colors.grey.shade100,
            border: Border.all(
              color: cell.isFocused ? Colors.blue : Colors.grey,
              width: cell.isFocused ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              cell.character ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  },
  onCompleted: (pin) => print('PIN: \$pin'),
)''';

  static const liquidGlass =
      '''import 'package:pin_code_fields_liquid_glass/pin_code_fields_liquid_glass.dart';

// Separate style (individual glass cells)
LiquidGlassPinField(
  length: 6,
  theme: LiquidGlassPinTheme.separate(
    blur: 10,
    borderRadius: 12,
  ),
  onCompleted: (pin) => print('PIN: \$pin'),
)

// Unified style (one container)
LiquidGlassPinField(
  length: 6,
  theme: LiquidGlassPinTheme.unified(
    blur: 10,
    containerBorderRadius: 16,
  ),
)

// Blended style (iOS 26)
LiquidGlassPinField(
  length: 6,
  theme: LiquidGlassPinTheme.blended(
    blur: 10,
    blendAmount: 0.3,
    borderRadius: 12,
  ),
)''';

  static const formIntegration = '''final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      PinInputFormField(
        length: 6,
        validator: (value) {
          if (value == null || value.length < 6) {
            return 'Please enter all 6 digits';
          }
          return null;
        },
        onSaved: (value) => print('Saved: \$value'),
        builder: (context, cells) {
          return MaterialPinRow(
            cells: cells,
            theme: MaterialPinTheme().resolve(context),
          );
        },
      ),
      SizedBox(height: 24),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)''';
}
