import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          s.favorites,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 45,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              s.favorites,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
