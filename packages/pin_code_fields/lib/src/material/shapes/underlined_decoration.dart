import 'package:material_ui/material_ui.dart';

/// Builds a BoxDecoration for an underlined PIN cell.
///
/// This creates a cell with only a bottom border.
BoxDecoration buildUnderlinedDecoration({
  required Color fillColor,
  required Color borderColor,
  required double borderWidth,
  List<BoxShadow>? boxShadows,
}) {
  return BoxDecoration(
    color: fillColor,
    border: Border(
      bottom: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    ),
    boxShadow: boxShadows,
  );
}
