import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/orders/presentation/pages/widgets/order_icon_box.dart';
import 'package:flutter/material.dart';

class BusinessImage extends StatelessWidget {
  const BusinessImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const OrderIconBox(icon: Icons.restaurant_rounded);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: AppCachedImage(
        imageUrl: imageUrl,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
      ),
    );
  }
}
