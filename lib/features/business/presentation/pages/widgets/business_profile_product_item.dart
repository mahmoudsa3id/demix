import 'package:demix/features/business/domain/entities/business.dart';
import 'package:demix/features/business/domain/entities/product.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_profile_product_content.dart';
import 'package:flutter/material.dart';

class BusinessProfileProductItem extends StatefulWidget {
  const BusinessProfileProductItem({
    super.key,
    required this.product,
    required this.business,
    required this.index,
  });

  final Product product;
  final Business business;
  final int index;

  @override
  State<BusinessProfileProductItem> createState() =>
      _BusinessProfileProductItemState();
}

class _BusinessProfileProductItemState extends State<BusinessProfileProductItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 420 + (widget.index * 35)),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _controller.forward();
    });
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
      builder: (context, child) {
        final value = Curves.easeOutCubic.transform(_controller.value);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: BusinessProfileProductContent(
        product: widget.product,
        business: widget.business,
        index: widget.index,
      ),
    );
  }
}
