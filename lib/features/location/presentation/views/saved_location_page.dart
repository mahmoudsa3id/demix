import 'package:demix/core/di/injection.dart';
import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_background_page.dart';

import 'package:demix/features/location/domain/entities/location_entity.dart';
import 'package:demix/features/location/presentation/cubit/saved_location_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SavedLocationsPage extends StatelessWidget {
  const SavedLocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SavedLocationCubit>(
      create: (_) => getIt<SavedLocationCubit>()..load(),
      child: const _SavedLocationsView(),
    );
  }
}

class _SavedLocationsView extends StatelessWidget {
  const _SavedLocationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,

        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10),
          child: _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.pop(),
          ),
        ),

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved Locations',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                letterSpacing: -.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'عناوينك المحفوظة',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

      body: AppPageBackground(
        child: BlocConsumer<SavedLocationCubit, SavedLocationState>(
          listener: (context, state) {
            if (state is SavedLocationFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFFD92D20),
                    content: Text(
                      state.message,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                );
            }
          },

          builder: (context, state) {
            // ==========================================================
            // LOADING
            // ==========================================================

            if (state is SavedLocationInitial ||
                state is SavedLocationLoading) {
              return const _LoadingView();
            }

            // ==========================================================
            // ERROR
            // ==========================================================

            if (state is SavedLocationFailure) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<SavedLocationCubit>().load();
                },
              );
            }

            // ==========================================================
            // LOADED
            // ==========================================================

            if (state is SavedLocationLoaded) {
              final location = state.location;

              if (location == null) {
                return const _EmptyView();
              }

              return _SavedLocationContent(location: location);
            }

            return const SizedBox.shrink();
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RoutePaths.location);
        },

        elevation: 5,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

        icon: const Icon(Icons.add_location_alt_rounded, size: 19),

        label: const Text(
          'إضافة عنوان',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

// ============================================================================
// CONTENT
// ============================================================================

class _SavedLocationContent extends StatelessWidget {
  const _SavedLocationContent({required this.location});

  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),

      children: [
        const Padding(
          padding: EdgeInsetsDirectional.only(start: 4, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'عناوين التوصيل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.4,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'اختار أو عدّل العنوان اللي هتستخدمه في طلباتك',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        _LocationCard(location: location),
      ],
    );
  }
}

// ============================================================================
// LOCATION CARD
// ============================================================================

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.location});

  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    final address = _getAddress(location);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(17),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==========================================================
            // HEADER
            // ==========================================================
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .18),
                    ),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'العنوان المحفوظ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Saved delivery location',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'محفوظ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ==========================================================
            // ADDRESS
            // ==========================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .11),
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: Colors.white.withValues(alpha: .12)),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    width: 35,
                    height: 35,

                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.place_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'العنوان',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          address,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            height: 1.6,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ==========================================================
            // SERVICE ZONE
            // ==========================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  Container(
                    width: 31,
                    height: 31,

                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .11),
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      location.isInsideZone
                          ? Icons.local_shipping_outlined
                          : Icons.location_off_outlined,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      location.isInsideZone
                          ? 'العنوان داخل منطقة التوصيل'
                          : 'العنوان خارج منطقة التوصيل',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  Icon(
                    location.isInsideZone
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ==========================================================
            // ACTIONS
            // ==========================================================
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push(RoutePaths.location);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      icon: const Icon(
                        Icons.edit_location_alt_rounded,
                        size: 18,
                      ),

                      label: const Text(
                        'تعديل العنوان',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                Material(
                  color: Colors.white.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(15),

                  child: InkWell(
                    onTap: () {
                      _showDeleteDialog(context);
                    },

                    borderRadius: BorderRadius.circular(15),

                    child: const SizedBox(
                      width: 48,
                      height: 48,

                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getAddress(LocationEntity location) {
    return location.formattedAddress ?? 'العنوان المحفوظ';
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFD92D20),
                size: 23,
              ),
              SizedBox(width: 9),
              Text(
                'حذف العنوان',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),

          content: const Text(
            'هل أنت متأكد إنك عاوز تحذف العنوان المحفوظ؟\n'
            'العنوان هيتحذف من الجهاز ومن حسابك.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },

              child: const Text(
                'إلغاء',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),

            FilledButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await context.read<SavedLocationCubit>().delete();
              },

              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD92D20),
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              child: const Text(
                'حذف العنوان',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// EMPTY
// ============================================================================

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 94,
              height: 94,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: .08),
                    AppColors.secondary.withValues(alpha: .10),
                  ],
                ),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.location_off_rounded,
                color: AppColors.primary,
                size: 42,
              ),
            ),

            const SizedBox(height: 21),

            const Text(
              'مفيش عناوين محفوظة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 8),

            const Text(
              'أضف عنوان التوصيل بتاعك علشان تقدر تستخدمه '
              'بسرعة في طلباتك الجاية.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                height: 1.65,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(RoutePaths.location);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  padding: const EdgeInsets.symmetric(horizontal: 21),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                icon: const Icon(Icons.add_location_alt_rounded, size: 19),

                label: const Text(
                  'إضافة عنوان',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LOADING
// ============================================================================

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),

      physics: const NeverScrollableScrollPhysics(),

      children: [
        Container(
          height: 345,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          height: 70,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ERROR
// ============================================================================

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(23),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .04),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 70,
                height: 70,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F2),
                  borderRadius: BorderRadius.circular(21),
                ),

                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFD92D20),
                  size: 34,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'حصلت مشكلة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.55,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 19),

              SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                  onPressed: onRetry,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CIRCLE BUTTON
// ============================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .92),
      shape: const CircleBorder(),

      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),

        child: const SizedBox(
          width: 42,
          height: 42,

          child: Icon(
            Icons.arrow_back_rounded,
            size: 19,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
