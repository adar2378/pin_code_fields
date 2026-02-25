import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  group('MaterialPinField mainAxisSize', () {
    Finder findPinRowRow() => find.descendant(
          of: find.byType(MaterialPinRow),
          matching: find.byType(Row),
        );

    testWidgets('defaults to MainAxisSize.min', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MaterialPinField(length: 4),
          ),
        ),
      );

      final row = tester.widget<Row>(findPinRowRow());
      expect(row.mainAxisSize, MainAxisSize.min);
    });

    testWidgets('passes MainAxisSize.max through to MaterialPinRow',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MaterialPinField(
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
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: containerWidth,
                child: MaterialPinField(
                  length: 4,
                  mainAxisSize: MainAxisSize.max,
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
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: containerWidth,
                child: MaterialPinField(
                  length: 4,
                  mainAxisSize: MainAxisSize.min,
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
}
