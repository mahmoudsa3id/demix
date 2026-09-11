import 'package:flutter/material.dart';

class DemixCurveGradient {
  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFF5A00), // Orange
      Color(0xFFFF3D3D), // Red
      Color(0xFFFF3D70), // Pink
      Color(0xFF7B22E8), // Purple
    ],
    stops: [0.0, 0.38, 0.68, 1.0],
  );
}

// ============================================================
// SMALL CURVE
// ============================================================

class DemixCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(1.5, 1.5)
      ..cubicTo(7.0, 10.0, 13.0, 12.0, 22.0, 12.0)
      ..cubicTo(31.0, 12.0, 40.0, 9.0, 47.0, 2.0);

    paint.shader = DemixCurveGradient.gradient.createShader(Offset.zero & size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// LARGE LOGO CURVE
// ============================================================

class DemixCurvePainterLogo extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(3, 3)
      ..cubicTo(11, 18, 26, 22, 39, 22)
      ..cubicTo(55, 22, 69, 17, 82, 4);

    paint.shader = DemixCurveGradient.gradient.createShader(Offset.zero & size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
