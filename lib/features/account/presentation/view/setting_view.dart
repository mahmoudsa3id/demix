import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/account/presentation/view/account_view_shell.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return AccountViewShell(
      title: s.settings,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AccountSectionHeader(
                title: s.settings,
                icon: Icons.settings_outlined,
              ),

              const SizedBox(height: 12),

              AccountCard(
                child: Column(
                  children: [
                    AccountTile(
                      icon: Icons.language_rounded,
                      title: s.language,
                      subtitle: s.manageLanguage,
                      accentColor: AppColors.secondary,
                      onTap: () {
                        context.push(RoutePaths.language);
                      },
                    ),

                    const AccountDivider(),

                    AccountTile(
                      icon: Icons.notifications_none_rounded,
                      title: s.notifications,
                      subtitle: s.manageNotifications,
                      accentColor: AppColors.primary,
                      onTap: () {
                        context.push(RoutePaths.notifications);
                      },
                    ),

                    const AccountDivider(),

                    AccountTile(
                      icon: Icons.lock_outline_rounded,
                      title: s.security,
                      subtitle: s.privacyAndSecurity,
                      accentColor: AppColors.secondary,
                      onTap: () {
                        context.push(RoutePaths.privacy);
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
