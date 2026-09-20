import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/business/domain/entities/product_category.dart';
import 'package:flutter/material.dart';

class BusinessProfileCategoryNavigator extends StatefulWidget {
  const BusinessProfileCategoryNavigator({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<ProductCategory> categories;
  final int selectedCategory;
  final ValueChanged<int> onSelected;

  @override
  State<BusinessProfileCategoryNavigator> createState() =>
      _BusinessProfileCategoryNavigatorState();
}

class _BusinessProfileCategoryNavigatorState
    extends State<BusinessProfileCategoryNavigator> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant BusinessProfileCategoryNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _centerSelected();
    }
  }

  void _centerSelected() {
    if (!_scrollController.hasClients) {
      return;
    }

    final estimatedItemWidth = 112.0;

    final target =
        (widget.selectedCategory * estimatedItemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        estimatedItemWidth / 2;

    final max = _scrollController.position.maxScrollExtent;

    _scrollController.animateTo(
      target.clamp(0, max),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.categories.length + 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 7, 18, 7),
      child: Row(
        children: [
          // =================================================================
          // BIG NUMBER
          // =================================================================
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 330),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, .3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey(widget.selectedCategory),
              width: 45,
              child: Text(
                (widget.selectedCategory + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 1,
            height: 46,
            color: Colors.black.withValues(alpha: .07),
          ),

          const SizedBox(width: 14),

          // =================================================================
          // CATEGORY LIST
          // =================================================================
          Expanded(
            child: SizedBox(
              height: 72,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: total,
                itemBuilder: (context, index) {
                  final active = index == widget.selectedCategory;

                  final title = index == 0
                      ? 'الكل'
                      : _categoryName(widget.categories[index - 1]);

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onSelected(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsetsDirectional.only(end: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              color: active
                                  ? AppColors.black
                                  : AppColors.textSecondary,
                              fontSize: active ? 15 : 11.5,
                              fontWeight: active
                                  ? FontWeight.w900
                                  : FontWeight.w600,
                              fontFamily: 'cairo',
                              letterSpacing: active ? -.4 : 0,
                            ),
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 9),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                            width: active ? 42 : 0,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryName(ProductCategory category) {
    if (category.nameAr?.trim().isNotEmpty == true) {
      return category.nameAr!;
    }

    return category.name;
  }
}
