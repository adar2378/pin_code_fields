import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized()
          as TestWidgetsFlutterBinding;

  testWidgets('disposes error stream', (WidgetTester tester) async {
    final StreamController<ErrorAnimationType> controller =
        StreamController<ErrorAnimationType>();

    final Widget app = Builder(
      builder: (context) => MaterialApp(
        home: Scaffold(
          body: PinCodeTextField(
            appContext: context,
            length: 6,
            errorAnimationController: controller,
          ),
        ),
      ),
    );

    await tester.pumpWidget(app);
    expect(controller.hasListener, isTrue);

    await tester.pumpWidget(SizedBox());
    expect(controller.hasListener, isFalse);
    controller.close();
  });

  /// This test demonstrates that a application can set a InputDecorationTheme
  /// which specifies a background color for input fields. When this happens,
  /// the PinCodeFields should override the theme setting with the users chosen
  /// background color.
  testWidgets('transparent background', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(800, 400));

    final Widget app = Builder(
      builder: (context) {
        return MaterialApp(
          theme: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.red,
            filled: true,
          )),
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Builder(builder: (context) {
              return PinCodeTextField(
                appContext: context,
                autoFocus: true,
                backgroundColor: Colors.transparent,
                length: 6,
                animationDuration: Duration.zero,
              );
            }),
          ),
        );
      },
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('golden_test_1.png'),
    );
  });
}
