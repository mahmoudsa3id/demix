import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeBusinessError extends StatelessWidget {
  const HomeBusinessError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 22,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.failedToLoadRestaurants,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: onRetry, child: Text(s.retry)),
          ],
        ),
      ),
    );
  }
}
