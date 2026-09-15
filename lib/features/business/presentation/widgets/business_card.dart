import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/utils/helper/business_hours_utils.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final isOpen = isBusinessCurrentlyOpen(
      open: business.workingHours?.open,
      close: business.workingHours?.close,
      isManuallyOpen: business.isOpen,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push(RoutePaths.restaurantDetails(business.id));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: .6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _BusinessLogo(imageUrl: business.logoUrl),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            business.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        _StatusBadge(
                          isOpen: isOpen,
                          openText: s.open,
                          closedText: s.closed,
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          business.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${business.reviewCount})',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),

                    if (business.workingHours != null) ...[
                      const SizedBox(height: 7),

                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 15),
                          const SizedBox(width: 5),
                          Text(
                            '${formatBusinessTime(business.workingHours!.open, context)} - ${formatBusinessTime(business.workingHours!.close, context)}',
                            style: const TextStyle(fontSize: 11.5),
                          ),
                        ],
                      ),
                    ],

                    if (business.address != null &&
                        business.address!.isNotEmpty) ...[
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 15),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              business.address!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _BusinessLogo extends StatelessWidget {
  const _BusinessLogo({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null || imageUrl!.isEmpty
          ? const Icon(
              Icons.storefront_rounded,
              size: 30,
              color: AppColors.textSecondary,
            )
          : AppCachedImage(
              imageUrl: imageUrl!,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.isOpen,
    required this.openText,
    required this.closedText,
  });

  final bool isOpen;
  final String openText;
  final String closedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: (isOpen ? Colors.green : Colors.red).withValues(alpha: .08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOpen ? openText : closedText,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: isOpen ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
