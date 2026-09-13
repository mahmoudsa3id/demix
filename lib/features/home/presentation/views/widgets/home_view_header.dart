import 'dart:ui';

import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/routing/navigation.dart';
import 'package:demix/core/routing/router_names.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/utils/helper/helper_widgets.dart';
import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:demix/features/home/presentation/views/widgets/demix_logo.dart';
import 'package:demix/features/location/presentation/cubit/saved_location_cubit.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeViewHeader extends StatelessWidget {
  const HomeViewHeader({super.key, required this.s});

  final S s;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const DemixLogo(),

          Expanded(
            child: BlocBuilder<SavedLocationCubit, SavedLocationState>(
              builder: (context, state) {
                String locationText = 'Select location';

                if (state is SavedLocationLoaded) {
                  final location = state.location;

                  if (location != null) {
                    if (location.formattedAddress != null &&
                        location.formattedAddress!.trim().isNotEmpty) {
                      locationText = location.formattedAddress!.trim();
                    } else if (location.city != null &&
                        location.city!.trim().isNotEmpty) {
                      locationText = location.city!.trim();
                    } else {
                      locationText = 'Add your address';
                    }
                  } else {
                    locationText = 'Add your address';
                  }
                }

                return GestureDetector(
                  onTap: () {
                    context.go(RoutePaths.location);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.deliveryTo,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: AppColors.secondary,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                locationText,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 6),

          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  final currentLocale = LocaleController.instance.locale;

                  LocaleController.instance.setLocale(
                    currentLocale.languageCode == 'ar'
                        ? const Locale('en')
                        : const Locale('ar'),
                  );
                },
                child: circleIcon(Icons.notifications_none_rounded),
              ),

              Positioned(right: -2, top: -3, child: badge('2')),
            ],
          ),

          const SizedBox(width: 5),

          GestureDetector(
            onTap: () async {
              await context.read<AuthCubit>().signOut();

              if (!context.mounted) return;

              popOrGo(context, fallback: RoutePaths.login);
            },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'MS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
