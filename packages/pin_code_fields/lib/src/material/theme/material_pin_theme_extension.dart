import 'package:material_ui/material_ui.dart';
import 'material_pin_theme.dart';

/// Theme extension for embedding [MaterialPinTheme] in [ThemeData].
///
/// This extension allows you to define a default [MaterialPinTheme] at the
/// app level and access it throughout your app using [Theme.of(context)].
///
/// ## Setup
///
/// Add the extension to your app's theme:
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       MaterialPinThemeExtension(
///         theme: MaterialPinTheme(
///           shape: MaterialPinShape.outlined,
///           cellSize: Size(56, 64),
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// ## Usage
///
/// Access the theme in your widgets:
/// ```dart
/// final pinTheme = Theme.of(context).extension<MaterialPinThemeExtension>()?.theme;
///
/// // Or use the convenience extension:
/// final pinTheme = Theme.of(context).materialPinTheme;
///
/// MaterialPinField(
///   theme: pinTheme ?? const MaterialPinTheme(),
/// )
/// ```
///
/// ## Light and Dark Themes
///
/// You can provide different themes for light and dark modes:
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       MaterialPinThemeExtension(
///         theme: MaterialPinTheme(
///           shape: MaterialPinShape.outlined,
///           borderColor: Colors.grey,
///         ),
///       ),
///     ],
///   ),
///   darkTheme: ThemeData(
///     brightness: Brightness.dark,
///     extensions: [
///       MaterialPinThemeExtension(
///         theme: MaterialPinTheme(
///           shape: MaterialPinShape.outlined,
///           borderColor: Colors.grey.shade700,
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
@immutable
class MaterialPinThemeExtension
    extends ThemeExtension<MaterialPinThemeExtension> {
  const MaterialPinThemeExtension({
    required this.theme,
  });

  /// The Material PIN theme configuration.
  final MaterialPinTheme theme;

  @override
  MaterialPinThemeExtension copyWith({
    MaterialPinTheme? theme,
  }) {
    return MaterialPinThemeExtension(
      theme: theme ?? this.theme,
    );
  }

  @override
  MaterialPinThemeExtension lerp(
    MaterialPinThemeExtension? other,
    double t,
  ) {
    // Since MaterialPinTheme contains many properties that can't be easily
    // interpolated (enums, functions, etc.), we use a simple switch at t=0.5
    if (other == null) return this;
    if (t < 0.5) return this;
    return other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaterialPinThemeExtension && other.theme == theme;
  }

  @override
  int get hashCode => theme.hashCode;
}

/// Convenience extension on [ThemeData] to easily access [MaterialPinTheme].
///
/// This extension provides a direct way to get the Material PIN theme:
/// ```dart
/// final pinTheme = Theme.of(context).materialPinTheme;
/// ```
extension MaterialPinThemeDataExtension on ThemeData {
  /// Returns the [MaterialPinTheme] from the theme extensions.
  ///
  /// Returns `null` if no [MaterialPinThemeExtension] has been registered
  /// in the theme's extensions.
  MaterialPinTheme? get materialPinTheme {
    return extension<MaterialPinThemeExtension>()?.theme;
  }
}
