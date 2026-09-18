import 'package:demix/constants/constants.dart';
import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/theme/app_radius.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

Widget offerItem(S s) {
  final local = LocaleController.instance.locale.languageCode == 'ar';
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17),
    child: Container(
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderRadiusMedium,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFEFE7), Color(0xFFFFFAF7)],
        ),
      ),
      child: Row(
        children: [
          // Image
          SizedBox(
            width: 150,
            height: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AppCachedImage(
                    imageUrl: Constants.pasta,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: local
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        end: local
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        colors: [
                          const Color(0x00FFF3EB),
                          const Color(0xFFFFF3EB),
                        ],
                        stops: [0.45, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 8, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.specialOffer.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 7,
                      letterSpacing: 1.7,
                      color: Color(0xFF85858D),
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'cairo',
                      ),
                      children: [
                        TextSpan(text: '${s.discountPrefix} '),
                        const TextSpan(
                          text: '50%',
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 1),

                  Text(
                    s.offerDescription,
                    style: const TextStyle(
                      fontSize: 7,
                      color: Color(0xFF666870),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: AppRadius.borderRadiusCircular,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          s.orderNow,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.white,
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
