import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';

class BusinessProfileHeroLogo extends StatelessWidget {
  const BusinessProfileHeroLogo({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 850),
      curve: Curves.elasticOut,
      tween: Tween(begin: .75, end: 1),
      builder: (_, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 72,
        height: 72,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .22),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
