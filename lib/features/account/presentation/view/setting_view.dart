import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          s.settings,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingCard(
            icon: Icons.language_rounded,
            title: s.language,
            subtitle: s.manageLanguage,
            onTap: () {
              context.push(RoutePaths.language);
            },
          ),
          const SizedBox(height: 12),
          _SettingCard(
            icon: Icons.notifications_none_rounded,
            title: s.notifications,
            subtitle: s.manageNotifications,
            onTap: () {
              context.push(RoutePaths.notifications);
            },
          ),
          const SizedBox(height: 12),
          _SettingCard(
            icon: Icons.lock_outline_rounded,
            title: s.security,
            subtitle: s.privacyAndSecurity,
            onTap: () {
              context.push(RoutePaths.privacy);
            },
          ),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.secondary),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.black),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.black, fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
        onTap: onTap,
      ),
    );
  }
}
