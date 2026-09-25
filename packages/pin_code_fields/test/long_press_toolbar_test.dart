import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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

void _expectToolbarPainted(WidgetTester tester) {
  final toolbar = find.byType(AdaptiveTextSelectionToolbar);
  expect(toolbar, findsOneWidget);
  final follower = tester.widget<CompositedTransformFollower>(
    find.ancestor(of: toolbar, matching: find.byType(CompositedTransformFollower)).first,
  );
  expect(follower.showWhenUnlinked, isFalse);
  expect(
    follower.link.leader,
    isNotNull,
    reason: 'toolbar anchor was never painted, so the menu is invisible',
  );
}

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

  // Regression test for https://github.com/adar2378/pin_code_fields/issues/432
  // The toolbar follows a LayerLink whose leader is pushed when the
  // EditableText paints. If the field is wrapped in Opacity(0) or hidden
  // with Visibility, the leader is never pushed and the toolbar is built
  // but not visible. find.byType alone can't catch that.
  testWidgets(
    'long press toolbar is linked to the field and painted',
    (tester) async {
      await tester.pumpWidget(_app(const PinInput(length: 6, builder: _cells)));

      await tester.longPress(find.byType(EditableText));
      await tester.pumpAndSettle();

      _expectToolbarPainted(tester);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets('toolbar is painted when cells have an opaque background', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        PinInput(
          length: 6,
          builder: (context, cells) => Row(
            children: [
              for (final cell in cells)
                Container(
                  width: 40,
                  height: 48,
                  color: Colors.white,
                  child: Center(child: Text(cell.character ?? '')),
                ),
            ],
          ),
        ),
      ),
    );

    await tester.longPress(find.byType(Container).first);
    await tester.pumpAndSettle();

    _expectToolbarPainted(tester);
  });

  testWidgets('long press on a cell raises the selection toolbar', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const PinInput(length: 6, builder: _cells)));

    await tester.longPress(find.byType(SizedBox).first);
    await tester.pumpAndSettle();

    expect(find.byType(AdaptiveTextSelectionToolbar), findsOneWidget);
  });

  // On iOS the clipboard read waits for the "Allow Paste" prompt, so a
  // user-initiated paste must not give up after the auto-detect timeout.
  testWidgets('paste waits for a slow clipboard response', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.getData') {
          await Future<void>.delayed(const Duration(seconds: 2));
          return <String, dynamic>{'text': '123456'};
        }
        if (call.method == 'Clipboard.hasStrings') {
          return <String, dynamic>{'value': true};
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    String? completed;
    await tester.pumpWidget(
      _app(
        PinInput(
          length: 6,
          builder: _cells,
          onCompleted: (pin) => completed = pin,
        ),
      ),
    );

    await tester.longPress(find.byType(EditableText));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paste'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(completed, '123456');
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
