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
      height: height,
      cacheManager: AppCacheManager.instance,
      fit: fit,

      fadeInDuration: const Duration(milliseconds: 220),
      fadeOutDuration: const Duration(milliseconds: 120),
      placeholderFadeInDuration: const Duration(milliseconds: 120),

      placeholder: (context, url) {
        return placeholder ?? const _ImageSkeleton();
      },

      errorWidget: (context, url, error) {
        return errorWidget ?? const _ImageError();
      },
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

// ============================================================================
// PREMIUM IMAGE SKELETON
// ============================================================================

class _ImageSkeleton extends StatefulWidget {
  const _ImageSkeleton();

  @override
  State<_ImageSkeleton> createState() => _ImageSkeletonState();
}

class _ImageSkeletonState extends State<_ImageSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final progress = _controller.value;

            final gradient = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFFF1F1F4),
                const Color(0xFFF1F1F4),
                AppColors.primary.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.80),
                AppColors.secondary.withValues(alpha: 0.06),
                const Color(0xFFF1F1F4),
                const Color(0xFFF1F1F4),
              ],
              stops: [
                0.0,
                (progress - 0.30).clamp(0.0, 1.0),
                (progress - 0.12).clamp(0.0, 1.0),
                progress.clamp(0.0, 1.0),
                (progress + 0.12).clamp(0.0, 1.0),
                (progress + 0.30).clamp(0.0, 1.0),
                1.0,
              ],
            );

            return gradient.createShader(bounds);
          },
          child: Container(color: const Color(0xFFF1F1F4)),
        );
      },
    );
  }
}
// ============================================================================
// IMAGE ERROR
// ============================================================================

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      alignment: Alignment.center,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textSecondary,
          size: 21,
        ),
      ),
    );
  }
}
