import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BusinessSearchBar extends StatelessWidget {
  const BusinessSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isCafe,
    required this.hasQuery,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isCafe;
  final bool hasQuery;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: focusNode.hasFocus
              ? AppColors.primary.withValues(alpha: .20)
              : Colors.white,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .035),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 7),

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: .09),
                  AppColors.secondary.withValues(alpha: .09),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: 'ابحث عن ${isCafe ? 'كافيه' : 'مطعم'}...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: hasQuery
                ? IconButton(
                    key: const ValueKey('clear'),
                    onPressed: onClear,
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  )
                : Container(
                    key: const ValueKey('filter'),
                    margin: const EdgeInsets.only(right: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F8),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: AppColors.textSecondary,
                      size: 19,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
