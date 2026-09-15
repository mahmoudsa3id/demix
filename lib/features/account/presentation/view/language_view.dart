import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/theme/app_colors.dart';
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          s.language,
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
          _LanguageTile(
            title: s.arabic,
            subtitle: 'العربية',
            selected: currentLanguage == 'ar',
            onTap: () {
              _changeLanguage(context, 'ar');
            },
          ),
          const SizedBox(height: 12),
          _LanguageTile(
            title: s.english,
            subtitle: 'English',
            selected: currentLanguage == 'en',
            onTap: () {
              _changeLanguage(context, 'en');
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.secondary
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
