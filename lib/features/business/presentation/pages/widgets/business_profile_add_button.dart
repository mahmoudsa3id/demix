import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusinessProfileAddButton extends StatefulWidget {
  const BusinessProfileAddButton({
    super.key,
    required this.product,
    required this.business,
  });

  final Product product;
  final Business business;

  @override
  State<BusinessProfileAddButton> createState() =>
      _BusinessProfileAddButtonState();
}

class _BusinessProfileAddButtonState extends State<BusinessProfileAddButton> {
  bool pressed = false;

  void _animate() {
    setState(() {
      pressed = true;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) {
        return;
      }

      setState(() {
        pressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animate();
      },
      onTap: () {
        context.read<CartCubit>().addItem(
          product: widget.product,
          business: widget.business,
        );
      },
      child: AnimatedScale(
        scale: pressed ? .88 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
