import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/theme/app_radius.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

Widget search(S s) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17),
    child: Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.borderRadiusCircular,
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 28, color: AppColors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              s.searchHint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF8F929D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, size: 26, color: AppColors.black),
        ],
      ),
    ),
  );
}
