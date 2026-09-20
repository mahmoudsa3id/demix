import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BusinessTopButton extends StatelessWidget {
  const BusinessTopButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .90),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 45,
          height: 45,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 17,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
