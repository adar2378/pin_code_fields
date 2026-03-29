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

  group('MaterialPinField semanticHintBuilder', () {
    testWidgets('passes semanticHintBuilder through to PinInput',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaterialPinField(
              length: 4,
              autoFocus: true,
              semanticHintBuilder: (filled, total) {
                final remaining = total - filled;
                return remaining > 0
                    ? 'Custom: Enter $remaining more'
                    : 'Custom: Complete';
              },
            ),
          ),
        ),
      );

      await tester.pump();

      final semanticsFinder = find.byWidgetPredicate((widget) {
        if (widget is Semantics) {
          return widget.properties.label?.contains('PIN code field') ?? false;
        }
        return false;
      });

      // Should use custom hint builder
      var semantics = tester.getSemantics(semanticsFinder);
      expect(semantics.hint, 'Custom: Enter 4 more');

      // Enter some digits
      await tester.enterText(find.byType(EditableText), '12');
      await tester.pump();

      semantics = tester.getSemantics(semanticsFinder);
      expect(semantics.hint, 'Custom: Enter 2 more');

      // Complete
      await tester.enterText(find.byType(EditableText), '1234');
      await tester.pump();

      semantics = tester.getSemantics(semanticsFinder);
      expect(semantics.hint, 'Custom: Complete');
    });
  });
}
