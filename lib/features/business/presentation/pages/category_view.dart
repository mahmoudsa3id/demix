import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:demix/features/business/presentation/cubit/business_cubit.dart';
import 'package:demix/features/business/presentation/cubit/business_state.dart';
import 'package:demix/features/business/presentation/widgets/business_card.dart';
import 'package:demix/main.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key, required this.type});
  final String type;

  bool get isCafe => type.toLowerCase() == 'cafe';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = isCafe ? 'الكافيهات' : 'المطاعم';
    final icon = isCafe ? Icons.local_cafe_rounded : Icons.restaurant_rounded;

    return BlocProvider(
      create: (_) => getIt<BusinessCubit>()..load(type),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                  child: Row(
                    children: [
                      _RoundButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => context.pop(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'اختار مكانك المفضل واطلب في دقائق',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    height: 52,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ابحث عن ${isCafe ? 'كافيه' : 'مطعم'}...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<BusinessCubit, BusinessState>(
                builder: (context, state) {
                  if (state is BusinessLoading || state is BusinessInitial) {
                    return const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      sliver: SliverToBoxAdapter(child: _LoadingList()),
                    );
                  }
                  if (state is BusinessFailure) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: _StateView(
                        message: state.message,
                        onRetry: () => context.read<BusinessCubit>().load(type),
                      ),
                    );
                  }
                  if (state is BusinessLoaded && state.businesses.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _StateView(message: 'مفيش أماكن متاحة حاليًا'),
                    );
                  }
                  final businesses = state is BusinessLoaded
                      ? state.businesses
                      : const [];
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                    sliver: SliverList.separated(
                      itemCount: businesses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (_, index) =>
                          BusinessCard(business: businesses[index]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(width: 46, height: 46, child: Icon(icon)),
    ),
  );
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      3,
      (_) => Container(
        height: 220,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
  );
}

class _StateView extends StatelessWidget {
  const _StateView({required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 54,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('حاول مرة أخرى')),
        ],
      ),
    ),
  );
}
