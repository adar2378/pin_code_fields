import 'dart:ui' show SemanticsFlag;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  group('PinInput', () {
    testWidgets('renders builder with correct number of cells', (tester) async {
      List<PinCellData>? capturedCells;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinInput(
              length: 4,
              builder: (context, cells) {
                capturedCells = cells;
                return Row(
                  children: cells.map((c) => Text('${c.index}')).toList(),
                );
              },
            ),
          ),
        ),
      );

      expect(capturedCells, isNotNull);
      expect(capturedCells!.length, 4);
      expect(capturedCells![0].index, 0);
      expect(capturedCells![3].index, 3);
    });

    testWidgets('receives keyboard input', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinInput(
              length: 4,
              autoFocus: true,
              builder: (context, cells) => Row(
                children: cells.map((c) => Text(c.character ?? '-')).toList(),
              ),
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

    testWidgets('calls onCompleted when PIN is full', (tester) async {
      String? completedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinInput(
              length: 4,
              autoFocus: true,
              builder: (context, cells) => Row(
                children: cells.map((c) => Text(c.character ?? '-')).toList(),
              ),
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

    testWidgets('limits input to specified length', (tester) async {
      List<PinCellData>? capturedCells;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinInput(
              length: 4,
              autoFocus: true,
              builder: (context, cells) {
                capturedCells = cells;
                return Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.enterText(find.byType(EditableText), '123456');
      await tester.pump();

      // Should only have 4 filled cells
      expect(capturedCells!.where((c) => c.isFilled).length, 4);
    });

    testWidgets('respects readOnly mode', (tester) async {
      List<PinCellData>? capturedCells;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinInput(
              length: 4,
              readOnly: true,
              builder: (context, cells) {
                capturedCells = cells;
                return Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                );
              },
            ),
          ),
        ),
      );

      // readOnly cells should NOT be visually disabled (Flutter convention)
      // readOnly = looks normal, but can't edit
      expect(capturedCells!.every((c) => !c.isDisabled), true);
    });

    testWidgets('respects enabled=false mode', (tester) async {
      List<PinCellData>? capturedCells;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinInput(
              length: 4,
              enabled: false,
              builder: (context, cells) {
                capturedCells = cells;
                return Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                );
              },
            ),
          ),
        ),
      );

      // enabled=false cells should be visually disabled (grayed out)
      expect(capturedCells!.every((c) => c.isDisabled), true);
    });

    testWidgets('uses external controller', (tester) async {
      final controller = PinInputController(text: '12');
      List<PinCellData>? capturedCells;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinInput(
              length: 4,
              pinController: controller,
              builder: (context, cells) {
                capturedCells = cells;
                return Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                );
              },
            ),
          ),
        ),
      );

      await tester.pump();

      // First two cells should be filled
      expect(capturedCells![0].isFilled, true);
      expect(capturedCells![1].isFilled, true);
      expect(capturedCells![2].isFilled, false);
      expect(capturedCells![3].isFilled, false);

      // Update controller
      controller.setText('1234');
      await tester.pump();

      expect(capturedCells!.every((c) => c.isFilled), true);
    });

    group('Input Formatters', () {
      testWidgets('whitespace-stripping formatter allows full paste',
          (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 6,
                autoFocus: true,
                inputFormatters: [_WhitespaceRemovingFormatter()],
                builder: (context, cells) => Row(
                  children:
                      cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), '12 34 56');
        await tester.pump();

        expect(changedValue, '123456');
      });

      testWidgets(
          'whitespace-stripping formatter works with numeric keyboard',
          (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                autoFocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [_WhitespaceRemovingFormatter()],
                builder: (context, cells) => Row(
                  children:
                      cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), '1 2 3 4');
        await tester.pump();

        expect(changedValue, '1234');
      });

      testWidgets('uppercase formatter converts text', (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 6,
                autoFocus: true,
                keyboardType: TextInputType.text,
                inputFormatters: [_UppercaseFormatter()],
                builder: (context, cells) => Row(
                  children:
                      cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'abcdef');
        await tester.pump();

        expect(changedValue, 'ABCDEF');
      });

      testWidgets('digits-only filter works without custom formatters',
          (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                autoFocus: true,
                keyboardType: TextInputType.number,
                builder: (context, cells) => Row(
                  children:
                      cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), '12ab34');
        await tester.pump();

        expect(changedValue, '1234');
      });
    });

    group('Semantics', () {
      testWidgets('provides default semantic label based on length',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 6,
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        // Find the Semantics widget by looking for one with our label pattern
        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label?.contains('PIN code field') ?? false;
          }
          return false;
        });
        expect(semanticsFinder, findsOneWidget);

        // Verify the Semantics widget has correct label
        final semanticsWidget = tester.widget<Semantics>(semanticsFinder);
        expect(semanticsWidget.properties.label, '6-digit PIN code field');
      });

      testWidgets('uses custom semantic label when provided', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                semanticLabel: 'Enter verification code',
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label == 'Enter verification code';
          }
          return false;
        });
        expect(semanticsFinder, findsOneWidget);

        // Verify the Semantics widget has correct label
        final semanticsWidget = tester.widget<Semantics>(semanticsFinder);
        expect(semanticsWidget.properties.label, 'Enter verification code');
      });

      testWidgets('provides semantic hint about remaining digits',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                autoFocus: true,
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        // Find PIN semantics widget
        Finder findPinSemantics() => find.byWidgetPredicate((widget) {
              if (widget is Semantics) {
                return widget.properties.label?.contains('PIN code field') ??
                    false;
              }
              return false;
            });

        // Initially empty - should hint for 4 digits
        var semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Enter 4 more digits');

        // Enter 3 digits
        await tester.enterText(find.byType(EditableText), '123');
        await tester.pump();

        semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Enter 1 more digit');

        // Complete PIN
        await tester.enterText(find.byType(EditableText), '1234');
        await tester.pump();

        semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'PIN complete');
      });

      testWidgets('exposes entered value in semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                autoFocus: true,
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), '12');
        await tester.pump();

        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label?.contains('PIN code field') ?? false;
          }
          return false;
        });
        final semantics = tester.getSemantics(semanticsFinder);
        expect(semantics.value, '12');
      });

      testWidgets('masks value when obscured', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                autoFocus: true,
                obscureText: true,
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.enterText(find.byType(EditableText), '12');
        await tester.pump();

        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label?.contains('PIN code field') ?? false;
          }
          return false;
        });
        final semantics = tester.getSemantics(semanticsFinder);
        // Should show masked value, not actual digits
        expect(semantics.value, '●●');
      });

      testWidgets('marks as text field in semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label?.contains('PIN code field') ?? false;
          }
          return false;
        });
        final semantics = tester.getSemantics(semanticsFinder);
        // ignore: deprecated_member_use
        expect(semantics.hasFlag(SemanticsFlag.isTextField), true);
      });

      testWidgets('reflects enabled/disabled state in semantics',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                enabled: false,
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label?.contains('PIN code field') ?? false;
          }
          return false;
        });
        final semantics = tester.getSemantics(semanticsFinder);
        // ignore: deprecated_member_use
        expect(semantics.hasFlag(SemanticsFlag.isEnabled), false);
      });

      testWidgets('suppresses semantic hint when disabled', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 6,
                enabled: false,
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label?.contains('PIN code field') ?? false;
          }
          return false;
        });
        final semantics = tester.getSemantics(semanticsFinder);
        // Hint must be absent so the platform can announce "dimmed" cleanly.
        expect(semantics.hint, isEmpty);
      });

      testWidgets('suppresses semantic hint when disabled with pre-filled value',
          (tester) async {
        final controller = PinInputController(text: '1234');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                enabled: false,
                pinController: controller,
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
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
        final semantics = tester.getSemantics(semanticsFinder);
        // "PIN complete" hint must also be suppressed when disabled.
        expect(semantics.hint, isEmpty);
      });

      testWidgets('suppresses custom semanticHintBuilder when disabled',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                enabled: false,
                semanticHintBuilder: (_, __) => 'Enter your security code',
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label?.contains('PIN code field') ?? false;
          }
          return false;
        });
        final semantics = tester.getSemantics(semanticsFinder);
        // Custom hint builder output must be suppressed too.
        expect(semantics.hint, isEmpty);
      });

      testWidgets(
          'does not report focused state when field is disabled after focus',
          (tester) async {
        bool enabled = true;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    PinInput(
                      length: 4,
                      enabled: enabled,
                      autoFocus: true,
                      builder: (context, cells) => Row(
                        children:
                            cells.map((c) => Text(c.character ?? '-')).toList(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => enabled = false),
                      child: const Text('Disable'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        // Disable the field while it potentially has focus.
        await tester.tap(find.text('Disable'));
        await tester.pump();

        final semanticsFinder = find.byWidgetPredicate((widget) {
          if (widget is Semantics) {
            return widget.properties.label?.contains('PIN code field') ?? false;
          }
          return false;
        });
        final semantics = tester.getSemantics(semanticsFinder);
        // ignore: deprecated_member_use
        expect(semantics.hasFlag(SemanticsFlag.isFocused), false);
      });

      testWidgets('uses custom semanticHintBuilder for dynamic hints',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                autoFocus: true,
                semanticHintBuilder: (filled, total) {
                  final remaining = total - filled;
                  return remaining > 0
                      ? 'Enter $remaining more ${remaining == 1 ? 'character' : 'characters'}'
                      : 'Code complete';
                },
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        Finder findPinSemantics() => find.byWidgetPredicate((widget) {
              if (widget is Semantics) {
                return widget.properties.label?.contains('PIN code field') ??
                    false;
              }
              return false;
            });

        // Initially empty - should use custom hint
        var semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Enter 4 more characters');

        // Enter 3 characters
        await tester.enterText(find.byType(EditableText), '123');
        await tester.pump();

        semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Enter 1 more character');

        // Complete
        await tester.enterText(find.byType(EditableText), '1234');
        await tester.pump();

        semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Code complete');
      });

      testWidgets('uses custom semanticHintBuilder for static hint',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 4,
                autoFocus: true,
                semanticHintBuilder: (_, __) => 'Enter your security code',
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        Finder findPinSemantics() => find.byWidgetPredicate((widget) {
              if (widget is Semantics) {
                return widget.properties.label?.contains('PIN code field') ??
                    false;
              }
              return false;
            });

        // Should use static custom hint regardless of filled count
        var semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Enter your security code');

        // Enter some digits
        await tester.enterText(find.byType(EditableText), '12');
        await tester.pump();

        semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Enter your security code');

        // Complete
        await tester.enterText(find.byType(EditableText), '1234');
        await tester.pump();

        semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Enter your security code');
      });

      testWidgets('uses custom semanticHintBuilder for localization',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinInput(
                length: 6,
                autoFocus: true,
                semanticHintBuilder: (filled, total) {
                  final remaining = total - filled;
                  return remaining > 0
                      ? 'Introduzca $remaining ${remaining == 1 ? 'dígito' : 'dígitos'} más'
                      : 'PIN completo';
                },
                builder: (context, cells) => Row(
                  children: cells.map((c) => Text(c.character ?? '-')).toList(),
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        Finder findPinSemantics() => find.byWidgetPredicate((widget) {
              if (widget is Semantics) {
                return widget.properties.label?.contains('PIN code field') ??
                    false;
              }
              return false;
            });

        // Initially empty - Spanish hint
        var semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Introduzca 6 dígitos más');

        // Enter 5 digits
        await tester.enterText(find.byType(EditableText), '12345');
        await tester.pump();

        semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'Introduzca 1 dígito más');

        // Complete
        await tester.enterText(find.byType(EditableText), '123456');
        await tester.pump();

        semantics = tester.getSemantics(findPinSemantics());
        expect(semantics.hint, 'PIN completo');
      });
    });
  });
}

// ── Test helpers ────────────────────────────────────────────────────────────

class _WhitespaceRemovingFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final stripped = newValue.text.replaceAll(RegExp(r'\s'), '');
    return newValue.copyWith(
      text: stripped,
      selection: TextSelection.collapsed(offset: stripped.length),
    );
  }
}

class _UppercaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();
    return newValue.copyWith(
      text: upper,
      selection: TextSelection.collapsed(offset: upper.length),
    );
  }
}
