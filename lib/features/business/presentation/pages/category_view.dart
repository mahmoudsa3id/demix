import 'package:demix/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/auth_di.dart';
import '../../../../core/routing/navigation.dart';
import '../../../../core/routing/router_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../cubit/business_cubit.dart';
import '../cubit/business_state.dart';
import '../widgets/business_wide_card.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key, required this.type});

  final String type;

  String _title(BuildContext context) {
    final s = S.of(context);

    switch (type) {
      case 'restaurant':
        return s.restaurants;
      case 'cafe':
        return s.cafes;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final normalizedType = type.trim().toLowerCase();

    return BlocProvider(
      create: (_) => getIt<BusinessCubit>()..load(normalizedType),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              popOrGo(context, fallback: RoutePaths.home);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text(
            _title(context),
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: BlocBuilder<BusinessCubit, BusinessState>(
          builder: (context, state) {
            if (state is BusinessInitial || state is BusinessLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is BusinessFailure) {
              return _ErrorView(
                message: state.failure.message,
                onRetry: context.read<BusinessCubit>().retry,
              );
            }

            if (state is BusinessEmpty) {
              return _EmptyView(title: _title(context));
            }

            if (state is! BusinessLoaded) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  context.read<BusinessCubit>().load(normalizedType),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.businesses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return BusinessWideCard(business: state.businesses[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront_outlined,
                color: AppColors.primary,
                size: 38,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isArabic ? 'لا توجد بيانات حاليًا' : 'No businesses yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'لم تتم إضافة $title بعد.'
                  : 'No $title have been added yet.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 52,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
