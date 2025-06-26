import 'package:flutter/material.dart';

class CursorPainter extends CustomPainter {
  CursorPainter({
    this.cursorColor = Colors.black,
    this.cursorWidth = 2,
    this.cursorRadius = 0,
  });

  final Color cursorColor;
  final double cursorWidth;
  final double cursorRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      -cursorWidth / 2,
      0,
      cursorWidth,
      size.height,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(cursorRadius),
    );
    final paint = Paint()
      ..color = cursorColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}
