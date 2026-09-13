import 'package:flutter/material.dart';

class LogoWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(18, 0);

    path.cubicTo(size.width * .35, 4, size.width * .65, -4, size.width - 18, 2);

    path.quadraticBezierTo(size.width, size.height * .05, size.width - 3, 18);

    path.cubicTo(
      size.width + 6,
      size.height * .40,
      size.width - 5,
      size.height * .72,
      size.width - 12,
      size.height - 8,
    );

    path.quadraticBezierTo(
      size.width * .75,
      size.height,
      size.width * .70,
      size.height - 2,
    );

    path.cubicTo(
      size.width * .30,
      size.height + 3,
      size.width * .15,
      size.height - 4,
      8,
      size.height - 10,
    );

    path.quadraticBezierTo(-2, size.height * .70, 4, size.height * .48);

    path.cubicTo(2, size.height * .25, 5, size.height * .08, 18, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
