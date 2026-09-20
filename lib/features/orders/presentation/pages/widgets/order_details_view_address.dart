import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderDetailsViewAddress extends StatelessWidget {
  const OrderDetailsViewAddress({super.key, required this.address});

  final dynamic address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.secondary.withValues(alpha: 0.08),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: AppColors.secondary,
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              address.formattedAddress,
              style: const TextStyle(
                fontSize: 12,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
