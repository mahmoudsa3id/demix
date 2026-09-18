import 'package:demix/core/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext c) {
    final s = Theme.of(c).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: s.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 44,
                color: s.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'السلة لسه فاضية',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'اختار أكلك المفضل من المطاعم وأضفه للسلة.',
              textAlign: TextAlign.center,
              style: TextStyle(color: s.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => c.go(RoutePaths.home),
              child: const Text('اكتشف المطاعم'),
            ),
          ],
        ),
      ),
    );
  }
}
