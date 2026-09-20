import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_profile_hero_actions.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_profile_hero_logo.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_profile_live_open_status_pill.dart';
import 'package:demix/features/business/presentation/pages/widgets/type_pill.dart';
import 'package:flutter/material.dart';

class BusinessProfileHero extends StatelessWidget {
  const BusinessProfileHero({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final coverUrl = business.coverUrl?.trim() ?? '';
    final logoUrl = business.logoUrl?.trim() ?? '';

    final isCafe = business.type.trim().toLowerCase() == 'cafe';

    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ===================================================================
          // COVER
          // ===================================================================
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(42),
              bottomRight: Radius.circular(42),
            ),
            child: coverUrl.isNotEmpty
                ? AppCachedImage(imageUrl: coverUrl, fit: BoxFit.cover)
                : DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                    ),
                  ),
          ),

          // ===================================================================
          // DARK OVERLAY
          // ===================================================================
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.35, 0.65, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: .08),
                    Colors.transparent,
                    Colors.black.withValues(alpha: .28),
                    Colors.black.withValues(alpha: .78),
                  ],
                ),
              ),
            ),
          ),

          // ===================================================================
          // BRAND GLOW
          // ===================================================================
          Positioned(
            top: -90,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: .22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ===================================================================
          // LIVE STATUS
          // ===================================================================
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            right: 16,
            child: BusinessProfileLiveOpenStatus(business: business),
          ),

          // ===================================================================
          // FAVORITE / BACK
          // ===================================================================
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: BusinessProfileHeroActions(business: business),
          ),

          // ===================================================================
          // BUSINESS CONTENT
          // ===================================================================
          Positioned(
            left: 18,
            right: 18,
            bottom: 22,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // =============================================================
                // TEXT
                // =============================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------------------------------------------------------
                      // TYPE
                      // -------------------------------------------------------
                      Row(
                        children: [
                          TypePill(
                            icon: isCafe
                                ? Icons.local_cafe_rounded
                                : Icons.restaurant_rounded,
                            title: isCafe ? 'كافيه' : 'مطعم',
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // -------------------------------------------------------
                      // NAME
                      // -------------------------------------------------------
                      Text(
                        business.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          height: 1.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // -------------------------------------------------------
                      // ADDRESS
                      // -------------------------------------------------------
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white70,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              business.address?.trim().isNotEmpty == true
                                  ? business.address!
                                  : 'توصيل إلى موقعك',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // LOGO
                // =============================================================
                if (logoUrl.isNotEmpty) ...[
                  const SizedBox(width: 15),
                  BusinessProfileHeroLogo(imageUrl: logoUrl),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
