import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  const Section({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 9),
      child,
    ],
  );
}
