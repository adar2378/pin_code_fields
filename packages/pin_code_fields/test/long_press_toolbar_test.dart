import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

Widget _app(PinInput input) => MaterialApp(home: Scaffold(body: input));

Widget _cells(BuildContext context, List<PinCellData> cells) => Row(
  children: [
    for (final cell in cells)
      SizedBox(
        width: 40,
        height: 48,
        child: Center(child: Text(cell.character ?? '')),
      ),
  ],
);

void main() {
  // Regression test for https://github.com/adar2378/pin_code_fields/issues/430
  testWidgets(
    'long press raises the selection toolbar',
    (tester) async {
      await tester.pumpWidget(_app(const PinInput(length: 6, builder: _cells)));

      await tester.longPress(find.byType(EditableText));
      await tester.pumpAndSettle();

      expect(find.byType(AdaptiveTextSelectionToolbar), findsOneWidget);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets('long press on a cell raises the selection toolbar', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const PinInput(length: 6, builder: _cells)));

    await tester.longPress(find.byType(SizedBox).first);
    await tester.pumpAndSettle();

    expect(find.byType(AdaptiveTextSelectionToolbar), findsOneWidget);
  });

  testWidgets('long press does not show toolbar when paste is disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const PinInput(length: 6, enablePaste: false, builder: _cells)),
    );

    await tester.longPress(find.byType(EditableText));
    await tester.pumpAndSettle();

    expect(find.byType(AdaptiveTextSelectionToolbar), findsNothing);
  });

  testWidgets('tap still focuses the field', (tester) async {
    await tester.pumpWidget(_app(const PinInput(length: 6, builder: _cells)));

    await tester.tap(find.byType(SizedBox).first);
    await tester.pump();

    final state = tester.state<EditableTextState>(find.byType(EditableText));
    expect(state.widget.focusNode.hasFocus, isTrue);
  });
}
