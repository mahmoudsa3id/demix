import 'package:flutter/material.dart';

class CheckoutSection extends StatelessWidget {
  const CheckoutSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
