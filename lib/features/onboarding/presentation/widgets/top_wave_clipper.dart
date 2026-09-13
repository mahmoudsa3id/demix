import 'package:flutter/material.dart';

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height * .72);

    path.cubicTo(
      size.width * .82,
      size.height * .82,
      size.width * .65,
      size.height * .70,
      size.width * .50,
      size.height * .78,
    );

    path.cubicTo(
      size.width * .32,
      size.height * .88,
      size.width * .16,
      size.height * .68,
      0,
      size.height * .76,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
