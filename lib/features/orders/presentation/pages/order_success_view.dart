import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/widgets/app_background_page.dart';
import 'package:demix/features/orders/presentation/pages/widgets/success_card.dart';
import 'package:demix/features/orders/presentation/pages/widgets/success_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessView extends StatefulWidget {
  const OrderSuccessView({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  final String orderId;
  final String orderNumber;

  @override
  State<OrderSuccessView> createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    buildAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: AppPageBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: _scale.value,
                        child: SuccessIcon(),
                      ),

                      const SizedBox(height: 28),

                      FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: SuccessCard(
                            orderNumber: widget.orderNumber,
                            onTrack: () {
                              context.go(
                                '${RoutePaths.orderDetails}/${widget.orderId}',
                              );
                            },
                            onHome: () {
                              context.go(RoutePaths.home);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void buildAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 1, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.18, 1, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }
}
