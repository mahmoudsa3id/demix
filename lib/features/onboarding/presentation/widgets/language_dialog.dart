import 'package:demix/core/db/shared_preferance.dart';
import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/theme/app_radius.dart';
import 'package:demix/core/theme/app_spacing.dart';
import 'package:demix/core/theme/app_text_styles.dart';
import 'package:demix/features/auth/presentation/views/widgets/demix_logo.dart';
import 'package:demix/features/onboarding/presentation/widgets/language_button.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(AppSpacing.md24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.borderRadiusXXL,
            border: Border.all(color: Colors.white.withValues(alpha: .08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .35),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DemixLogo(),

              const SizedBox(height: 24),

              Text(
                s.language,
                textAlign: TextAlign.center,
                style: AppTextStyles.cairoExtraBold.copyWith(
                  fontSize: 24,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                s.onboardingChooseLanguage,
                textAlign: TextAlign.center,
                style: AppTextStyles.cairoRegular.copyWith(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              LanguageButton(
                title: 'English',
                icon: '🇬🇧',
                onTap: () async {
                  LocaleController.instance.setLocale(const Locale('en'));

                  await SharedPreference.setLanguage('en');

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),

              const SizedBox(height: 12),

              LanguageButton(
                title: 'العربية',
                icon: '🇪🇬',
                onTap: () async {
                  LocaleController.instance.setLocale(const Locale('ar'));

                  await SharedPreference.setLanguage('ar');

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
