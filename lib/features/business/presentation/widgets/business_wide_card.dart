import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/business.dart';

class BusinessWideCard extends StatelessWidget {
  const BusinessWideCard({
    super.key,
    required this.business,
  });

  final Business business;

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode ==
            'ar';

    final cover =
        business.coverUrl?.trim() ?? '';

    final logo =
        business.logoUrl?.trim() ?? '';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            AppRadius.borderRadiusLarge,
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                AppRadius.borderRadiusMedium,
            child: SizedBox(
              width: 105,
              height: 105,
              child: cover.isEmpty
                  ? Container(
                      color:
                          AppColors.surfaceLight,
                      child: const Icon(
                        Icons.storefront_rounded,
                        color:
                            AppColors.textSecondary,
                        size: 30,
                      ),
                    )
                  : AppCachedImage(
                      imageUrl: cover,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        business.displayName(
                          isArabic: isArabic,
                        ),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              AppColors.black,
                        ),
                      ),
                    ),

                    if (logo.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      ClipOval(
                        child: AppCachedImage(
                          imageUrl: logo,
                          width: 34,
                          height: 34,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 17,
                      color:
                          AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      business.rating
                          .toStringAsFixed(1),
                      style:
                          const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '(${business.reviewCount})',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          fontSize: 12,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color:
                          AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${business.estimatedDeliveryTime} min',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color: AppColors
                            .textSecondary,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.delivery_dining_rounded,
                      size: 16,
                      color:
                          AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${business.deliveryFee.toStringAsFixed(0)} EGP',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color: AppColors
                            .textSecondary,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  business.type == 'cafe'
                      ? (isArabic
                          ? 'كافيه'
                          : 'Cafe')
                      : (isArabic
                          ? 'مطعم'
                          : 'Restaurant'),
                  style: const TextStyle(
                    fontSize: 12,
                    color:
                        AppColors.primary,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
