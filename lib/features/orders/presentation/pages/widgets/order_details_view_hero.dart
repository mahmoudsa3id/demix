import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';

class OrderDetailsViewHero extends StatelessWidget {
  const OrderDetailsViewHero({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final businessLogo = order.items.isNotEmpty
        ? order.items.first.businessLogo.trim()
        : '';

    return AppGlassCard(
      padding: const EdgeInsets.all(16),
      radius: 24,
      child: Row(
        children: [
          // Restaurant Logo
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: businessLogo.isNotEmpty
                  ? AppCachedImage(imageUrl: businessLogo, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.primary.withValues(alpha: 0.07),
                      child: Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.businessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '#${order.orderNumber}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
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
