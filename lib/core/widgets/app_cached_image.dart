import 'package:cached_network_image/cached_network_image.dart';
import 'package:demix/core/db/cached_images/cached_manager.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      cacheManager: AppCacheManager.instance,

      height: height,
      fit: fit,

      fadeInDuration: const Duration(milliseconds: 180),

      fadeOutDuration: const Duration(milliseconds: 100),

      placeholderFadeInDuration: const Duration(milliseconds: 100),

      placeholder: (context, url) {
        return placeholder ??
            const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 1.8,
                  color: AppColors.primary,
                ),
              ),
            );
      },

      errorWidget: (context, url, error) {
        return errorWidget ??
            const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
            );
      },
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
