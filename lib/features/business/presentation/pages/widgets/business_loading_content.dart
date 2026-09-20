import 'package:flutter/material.dart';

class BusinessLoadingContent extends StatefulWidget {
  const BusinessLoadingContent({super.key});

  @override
  State<BusinessLoadingContent> createState() => _BusinessLoadingContentState();
}

class _BusinessLoadingContentState extends State<BusinessLoadingContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final progress = Curves.easeInOut.transform(_controller.value);

        final baseColor = Color.lerp(
          const Color(0xFFEDEDF1),
          Colors.white,
          progress,
        )!;

        return Column(
          children: List.generate(3, (index) {
            return Container(
              height: 220,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white),
              ),
            );
          }),
        );
      },
    );
  }
}
