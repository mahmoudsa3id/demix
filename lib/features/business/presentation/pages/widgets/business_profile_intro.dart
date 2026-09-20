import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_profile_rating.dart';
import 'package:flutter/material.dart';

class BusinessProfileIntro extends StatelessWidget {
  const BusinessProfileIntro({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 23, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =================================================================
          // LEFT
          // =================================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.type.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        business.address?.trim().isNotEmpty == true
                            ? business.address!
                            : 'الموقع غير متوفر',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // =================================================================
          // RATING
          // =================================================================
          BusinessProfileRating(
            rating: business.rating,
            reviews: business.reviewCount,
          ),
        ],
      ),
    );
  }
}
