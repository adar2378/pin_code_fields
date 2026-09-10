import 'package:material_ui/material_ui.dart';

/// Builds a BoxDecoration for a filled PIN cell.
///
/// This creates a cell with solid fill color and no visible border.
BoxDecoration buildFilledDecoration({
  required Color fillColor,
  required BorderRadius borderRadius,
  List<BoxShadow>? boxShadows,
}) {
  return BoxDecoration(
    color: fillColor,
    borderRadius: borderRadius,
    boxShadow: boxShadows,
  );
}
