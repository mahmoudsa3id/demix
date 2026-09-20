import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class LocationCenterPin extends StatelessWidget {
  const LocationCenterPin({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Transform.translate(
          offset: const Offset(0, -18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              Container(width: 3, height: 18, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
