import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/utils/helper/helper_widgets.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key, required this.s});

  final S s;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedNav = 0;

  List<String> get _routes => [
    RoutePaths.home,
    RoutePaths.orders,
    RoutePaths.favorites,
    RoutePaths.cart,
    RoutePaths.profile,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final location = GoRouterState.of(context).uri.path;

    final index = _routes.indexOf(location);

    if (index != -1 && index != _selectedNav) {
      _selectedNav = index;
    }
  }

  void _onItemTap(int index) {
    if (_selectedNav == index) {
      return;
    }

    setState(() {
      _selectedNav = index;
    });

    context.go(_routes[index]);
  }

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
            final active = _selectedNav == i;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _onItemTap(i),
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
                          BlocBuilder<CartCubit, CartState>(
                            buildWhen: (previous, current) =>
                                previous.items != current.items,
                            builder: (context, state) {
                              final count = state.items.fold<int>(
                                0,
                                (sum, item) => sum + item.quantity,
                              );

                              if (count <= 0) {
                                return const SizedBox.shrink();
                              }

                              return Positioned(
                                right: -8,
                                top: -8,
                                child: badge(count > 99 ? '99+' : '$count'),
                              );
                            },
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
