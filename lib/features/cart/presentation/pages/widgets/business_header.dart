import 'package:demix/core/theme/app_radius.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';

class BusinessHeader extends StatelessWidget {
  const BusinessHeader({
    super.key,
    required this.businessName,
    required this.itemCount,
    required this.image,
  });
  final String businessName;
  final String image;
  final int itemCount;
  @override
  Widget build(BuildContext c) {
    final s = Theme.of(c).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: s.primaryContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: s.primary, shape: BoxShape.circle),
            child: AppCachedImage(
              imageUrl: image,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  '$itemCount قطعة في السلة',
                  style: TextStyle(fontSize: 12, color: s.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
