import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/orders/domain/entities/order_item_snapshot.dart';
import 'package:flutter/material.dart';

class OrderDetailsViewProductTile extends StatelessWidget {
  const OrderDetailsViewProductTile({super.key, required this.item});

  final OrderItemSnapshot item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl?.trim() ?? '';

    final title = item.nameAr?.trim().isNotEmpty == true
        ? item.nameAr!
        : item.name;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: imageUrl.isNotEmpty
              ? AppCachedImage(
                  imageUrl: imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: const Color(0xFFF3F3F5),
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '× ${item.quantity}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '${item.unitPrice.toStringAsFixed(0)} ج',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Text(
          '${item.lineTotal.toStringAsFixed(0)} ج',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
