import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderIconBox extends StatelessWidget {
  const OrderIconBox({
    super.key,
    this.icon = Icons.receipt_long_rounded,
    this.color,
  });

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.primary;

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.12),
            accent.withValues(alpha: 0.045),
          ],
        ),
      ),
      child: Icon(icon, color: accent, size: 23),
    );
  }
}
