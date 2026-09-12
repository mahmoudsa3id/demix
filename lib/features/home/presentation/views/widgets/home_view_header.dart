import 'dart:ui';

import 'package:demix/core/localization/locale_controller.dart';
import 'package:demix/core/routing/navigation.dart';
import 'package:demix/core/routing/router_names.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/utils/helper/helper_widgets.dart';
import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:demix/features/home/presentation/views/widgets/demix_logo.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewHeader extends StatelessWidget {
  const HomeViewHeader({super.key, required this.s});
  final S s;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          const DemixLogo(),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.deliveryTo,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.location_on_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Cairo, Egypt',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
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
