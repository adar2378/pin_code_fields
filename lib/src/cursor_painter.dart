import 'package:flutter/material.dart';

class CursorPainter extends CustomPainter {
  CursorPainter({this.cursorColor = Colors.black, this.cursorWidth = 2});

  final Color cursorColor;
  final double cursorWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(0, 0);
    final p2 = Offset(0, size.height);
    final paint = Paint()
      ..color = cursorColor
      ..strokeWidth = cursorWidth;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}
