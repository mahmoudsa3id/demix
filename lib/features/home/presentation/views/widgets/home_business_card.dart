import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/utils/helper/business_hours_utils.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeBusinessCard extends StatelessWidget {
  const HomeBusinessCard({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final isOpen = isBusinessCurrentlyOpen(
      open: business.workingHours?.open,
      close: business.workingHours?.close,
      isManuallyOpen: business.isOpen,
    );

    return GestureDetector(
      onTap: () {
        context.push(RoutePaths.restaurantDetails(business.id));
      },
      child: Container(
        width: 145,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: .55)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .035),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 82,
              width: double.infinity,
              child: business.coverUrl == null || business.coverUrl!.isEmpty
                  ? const ColoredBox(
                      color: AppColors.background,
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 28,
                        color: AppColors.secondary,
                      ),
                    )
                  : AppCachedImage(
                      imageUrl: business.coverUrl!,
                      width: double.infinity,
                      height: 82,
                      fit: BoxFit.cover,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        business.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOpen ? Colors.green : Colors.red,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        isOpen ? s.open : s.closed,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isOpen ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  if (business.workingHours != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${formatBusinessTime(business.workingHours!.open, context)} - ${formatBusinessTime(business.workingHours!.close, context)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
