import 'package:demix/features/orders/presentation/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutBottomBar extends StatelessWidget {
  const CheckoutBottomBar({
    super.key,
    required this.total,
    required this.addressSelected,
    required this.onPressed,
  });

  final double total;
  final bool addressSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, -6),
              color: Colors.black.withOpacity(.08),
            ),
          ],
        ),
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            final isLoading = state is OrderSubmitting;

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الإجمالي',
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${total.toStringAsFixed(0)} ج',
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading || !addressSelected ? null : onPressed,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'تأكيد الطلب',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
