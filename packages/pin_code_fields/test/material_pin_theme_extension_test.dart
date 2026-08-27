import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  group('MaterialPinThemeExtension', () {
    test('creates with required theme', () {
      const theme = MaterialPinTheme();
      const extension = MaterialPinThemeExtension(theme: theme);

      expect(extension.theme, theme);
    });

    test('copyWith creates new instance with updated theme', () {
      const original = MaterialPinThemeExtension(theme: MaterialPinTheme());
      const newTheme = MaterialPinTheme(
        shape: MaterialPinShape.filled,
        cellSize: Size(60, 70),
      );
      final copied = original.copyWith(theme: newTheme);

      expect(copied.theme, newTheme);
      expect(copied.theme.shape, MaterialPinShape.filled);
      expect(copied.theme.cellSize, const Size(60, 70));
    });

    test('copyWith preserves original when null passed', () {
      const original = MaterialPinThemeExtension(
        theme: MaterialPinTheme(shape: MaterialPinShape.circle),
      );
      final copied = original.copyWith();

      expect(copied.theme.shape, MaterialPinShape.circle);
    });

    test('lerp returns this when other is null', () {
      const extension = MaterialPinThemeExtension(theme: MaterialPinTheme());

      final lerped = extension.lerp(null, 0.5);

      expect(lerped, same(extension));
    });

    test('lerp returns this when t < 0.5', () {
      const extension1 = MaterialPinThemeExtension(
        theme: MaterialPinTheme(shape: MaterialPinShape.outlined),
      );
      const extension2 = MaterialPinThemeExtension(
        theme: MaterialPinTheme(shape: MaterialPinShape.filled),
      );

      final lerped = extension1.lerp(extension2, 0.3);

      expect(lerped.theme.shape, MaterialPinShape.outlined);
    });

    test('lerp returns other when t >= 0.5', () {
      const extension1 = MaterialPinThemeExtension(
        theme: MaterialPinTheme(shape: MaterialPinShape.outlined),
      );
      const extension2 = MaterialPinThemeExtension(
        theme: MaterialPinTheme(shape: MaterialPinShape.filled),
      );

      final lerped = extension1.lerp(extension2, 0.5);

      expect(lerped.theme.shape, MaterialPinShape.filled);
    });

    test('lerp returns other when t > 0.5', () {
      const extension1 = MaterialPinThemeExtension(
        theme: MaterialPinTheme(shape: MaterialPinShape.outlined),
      );
      const extension2 = MaterialPinThemeExtension(
        theme: MaterialPinTheme(shape: MaterialPinShape.filled),
      );

      final lerped = extension1.lerp(extension2, 0.7);

      expect(lerped.theme.shape, MaterialPinShape.filled);
    });

    test('equality works correctly', () {
      const theme = MaterialPinTheme(shape: MaterialPinShape.circle);
      const extension1 = MaterialPinThemeExtension(theme: theme);
      const extension2 = MaterialPinThemeExtension(theme: theme);
      const extension3 = MaterialPinThemeExtension(
        theme: MaterialPinTheme(shape: MaterialPinShape.outlined),
      );

      expect(extension1, equals(extension2));
      expect(extension1, isNot(equals(extension3)));
    });

    test('hashCode is consistent with equality', () {
      const theme = MaterialPinTheme(shape: MaterialPinShape.underlined);
      const extension1 = MaterialPinThemeExtension(theme: theme);
      const extension2 = MaterialPinThemeExtension(theme: theme);

      expect(extension1.hashCode, equals(extension2.hashCode));
    });
  });

  group('MaterialPinThemeDataExtension', () {
    testWidgets('materialPinTheme returns null when extension not registered',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(),
          home: Builder(
            builder: (context) {
              final pinTheme = Theme.of(context).materialPinTheme;
              expect(pinTheme, isNull);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('materialPinTheme returns theme when extension is registered',
        (tester) async {
      const pinTheme = MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: Size(56, 64),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              const MaterialPinThemeExtension(theme: pinTheme),
            ],
          ),
          home: Builder(
            builder: (context) {
              final retrievedTheme = Theme.of(context).materialPinTheme;
              expect(retrievedTheme, isNotNull);
              expect(retrievedTheme!.shape, MaterialPinShape.outlined);
              expect(retrievedTheme.cellSize, const Size(56, 64));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('materialPinTheme works with different theme configurations',
        (tester) async {
      const lightTheme = MaterialPinTheme(
        shape: MaterialPinShape.filled,
        fillColor: Colors.white,
        borderColor: Colors.grey,
      );

      const darkTheme = MaterialPinTheme(
        shape: MaterialPinShape.filled,
        fillColor: Colors.black,
        borderColor: Colors.grey,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            extensions: [
              const MaterialPinThemeExtension(theme: lightTheme),
            ],
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            extensions: [
              const MaterialPinThemeExtension(theme: darkTheme),
            ],
          ),
          home: Builder(
            builder: (context) {
              final pinTheme = Theme.of(context).materialPinTheme;
              expect(pinTheme, isNotNull);
              expect(pinTheme!.fillColor, Colors.white);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('materialPinTheme works with nested themes', (tester) async {
      const parentTheme = MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: Size(50, 60),
      );

      const childTheme = MaterialPinTheme(
        shape: MaterialPinShape.circle,
        cellSize: Size(40, 40),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              const MaterialPinThemeExtension(theme: parentTheme),
            ],
          ),
          home: Theme(
            data: ThemeData(
              extensions: [
                const MaterialPinThemeExtension(theme: childTheme),
              ],
            ),
            child: Builder(
              builder: (context) {
                final pinTheme = Theme.of(context).materialPinTheme;
                expect(pinTheme, isNotNull);
                expect(pinTheme!.shape, MaterialPinShape.circle);
                expect(pinTheme.cellSize, const Size(40, 40));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('Integration with MaterialPinField', () {
    testWidgets('MaterialPinField automatically uses theme from ThemeData',
        (tester) async {
      const customTheme = MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: Size(100, 100),
        spacing: 20,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              const MaterialPinThemeExtension(theme: customTheme),
            ],
          ),
          home: const Scaffold(
            body: MaterialPinField(
              length: 4,
              // No explicit theme - should automatically use ThemeData extension
            ),
          ),
        ),
      );

      // MaterialPinField should render with the theme from ThemeData
      expect(find.byType(MaterialPinField), findsOneWidget);

      // Verify cells are rendered with the custom theme
      expect(find.byType(MaterialPinCell), findsNWidgets(4));

      // Verify the cell size reflects the global theme from ThemeData
      final cellSize = tester.getSize(find.byType(MaterialPinCell).first);
      expect(cellSize, equals(customTheme.cellSize));
    });

    testWidgets('MaterialPinField explicit theme overrides ThemeData',
        (tester) async {
      const globalTheme = MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: Size(56, 64),
      );

      const localTheme = MaterialPinTheme(
        shape: MaterialPinShape.filled,
        cellSize: Size(40, 50),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              const MaterialPinThemeExtension(theme: globalTheme),
            ],
          ),
          home: const Scaffold(
            body: MaterialPinField(
              length: 4,
              theme: localTheme,
            ),
          ),
        ),
      );

      expect(find.byType(MaterialPinField), findsOneWidget);
      expect(find.byType(MaterialPinCell), findsNWidgets(4));

      // Verify that the explicit local theme overrides the ThemeData extension
      final cellSize = tester.getSize(find.byType(MaterialPinCell).first);
      expect(cellSize, equals(localTheme.cellSize));
    });
  });
}
