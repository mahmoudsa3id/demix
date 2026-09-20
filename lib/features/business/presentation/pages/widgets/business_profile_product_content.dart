import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_profile_add_button.dart';
import 'package:demix/features/product_ordering/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessProfileProductContent extends StatelessWidget {
  const BusinessProfileProductContent({
    super.key,
    required this.product,
    required this.business,
    required this.index,
  });

  final Product product;
  final Business business;
  final int index;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl?.trim() ?? '';

    final title = product.nameAr?.trim().isNotEmpty == true
        ? product.nameAr!
        : product.name;

    final description = (product.descriptionAr ?? product.description ?? '')
        .trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () {
          context.push(
            RoutePaths.product,
            extra: ProductDetailsArguments(
              product: product,
              business: business,
            ),
          );
        },
        splashColor: AppColors.primary.withValues(alpha: .025),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // =============================================================
              // IMAGE
              // =============================================================
              Hero(
                tag: 'product-image-${product.id}',
                child: Container(
                  width: 108,
                  height: 108,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .04),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: imageUrl.isNotEmpty
                      ? AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover)
                      : Icon(
                          Icons.fastfood_rounded,
                          color: AppColors.textSecondary,
                          size: 30,
                        ),
                ),
              ),

              const SizedBox(width: 15),

              // =============================================================
              // INFO
              // =============================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.07,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.45,
                      ),
                    ),

                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(0)} ج',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(width: 8),

                        if (product.isAvailable)
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // =============================================================
              // ADD
              // =============================================================
              BusinessProfileAddButton(product: product, business: business),
            ],
          ),
        ),
      ),
    );
  }
}
