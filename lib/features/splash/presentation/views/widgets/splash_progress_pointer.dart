import 'package:flutter/material.dart';

class SplashProgressPainter extends CustomPainter {
  final double progress;

  const SplashProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;

    final lineWidth = size.width * progress;

    if (lineWidth <= 0) return;

    final endX = lineWidth.clamp(0.0, size.width);

    // Main gradient line
    final linePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF8A00FF),
          Color(0xFFB42CFF),
          Color(0xFFFF6A00),
          Color(0xFFFFB000),
        ],
      ).createShader(Rect.fromLTWH(0, centerY, endX, 0))
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, centerY), Offset(endX, centerY), linePaint);

    // Glow ONLY at the end
    final headGlowPaint = Paint()
      ..color = const Color(0xFFFFB52A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);

    canvas.drawCircle(Offset(endX, centerY), 5, headGlowPaint);

    // Bright white center
    final headPaint = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(endX, centerY), 2.3, headPaint);
  }

  @override
  bool shouldRepaint(covariant SplashProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
