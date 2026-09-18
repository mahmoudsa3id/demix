import 'package:flutter/material.dart';

class HomeBusinessLoading extends StatelessWidget {
  const HomeBusinessLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 158,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (_, __) {
          return Container(
            width: 145,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}
