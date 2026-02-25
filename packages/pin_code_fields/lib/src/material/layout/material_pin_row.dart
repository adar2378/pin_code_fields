import 'package:flutter/material.dart';

import '../../core/pin_cell_data.dart';
import '../cells/material_pin_cell.dart';
import '../theme/material_pin_theme.dart';

/// Row layout for Material PIN cells.
///
/// This widget arranges PIN cells horizontally with optional separators
/// between them.
class MaterialPinRow extends StatelessWidget {
  const MaterialPinRow({
    super.key,
    required this.cells,
    required this.theme,
    this.obscureText = false,
    this.obscuringWidget,
    this.hintCharacter,
    this.hintWidget,
    this.hintStyle,
    this.separatorBuilder,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
  });

  /// List of cell data for each PIN position.
  final List<PinCellData> cells;

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

  /// Optional builder for separators between cells.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// How the cells should be aligned horizontally.
  final MainAxisAlignment mainAxisAlignment;

  /// How the cells should be aligned vertically.
  final CrossAxisAlignment crossAxisAlignment;

  /// How much horizontal space the row should occupy.
  ///
  /// Defaults to [MainAxisSize.min], which makes the row wrap its contents
  /// and take up only as much horizontal space as needed by the cells and
  /// separators. Use [MainAxisSize.max] when you want the row to expand to
  /// fill the available horizontal space, for example to have the cells
  /// distributed across the full width of their parent.
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildChildren(context),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final children = <Widget>[];

    for (int i = 0; i < cells.length; i++) {
      // Add cell
      children.add(
        MaterialPinCell(
          data: cells[i],
          theme: theme,
          obscureText: obscureText,
          obscuringWidget: obscuringWidget,
          hintCharacter: hintCharacter,
          hintWidget: hintWidget,
          hintStyle: hintStyle,
        ),
      );

      // Add separator or spacing
      if (i < cells.length - 1) {
        if (separatorBuilder != null) {
          children.add(separatorBuilder!(context, i));
        } else {
          children.add(SizedBox(width: theme.spacing));
        }
      }
    }

    return children;
  }
}
