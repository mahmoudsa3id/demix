import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BusinessProfileRating extends StatelessWidget {
  const BusinessProfileRating({
    super.key,
    required this.rating,
    required this.reviews,
  });

  final double rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFB300)),
            const SizedBox(width: 3),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '$reviews تقييم',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
