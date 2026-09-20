import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/account/presentation/view/account_view_shell.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return AccountViewShell(
      title: s.about,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AccountCard(
                padding: const EdgeInsets.all(26),
                child: Column(
                  children: [
                    // =====================================================
                    // LOGO
                    // =====================================================
                    Container(
                      width: 92,
                      height: 92,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(29),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.16),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(27),
                        ),
                        child: Icon(
                          Icons.local_dining_rounded,
                          size: 43,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 21),

                    // =====================================================
                    // BRAND
                    // =====================================================
                    Text(
                      'DeMiX',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Food made simple.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.055),
                            AppColors.secondary.withValues(alpha: 0.055),
                          ],
                        ),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        s.aboutDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.65,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // =====================================================
                    // VERSION
                    // =====================================================
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7FA),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_outlined,
                            size: 15,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '${s.version} 1.0.0',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===========================================================
              // BRAND FOOTER
              // ===========================================================
              Center(
                child: Text(
                  'DeMiX',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.55),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
