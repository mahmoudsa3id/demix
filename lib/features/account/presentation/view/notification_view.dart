import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/account/presentation/view/account_view_shell.dart';
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

    return AccountViewShell(
      title: s.notifications,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AccountSectionHeader(
                title: s.notifications,
                icon: Icons.notifications_none_rounded,
              ),

              const SizedBox(height: 12),

              AccountCard(
                child: Column(
                  children: [
                    AccountSwitchTile(
                      icon: Icons.receipt_long_outlined,
                      title: s.orderNotifications,
                      subtitle: s.orderNotificationsDescription,
                      value: orders,
                      accentColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          orders = value;
                        });
                      },
                    ),

                    const AccountDivider(),

                    AccountSwitchTile(
                      icon: Icons.local_offer_outlined,
                      title: s.offersNotifications,
                      subtitle: s.offersNotificationsDescription,
                      value: offers,
                      accentColor: AppColors.secondary,
                      onChanged: (value) {
                        setState(() {
                          offers = value;
                        });
                      },
                    ),

                    const AccountDivider(),

                    AccountSwitchTile(
                      icon: Icons.notifications_active_outlined,
                      title: s.generalNotifications,
                      subtitle: s.generalNotificationsDescription,
                      value: general,
                      accentColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          general = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
