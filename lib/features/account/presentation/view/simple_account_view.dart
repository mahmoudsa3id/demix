import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/account/presentation/view/account_view_shell.dart';
import 'package:flutter/material.dart';

class SimpleAccountPage extends StatelessWidget {
  const SimpleAccountPage({
    super.key,
    required this.title,
    required this.icon,
    required this.message,
  });

  final String title;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AccountViewShell(
      title: title,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AccountCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.11),
                            AppColors.secondary.withValues(alpha: 0.11),
                          ],
                        ),
                      ),
                      child: Icon(icon, size: 34, color: AppColors.primary),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.65,
                        fontWeight: FontWeight.w500,
                      ),
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
