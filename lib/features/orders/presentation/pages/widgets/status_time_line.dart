import 'package:flutter/material.dart';

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext c) {
    const statuses = [
      'pending',
      'accepted',
      'preparing',
      'outForDelivery',
      'delivered',
    ];
    final current = statuses.indexOf(status);
    return Column(
      children: List.generate(statuses.length, (i) {
        final active = current < 0 ? i == 0 : i <= current;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: active
                        ? Theme.of(c).colorScheme.primary
                        : Theme.of(c).colorScheme.surface,
                    border: Border.all(
                      color: active
                          ? Theme.of(c).colorScheme.primary
                          : Theme.of(c).colorScheme.outline,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: active
                      ? Icon(
                          Icons.check,
                          size: 13,
                          color: Theme.of(c).colorScheme.onPrimary,
                        )
                      : null,
                ),
                if (i < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 30,
                    color: active
                        ? Theme.of(c).colorScheme.primary
                        : Theme.of(c).colorScheme.outlineVariant,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                _label(statuses[i]),
                style: TextStyle(
                  fontWeight: active ? FontWeight.w900 : FontWeight.w500,
                  color: active
                      ? null
                      : Theme.of(c).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

String _label(String x) => switch (x) {
  'pending' => 'تم استلام الطلب',
  'accepted' => 'المطعم قبل الطلب',
  'preparing' => 'جاري التحضير',
  'outForDelivery' => 'خرج للتوصيل',
  'delivered' => 'تم التوصيل',
  _ => x,
};
