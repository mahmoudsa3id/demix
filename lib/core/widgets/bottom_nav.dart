import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.s});

  final S s;

  List<String> get _routes => [
    RoutePaths.home,
    RoutePaths.orders,
    RoutePaths.favorites,
    RoutePaths.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    final index = _routes.indexOf(location);

    return index == -1 ? 0 : index;
  }

  void _onItemTap(BuildContext context, int index) {
    final currentIndex = _currentIndex(context);

    if (currentIndex == index) {
      return;
    }

    // خلي GoRouter هو المسؤول عن تغيير الـ route.
    // ممنوع setState هنا.
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _currentIndex(context);

    final labels = [s.home, s.orders, s.favorites, s.profile];

    final icons = [
      Icons.home_rounded,
      Icons.shopping_bag_outlined,
      Icons.favorite_border_rounded,
      Icons.person,
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
            final active = selectedIndex == i;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _onItemTap(context, i),
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
