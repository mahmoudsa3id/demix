import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentPage;
  final int count;

  const OnboardingIndicator({
    super.key,
    required this.currentPage,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: active
                ? const LinearGradient(
                    colors: [
                      Color(0xFFFF7900),
                      Color(0xFFFF3B45),
                      Color(0xFF7900FF),
                    ],
                  )
                : null,
            color: active ? null : const Color(0xFFE0DEE4),
          ),
        );
      }),
    );
  }
}
