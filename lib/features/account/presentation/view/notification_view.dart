import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool orders = true;
  bool offers = true;
  bool general = true;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          s.notifications,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _NotificationTile(
            title: s.orderNotifications,
            subtitle: s.orderNotificationsDescription,
            value: orders,
            onChanged: (value) {
              setState(() => orders = value);
            },
          ),
          const SizedBox(height: 12),
          _NotificationTile(
            title: s.offersNotifications,
            subtitle: s.offersNotificationsDescription,
            value: offers,
            onChanged: (value) {
              setState(() => offers = value);
            },
          ),
          const SizedBox(height: 12),
          _NotificationTile(
            title: s.generalNotifications,
            subtitle: s.generalNotificationsDescription,
            value: general,
            onChanged: (value) {
              setState(() => general = value);
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
