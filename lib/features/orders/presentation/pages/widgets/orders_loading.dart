import 'package:flutter/material.dart';

class OrdersLoading extends StatelessWidget {
  const OrdersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2.4));
  }
}
