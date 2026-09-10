import 'package:material_ui/material_ui.dart';

/// Builds a BoxDecoration for an outlined PIN cell.
///
/// This creates a cell with a border on all sides.
BoxDecoration buildOutlinedDecoration({
  required Color fillColor,
  required Color borderColor,
  required double borderWidth,
  required BorderRadius borderRadius,
  List<BoxShadow>? boxShadows,
}) {
  return BoxDecoration(
    color: fillColor,
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
    borderRadius: borderRadius,
    boxShadow: boxShadows,
  );
}
