import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/pin_code_fields.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('transparent background', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(800, 400));

    final Widget app = Builder(
      builder: (context) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Builder(builder: (context) {
              return PinCodeTextField(
                autoFocus: true,
                backgroundColor: Colors.transparent,
                length: 6,
                animationDuration: Duration.zero,
                onChanged: (input) {},
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
