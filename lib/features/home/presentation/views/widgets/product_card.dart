import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/theme/app_radius.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final int index;
  final String name;
  final String price;
  final String image;
  final S s;
  const ProductCard({
    super.key,
    required this.index,
    required this.name,
    required this.price,
    required this.image,
    required this.s,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SizedBox(
      width: 110,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: AppCachedImage(
                    imageUrl: widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 4, 18, 0),
                  child: Text(
                    widget.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 4, 0),
                  child: Text(
                    isArabic
                        ? '${widget.price} ${widget.s.currency} '
                        : '${widget.s.currency} ${widget.price}',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 15,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
