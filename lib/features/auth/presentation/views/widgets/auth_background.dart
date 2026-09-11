import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFCFA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38),
          topRight: Radius.circular(38),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -48,
            right: 125,
            child: Transform.rotate(
              angle: -0.08,
              child: Container(
                width: 185,
                height: 105,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF5A00), Color(0xFFFF3F16)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 45,
            right: -38,
            child: Transform.rotate(
              angle: -0.72,
              child: Container(
                width: 145,
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF9E34F4), Color(0xFFCF70E9)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(70)),
                ),
              ),
            ),
          ),

          Positioned(
            right: -45,
            bottom: 105,
            child: Transform.rotate(
              angle: -0.55,
              child: Container(
                width: 125,
                height: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6900), Color(0xFFFF4D16)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(65)),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -45,
            left: 280,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 160,
                height: 105,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8E29F4),
                      Color(0xFFB538D7),
                      Color(0xFFFF4B00),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                ),
              ),
            ),
          ),

          child,
        ],
      ),
    );
  }
}
