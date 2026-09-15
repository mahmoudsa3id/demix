import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.red : AppColors.secondary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(.40),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 21),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: danger ? Colors.red : AppColors.black,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: AppColors.black),
            ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
            color: AppColors.black,
          ),
      onTap: onTap,
    );
  }
}
