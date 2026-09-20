import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BusinessCategoryIcon extends StatelessWidget {
  const BusinessCategoryIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: .13),
            AppColors.secondary.withValues(alpha: .13),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white, width: 1.2),
      ),
      child: Icon(icon, color: AppColors.primary, size: 23),
    );
  }
}
