import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/account/presentation/view/account_view_shell.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  Future<void> _changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    await LocaleController.instance.setLocale(Locale(languageCode));

    if (!context.mounted) return;

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final currentLanguage = Localizations.localeOf(context).languageCode;

    return AccountViewShell(
      title: s.language,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AccountSectionHeader(
                title: s.language,
                icon: Icons.language_rounded,
              ),

              const SizedBox(height: 12),

              AccountCard(
                child: Column(
                  children: [
                    _LanguageOption(
                      title: s.arabic,
                      subtitle: 'العربية',
                      selected: currentLanguage == 'ar',
                      accentColor: AppColors.secondary,
                      onTap: () {
                        _changeLanguage(context, 'ar');
                      },
                    ),

                    const AccountDivider(),

                    _LanguageOption(
                      title: s.english,
                      subtitle: 'English',
                      selected: currentLanguage == 'en',
                      accentColor: AppColors.primary,
                      onTap: () {
                        _changeLanguage(context, 'en');
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

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.10),
                    accentColor.withValues(alpha: 0.04),
                  ],
                ),
              ),
              child: Icon(
                Icons.translate_rounded,
                color: accentColor,
                size: 21,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? accentColor
                      : AppColors.textSecondary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
