import 'package:flutter/material.dart';

class OrderAnimatedEntry extends StatelessWidget {
  const OrderAnimatedEntry({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 360 + (index * 80)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: Transform.scale(scale: 0.97 + (value * 0.03), child: child),
          ),
        );
      },
      child: child,
    );
  }
}
