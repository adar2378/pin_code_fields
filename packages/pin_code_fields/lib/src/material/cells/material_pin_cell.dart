import 'package:material_ui/material_ui.dart';

import '../../core/pin_cell_data.dart';
import '../shapes/circle_decoration.dart';
import '../shapes/filled_decoration.dart';
import '../shapes/outlined_decoration.dart';
import '../shapes/underlined_decoration.dart';
import '../theme/material_pin_theme.dart';
import 'material_cell_content.dart';

/// Style properties for a PIN cell based on its current state.
///
/// This class encapsulates the visual styling that changes based on
/// cell state (disabled, error, focused, filled, empty).
class PinCellStateStyle {
  const PinCellStateStyle({
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
    this.boxShadows,
  });

  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadows;

  /// Resolves the appropriate style based on cell state and theme.
  ///
  /// Priority order (first match wins):
  /// 1. Disabled - grayed out appearance
  /// 2. Error - error color with emphasis
  /// 3. Focused - highlighted with focus indicators
  /// 4. Complete - all cells filled (success indication)
  /// 5. Filled - has content, normal appearance
  /// 6. Following - empty cells after the focused cell
  /// 7. Empty - default appearance
  factory PinCellStateStyle.fromState(
    PinCellData data,
    MaterialPinThemeData theme,
  ) {
    if (data.isDisabled) {
      return PinCellStateStyle(
        fillColor: theme.disabledFillColor,
        borderColor: theme.disabledBorderColor,
        borderWidth: theme.borderWidth,
      );
    }

    if (data.isError) {
      return PinCellStateStyle(
        fillColor: theme.errorFillColor,
        borderColor: theme.errorBorderColor,
        borderWidth: theme.errorBorderWidth,
        boxShadows: theme.errorBoxShadows,
      );
    }

    // Focused state - check before complete so focused cell is highlighted
    if (data.isFocused) {
      return PinCellStateStyle(
        fillColor: theme.focusedFillColor,
        borderColor: theme.focusedBorderColor,
        borderWidth: theme.focusedBorderWidth,
        boxShadows: theme.focusedBoxShadows,
      );
    }

    // Complete state - when all cells are filled (but not focused)
    if (data.isComplete && data.isFilled) {
      return PinCellStateStyle(
        fillColor: theme.completeFillColor,
        borderColor: theme.completeBorderColor,
        borderWidth: theme.borderWidth,
        boxShadows: theme.boxShadows,
      );
    }

    if (data.isFilled) {
      return PinCellStateStyle(
        fillColor: theme.filledFillColor,
        borderColor: theme.filledBorderColor,
        borderWidth: theme.borderWidth,
        boxShadows: theme.boxShadows,
      );
    }

    // Following state - empty cells after the focused cell
    if (data.isFollowing) {
      return PinCellStateStyle(
        fillColor: theme.followingFillColor,
        borderColor: theme.followingBorderColor,
        borderWidth: theme.borderWidth,
        boxShadows: theme.boxShadows,
      );
    }

    // Empty state (default) - cells before the focused cell
    return PinCellStateStyle(
      fillColor: theme.fillColor,
      borderColor: theme.borderColor,
      borderWidth: theme.borderWidth,
      boxShadows: theme.boxShadows,
    );
  }
}

/// A Material Design PIN cell widget.
///
/// This widget renders a single PIN cell with the appropriate styling
/// based on its current state (empty, filled, focused, error, disabled).
class MaterialPinCell extends StatelessWidget {
  const MaterialPinCell({
    super.key,
    required this.data,
    required this.theme,
    this.obscureText = false,
    this.obscuringWidget,
    this.hintCharacter,
    this.hintWidget,
    this.hintStyle,
  });

  /// The cell data containing state information.
  final PinCellData data;

  /// The resolved Material theme.
  final MaterialPinThemeData theme;

  /// Whether to obscure the text.
  final bool obscureText;

  /// Custom widget to show when obscuring text.
  final Widget? obscuringWidget;

  /// Hint character to show in empty cells.
  ///
  /// If null, falls back to [MaterialPinThemeData.hintCharacter].
  /// If [hintWidget] is provided, this is ignored.
  final String? hintCharacter;

  /// Custom widget to show in empty cells.
  ///
  /// When provided, this widget is displayed instead of [hintCharacter].
  final Widget? hintWidget;

  /// Style for hint character.
  ///
  /// If null, falls back to [MaterialPinThemeData.hintStyle].
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      width: theme.cellSize.width,
      height: theme.cellSize.height,
      decoration: _buildDecoration(),
      alignment: Alignment.center,
      child: MaterialCellContent(
        data: data,
        theme: theme,
        obscureText: obscureText,
        obscuringWidget: obscuringWidget,
        hintCharacter: hintCharacter,
        hintWidget: hintWidget,
        hintStyle: hintStyle,
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    final style = PinCellStateStyle.fromState(data, theme);

    return switch (theme.shape) {
      MaterialPinShape.outlined => buildOutlinedDecoration(
          fillColor: style.fillColor,
          borderColor: style.borderColor,
          borderWidth: style.borderWidth,
          borderRadius: theme.borderRadius,
          boxShadows: style.boxShadows,
        ),
      MaterialPinShape.filled => buildFilledDecoration(
          fillColor: style.fillColor,
          borderRadius: theme.borderRadius,
          boxShadows: style.boxShadows,
        ),
      MaterialPinShape.underlined => buildUnderlinedDecoration(
          fillColor: Colors.transparent,
          borderColor: style.borderColor,
          borderWidth: style.borderWidth,
          boxShadows: style.boxShadows,
        ),
      MaterialPinShape.circle => buildCircleDecoration(
          fillColor: style.fillColor,
          borderColor: style.borderColor,
          borderWidth: style.borderWidth,
          boxShadows: style.boxShadows,
        ),
    };
  }
}
