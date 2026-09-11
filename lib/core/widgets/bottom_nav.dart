import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/utils/helper/helper_widgets.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key, required this.s});
  final S s;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

int selectedNav = 0;

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    final labels = [
      widget.s.home,
      widget.s.orders,
      widget.s.favorites,
      widget.s.cart,
      widget.s.profile,
    ];
    final icons = [
      Icons.home_rounded,
      Icons.shopping_bag_outlined,
      Icons.favorite_border_rounded,
      Icons.shopping_cart_outlined,
      Icons.person_outline_rounded,
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.09),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(labels.length, (i) {
            final active = selectedNav == i;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => selectedNav = i),
              child: SizedBox(
                width: 55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          icons[i],
                          size: 25,
                          color: active
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                        ),
                        if (i == 3)
                          Positioned(right: -6, top: -7, child: badge('2')),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                        color: active
                            ? AppColors.secondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
