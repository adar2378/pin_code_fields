import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  Widget buildApp({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('MaterialPinFormField', () {
    testWidgets('renders MaterialPinRow cells', (tester) async {
      await tester.pumpWidget(
        buildApp(
          child: Form(
            child: MaterialPinFormField(
              length: 4,
            ),
          ),
        ),
      );

      // Should find MaterialPinCell widgets
      expect(find.byType(MaterialPinCell), findsNWidgets(4));
    });

    testWidgets('accepts keyboard input and updates form value',
        (tester) async {
      String? savedValue;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildApp(
          child: Form(
            key: formKey,
            child: MaterialPinFormField(
              length: 4,
              autoFocus: true,
              onSaved: (value) => savedValue = value,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.enterText(find.byType(EditableText), '1234');
      await tester.pump();

      formKey.currentState!.save();
      expect(savedValue, '1234');
    });

    group('Form validation', () {
      testWidgets('shows error text when validation fails', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          buildApp(
            child: Form(
              key: formKey,
              child: MaterialPinFormField(
                length: 4,
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'Enter all 4 digits';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        // Validate without entering text
        formKey.currentState!.validate();
        await tester.pump();
        // AnimatedSize needs to settle
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Enter all 4 digits'), findsOneWidget);
      });

      testWidgets('hides error text when validation passes', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          buildApp(
            child: Form(
              key: formKey,
              child: MaterialPinFormField(
                length: 4,
                autoFocus: true,
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'Enter all 4 digits';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        await tester.pump();

        // Enter full PIN
        await tester.enterText(find.byType(EditableText), '1234');
        await tester.pump();

        formKey.currentState!.validate();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Enter all 4 digits'), findsNothing);
      });

      testWidgets('uses custom formErrorStyle', (tester) async {
        final formKey = GlobalKey<FormState>();
        const customStyle = TextStyle(color: Colors.purple, fontSize: 16);

        await tester.pumpWidget(
          buildApp(
            child: Form(
              key: formKey,
              child: MaterialPinFormField(
                length: 4,
                formErrorStyle: customStyle,
                validator: (value) => 'Error',
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump(const Duration(seconds: 1));

        final errorText = tester.widget<Text>(find.text('Error'));
        expect(errorText.style?.color, Colors.purple);
        expect(errorText.style?.fontSize, 16);
      });
    });

    group('Controller error (shake)', () {
      testWidgets('wraps content in ErrorShake', (tester) async {
        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
              ),
            ),
          ),
        );

        expect(find.byType(ErrorShake), findsOneWidget);
      });

      testWidgets('controller error and form error coexist independently',
          (tester) async {
        final formKey = GlobalKey<FormState>();
        final controller = PinInputController();

        await tester.pumpWidget(
          buildApp(
            child: Form(
              key: formKey,
              child: MaterialPinFormField(
                length: 4,
                pinController: controller,
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'Enter all 4 digits';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        // Trigger controller error (shake)
        controller.triggerError();
        await tester.pump();

        // Controller should have error
        expect(controller.hasError, true);

        // Form validation error should not be shown yet
        expect(find.text('Enter all 4 digits'), findsNothing);

        // Now trigger form validation
        formKey.currentState!.validate();
        await tester.pump(const Duration(seconds: 1));

        // Both errors should be active
        expect(controller.hasError, true);
        expect(find.text('Enter all 4 digits'), findsOneWidget);
      });
    });

    group('Controller lifecycle', () {
      testWidgets('creates internal controller when none provided',
          (tester) async {
        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
                autoFocus: true,
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), '12');
        await tester.pump();

        // Should work without an external controller
        expect(find.byType(MaterialPinCell), findsNWidgets(4));
      });

      testWidgets('uses external controller', (tester) async {
        final controller = PinInputController(text: '12');

        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
                pinController: controller,
              ),
            ),
          ),
        );

        await tester.pump();

        // Controller text should be reflected
        expect(controller.text, '12');

        // Update controller
        controller.setText('1234');
        await tester.pump();

        expect(controller.text, '1234');
      });

      testWidgets('switches controllers on widget update', (tester) async {
        final controller1 = PinInputController(text: '12');
        final controller2 = PinInputController(text: '34');

        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
                pinController: controller1,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(controller1.text, '12');

        // Switch controller
        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
                pinController: controller2,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(controller2.text, '34');
      });
    });

    group('Theme resolution', () {
      testWidgets('uses provided theme', (tester) async {
        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
                theme: const MaterialPinTheme(
                  shape: MaterialPinShape.circle,
                ),
              ),
            ),
          ),
        );

        // Widget should render without errors
        expect(find.byType(MaterialPinCell), findsNWidgets(4));
      });

      testWidgets('resolves theme from ThemeData extensions', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const [
                MaterialPinThemeExtension(
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.filled,
                  ),
                ),
              ],
            ),
            home: Scaffold(
              body: Form(
                child: MaterialPinFormField(
                  length: 4,
                ),
              ),
            ),
          ),
        );

        // Widget should render without errors using theme from extension
        expect(find.byType(MaterialPinCell), findsNWidgets(4));
      });

      testWidgets('falls back to default MaterialPinTheme', (tester) async {
        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
              ),
            ),
          ),
        );

        // Widget should render without errors using default theme
        expect(find.byType(MaterialPinCell), findsNWidgets(4));
      });
    });

    group('Reset behavior', () {
      testWidgets('reset clears text and controller error', (tester) async {
        final formKey = GlobalKey<FormState>();
        final controller = PinInputController();

        await tester.pumpWidget(
          buildApp(
            child: Form(
              key: formKey,
              child: MaterialPinFormField(
                length: 4,
                pinController: controller,
                autoFocus: true,
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'Error';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        await tester.pump();

        // Enter some text
        await tester.enterText(find.byType(EditableText), '12');
        await tester.pump();

        // Trigger controller error
        controller.triggerError();
        await tester.pump();

        // Validate to show form error
        formKey.currentState!.validate();
        await tester.pump(const Duration(seconds: 1));

        expect(controller.hasError, true);
        expect(find.text('Error'), findsOneWidget);

        // Reset
        formKey.currentState!.reset();
        await tester.pump(const Duration(seconds: 1));

        // Controller text should be cleared
        expect(controller.text, '');
        // Controller error should be cleared
        expect(controller.hasError, false);
        // Form error should be gone
        expect(find.text('Error'), findsNothing);
      });

      testWidgets('reset restores initial value', (tester) async {
        final formKey = GlobalKey<FormState>();
        final controller = PinInputController();

        await tester.pumpWidget(
          buildApp(
            child: Form(
              key: formKey,
              child: MaterialPinFormField(
                length: 4,
                pinController: controller,
                initialValue: '12',
                autoFocus: true,
              ),
            ),
          ),
        );

        await tester.pump();

        // Change text
        await tester.enterText(find.byType(EditableText), '5678');
        await tester.pump();

        expect(controller.text, '5678');

        // Reset
        formKey.currentState!.reset();
        await tester.pump();

        // Should restore initial value
        expect(controller.text, '12');
      });
    });

    group('mainAxisSize', () {
      Finder findPinRowRow() => find.descendant(
            of: find.byType(MaterialPinRow),
            matching: find.byType(Row),
          );

      testWidgets('defaults to MainAxisSize.min', (tester) async {
        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(length: 4),
            ),
          ),
        );

        final row = tester.widget<Row>(findPinRowRow());
        expect(row.mainAxisSize, MainAxisSize.min);
      });

      testWidgets('passes MainAxisSize.max through to MaterialPinRow',
          (tester) async {
        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ),
        );

        final row = tester.widget<Row>(findPinRowRow());
        expect(row.mainAxisSize, MainAxisSize.max);
      });

      testWidgets('MainAxisSize.max expands to fill available width',
          (tester) async {
        const containerWidth = 400.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: containerWidth,
                  child: Form(
                    child: MaterialPinFormField(
                      length: 4,
                      mainAxisSize: MainAxisSize.max,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final rowSize = tester.getSize(findPinRowRow());
        expect(rowSize.width, containerWidth);
      });

      testWidgets('MainAxisSize.min only takes needed width', (tester) async {
        const containerWidth = 400.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: containerWidth,
                  child: Form(
                    child: MaterialPinFormField(
                      length: 4,
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final rowSize = tester.getSize(findPinRowRow());
        expect(rowSize.width, lessThan(containerWidth));
      });
    });

    group('Callbacks', () {
      testWidgets('onChanged is called', (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
                autoFocus: true,
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), '1234');
        await tester.pump();

        expect(changedValue, '1234');
      });

      testWidgets('onCompleted is called when PIN is full', (tester) async {
        String? completedValue;

        await tester.pumpWidget(
          buildApp(
            child: Form(
              child: MaterialPinFormField(
                length: 4,
                autoFocus: true,
                onCompleted: (value) => completedValue = value,
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), '1234');
        await tester.pump();

        expect(completedValue, '1234');
      });
    });
  });
}
