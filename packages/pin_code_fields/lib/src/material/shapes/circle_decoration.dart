import 'package:material_ui/material_ui.dart';

/// Builds a BoxDecoration for a circular PIN cell.
///
/// This creates a cell with a circular shape.
BoxDecoration buildCircleDecoration({
  required Color fillColor,
  required Color borderColor,
  required double borderWidth,
  List<BoxShadow>? boxShadows,
}) {
  return BoxDecoration(
    color: fillColor,
    shape: BoxShape.circle,
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
    boxShadow: boxShadows,
  );
}
