import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:flutter/material.dart';

class BusinessSearchEmptyState extends StatelessWidget {
  const BusinessSearchEmptyState({
    super.key,
    required this.isSearch,
    required this.isCafe,
    required this.query,
    required this.onClear,
  });

  final bool isSearch;
  final bool isCafe;
  final String query;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final icon = isSearch
        ? Icons.search_off_rounded
        : (isCafe ? Icons.local_cafe_rounded : Icons.restaurant_rounded);

    final title = isSearch ? 'مفيش نتائج' : 'مفيش أماكن متاحة';

    final message = isSearch
        ? 'مش موجود مكان مطابق لـ "$query"'
        : 'مفيش أماكن متاحة حاليًا.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppGlassCard(
          padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
          radius: 26,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: .09),
                      AppColors.secondary.withValues(alpha: .10),
                    ],
                  ),
                ),
                child: Icon(icon, color: AppColors.primary, size: 35),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onClear != null) ...[
                const SizedBox(height: 17),
                SizedBox(
                  height: 43,
                  child: FilledButton(
                    onPressed: onClear,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'مسح البحث',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
