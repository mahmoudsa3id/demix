import 'package:demix/features/business/presentation/pages/widgets/business_profile_skeleton_product.dart';
import 'package:flutter/material.dart';

class BusinessProfileSkeleton extends StatefulWidget {
  const BusinessProfileSkeleton({super.key});

  @override
  State<BusinessProfileSkeleton> createState() =>
      _BusinessProfileSkeletonState();
}

class _BusinessProfileSkeletonState extends State<BusinessProfileSkeleton>
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
      builder: (context, _) {
        final value = Curves.easeInOut.transform(_controller.value);

        final skeletonColor = Color.lerp(
          const Color(0xFFE8E8ED),
          Colors.white,
          value,
        )!;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ===============================================================
            // HERO
            // ===============================================================
            SliverToBoxAdapter(
              child: Container(
                height: 360,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(42),
                    bottomRight: Radius.circular(42),
                  ),
                ),
              ),
            ),

            // ===============================================================
            // INTRO
            // ===============================================================
            const SliverToBoxAdapter(child: SizedBox(height: 18)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 9,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Container(
                            width: 170,
                            height: 11,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 55,
                      height: 35,
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===============================================================
            // CATEGORY NAV
            // ===============================================================
            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 91,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 28,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Container(width: 1, height: 45, color: skeletonColor),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          separatorBuilder: (_, __) {
                            return const SizedBox(width: 22);
                          },
                          itemBuilder: (_, index) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: index == 0 ? 52 : 76,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: skeletonColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===============================================================
            // TITLE
            // ===============================================================
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: 115,
                  height: 25,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),

            // ===============================================================
            // PRODUCTS
            // ===============================================================
            const SliverToBoxAdapter(child: SizedBox(height: 13)),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
              sliver: SliverList.separated(
                itemCount: 6,
                separatorBuilder: (_, __) {
                  return const SizedBox(height: 7);
                },
                itemBuilder: (_, __) {
                  return BusinessProfileSkeletonProduct(color: skeletonColor);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
