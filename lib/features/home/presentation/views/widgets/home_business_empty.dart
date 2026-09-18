import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeBusinessEmpty extends StatelessWidget {
  const HomeBusinessEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 34,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              s.noRestaurantsAvailable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
