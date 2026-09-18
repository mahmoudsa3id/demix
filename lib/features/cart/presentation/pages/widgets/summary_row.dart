import 'package:flutter/widgets.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow(this.title, this.value, {super.key, this.strong = false});
  final String title;
  final double value;
  final bool strong;
  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '${value.toStringAsFixed(0)} ج',
          style: TextStyle(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
