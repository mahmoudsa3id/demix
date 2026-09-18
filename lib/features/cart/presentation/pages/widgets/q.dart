import 'package:flutter/material.dart';

class Q extends StatelessWidget {
  const Q({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext c) {
    final s = Theme.of(c).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: s.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: s.primary),
      ),
    );
  }
}
