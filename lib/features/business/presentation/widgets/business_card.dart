import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/business.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({
    super.key,
    required this.business,
  });

  final Business business;

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode ==
            'ar';

    final imageUrl =
        business.coverUrl?.trim() ?? '';

    return SizedBox(
      width: 120,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 85,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    AppCachedImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: AppColors.surfaceLight,
                      child: const Icon(
                        Icons.storefront_rounded,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),

                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration:
                          const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 20,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 3,
                    bottom: 3,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white
                            .withOpacity(.95),
                        borderRadius: AppRadius
                            .borderRadiusSmall,
                      ),
                      child: Text(
                        '${business.estimatedDeliveryTime} min',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                5,
                4,
                4,
                0,
              ),
              child: Text(
                business.displayName(
                  isArabic: isArabic,
                ),
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                5,
                2,
                4,
                0,
              ),
              child: Row(
                children: [
                  const Text(
                    '★',
                    style: TextStyle(
                      color:
                          AppColors.secondary,
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      '${business.rating.toStringAsFixed(1)} (${business.reviewCount})',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8,
                        color:
                            AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                5,
                2,
                3,
                0,
              ),
              child: Text(
                business.type == 'cafe'
                    ? (isArabic ? 'كافيه' : 'Cafe')
                    : (isArabic
                        ? 'مطعم'
                        : 'Restaurant'),
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 8,
                  color:
                      AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
