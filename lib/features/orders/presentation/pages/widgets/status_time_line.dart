import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderStatusUi {
  static const statuses = [
    'pending',
    'accepted',
    'preparing',
    'outForDelivery',
    'delivered',
  ];

  static String label(String status) {
    return switch (status) {
      'pending' => 'تم استلام الطلب',
      'accepted' => 'المطعم قبل الطلب',
      'preparing' => 'جاري التحضير',
      'outForDelivery' => 'خرج للتوصيل',
      'delivered' => 'تم التوصيل',
      'cancelled' => 'تم إلغاء الطلب',
      _ => status,
    };
  }

  static Color color(String status) {
    return switch (status) {
      'pending' => AppColors.secondary,
      'accepted' => AppColors.primary,
      'preparing' => AppColors.primary,
      'outForDelivery' => AppColors.secondary,
      'delivered' => const Color(0xFF16A34A),
      'cancelled' => const Color(0xFFD92D20),
      _ => AppColors.textSecondary,
    };
  }

  static IconData icon(String status) {
    return switch (status) {
      'pending' => Icons.schedule_rounded,
      'accepted' => Icons.check_circle_outline_rounded,
      'preparing' => Icons.restaurant_rounded,
      'outForDelivery' => Icons.delivery_dining_rounded,
      'delivered' => Icons.done_all_rounded,
      'cancelled' => Icons.close_rounded,
      _ => Icons.info_outline_rounded,
    };
  }
}

// ============================================================================
// BADGE
// ============================================================================

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = OrderStatusUi.color(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(OrderStatusUi.icon(status), size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            OrderStatusUi.label(status),
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TIMELINE
// ============================================================================

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    if (status == 'cancelled') {
      return _CancelledState();
    }

    final currentIndex = OrderStatusUi.statuses.indexOf(status);

    return Column(
      children: List.generate(OrderStatusUi.statuses.length, (index) {
        final itemStatus = OrderStatusUi.statuses[index];

        final completed = currentIndex >= index;
        final current = currentIndex == index;
        final isLast = index == OrderStatusUi.statuses.length - 1;

        return _TimelineItem(
          status: itemStatus,
          completed: completed,
          current: current,
          isLast: isLast,
          index: index,
        );
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.status,
    required this.completed,
    required this.current,
    required this.isLast,
    required this.index,
  });

  final String status;
  final bool completed;
  final bool current;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = OrderStatusUi.color(status);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 420 + (index * 80)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, progress, child) {
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(8 * (1 - progress), 0),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    width: current ? 27 : 22,
                    height: current ? 27 : 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: completed
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [color, color.withValues(alpha: 0.72)],
                            )
                          : null,
                      color: completed ? null : const Color(0xFFF3F3F5),
                      border: Border.all(
                        color: completed ? color : const Color(0xFFE2E2E7),
                        width: 1.5,
                      ),
                      boxShadow: current
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.22),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: completed
                        ? Icon(
                            current
                                ? OrderStatusUi.icon(status)
                                : Icons.check_rounded,
                            size: current ? 13 : 12,
                            color: Colors.white,
                          )
                        : null,
                  ),

                  if (!isLast)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      width: 2,
                      height: 32,
                      color: completed
                          ? color.withValues(alpha: 0.65)
                          : const Color(0xFFE5E5EA),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            OrderStatusUi.label(status),
                            style: TextStyle(
                              color: completed
                                  ? AppColors.black
                                  : AppColors.textSecondary,
                              fontSize: 12.5,
                              fontWeight: current
                                  ? FontWeight.w900
                                  : completed
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),

                        if (current)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'الآن',
                              style: TextStyle(
                                color: color,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                      ],
                    ),

                    if (current) ...[
                      const SizedBox(height: 4),
                      Text(
                        _description(status),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _description(String status) {
  return switch (status) {
    'pending' => 'طلبك وصل وجاري مراجعته.',
    'accepted' => 'المطعم أكد الطلب وبدأ تجهيز الخطوات القادمة.',
    'preparing' => 'طلبك بيتجهز حاليًا بعناية.',
    'outForDelivery' => 'الكابتن استلم الطلب وهو في طريقه ليك.',
    'delivered' => 'تم توصيل طلبك بنجاح.',
    _ => '',
  };
}

// ============================================================================
// CANCELLED
// ============================================================================

class _CancelledState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFD92D20);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.close_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'تم إلغاء الطلب.',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
