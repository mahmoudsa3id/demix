import 'dart:ui';

import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/core/widgets/app_cached_image.dart';
import 'package:demix/core/widgets/snack_bar/app_snack_bar.dart';
import 'package:demix/core/widgets/snack_bar/app_snack_bar_type.dart';
import 'package:demix/features/account/presentation/cubit/account_cubit.dart';
import 'package:demix/features/account/presentation/cubit/account_state.dart';
import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:demix/features/auth/presentation/cubit/auth_state.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              if (!context.mounted) return;

              context.go(RoutePaths.login);
              return;
            }

            if (state is AuthFailed) {
              AppSnackBar.build(
                message: state.failure.message,
                type: AppSnackBarType.error,
              );
            }
          },
        ),
        BlocListener<AccountCubit, AccountState>(
          listener: (context, state) {
            if (state is AccountDeleted) {
              if (!context.mounted) return;

              context.go(RoutePaths.login);
              return;
            }

            if (state is AccountFailure) {
              AppSnackBar.build(
                message: state.failure.message,
                type: AppSnackBarType.error,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FB),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is AuthInitial || authState is AuthLoading) {
              return const _ProfileLoading();
            }

            if (authState is GuestSession) {
              return const _GuestProfile();
            }

            if (authState is Unauthenticated) {
              return _LoggedOutProfile(
                onLogin: () {
                  context.go(RoutePaths.login);
                },
              );
            }

            if (authState is AuthFailed) {
              return _AuthErrorView(
                message: authState.failure.message,
                onRetry: () {
                  context.read<AuthCubit>().initialize();
                },
              );
            }

            if (authState is Authenticated) {
              return const _AuthenticatedProfile();
            }

            return const _ProfileLoading();
          },
        ),
      ),
    );
  }
}

// ============================================================================
// AUTHENTICATED
// ============================================================================

class _AuthenticatedProfile extends StatelessWidget {
  const _AuthenticatedProfile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        if (state is AccountInitial || state is AccountLoading) {
          return const _ProfileLoading();
        }

        if (state is AccountDeleting) {
          return const _DeleteLoading();
        }

        if (state is AccountFailure) {
          final user = state.previousUser;

          if (user == null) {
            return _AccountErrorView(
              onRetry: () {
                context.read<AccountCubit>().load();
              },
            );
          }

          return _ProfileBody(user: user, isUpdating: false);
        }

        if (state is AccountLoaded) {
          return _ProfileBody(user: state.user, isUpdating: false);
        }

        if (state is AccountUpdating) {
          return _ProfileBody(user: state.user, isUpdating: true);
        }

        return const _ProfileLoading();
      },
    );
  }
}

// ============================================================================
// PROFILE BODY
// ============================================================================

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user, required this.isUpdating});

  final dynamic user;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Stack(
      children: [
        const Positioned.fill(child: _ProfileBackground()),

        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              toolbarHeight: 72,
              title: const _TopBar(),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ProfileHero(user: user),

                  const SizedBox(height: 28),

                  _SectionHeader(
                    title: s.profile,
                    icon: Icons.person_outline_rounded,
                  ),

                  const SizedBox(height: 12),

                  _PremiumSection(
                    children: [
                      _PremiumTile(
                        icon: Icons.person_outline_rounded,
                        title: s.editProfile,
                        accentColor: AppColors.primary,
                        onTap: () {
                          context.push(RoutePaths.editProfile);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  _SectionHeader(
                    title: s.accountPreferences,
                    icon: Icons.tune_rounded,
                  ),

                  const SizedBox(height: 12),

                  _PremiumSection(
                    children: [
                      _PremiumTile(
                        icon: Icons.location_on_outlined,
                        title: s.myAddresses,
                        subtitle: s.manageYourAddresses,
                        accentColor: AppColors.secondary,
                        onTap: () {
                          context.push(RoutePaths.savedLocations);
                        },
                      ),
                      const _PremiumDivider(),
                      _PremiumTile(
                        icon: Icons.receipt_long_outlined,
                        title: s.orders,
                        subtitle: s.viewYourOrders,
                        accentColor: AppColors.primary,
                        onTap: () {
                          context.push(RoutePaths.orders);
                        },
                      ),
                      const _PremiumDivider(),
                      _PremiumTile(
                        icon: Icons.favorite_border_rounded,
                        title: s.favorites,
                        subtitle: s.savedItems,
                        accentColor: AppColors.secondary,
                        onTap: () {
                          context.push(RoutePaths.favorites);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  _SectionHeader(
                    title: s.settings,
                    icon: Icons.settings_outlined,
                  ),

                  const SizedBox(height: 12),

                  _PremiumSection(
                    children: [
                      _PremiumTile(
                        icon: Icons.settings_outlined,
                        title: s.settings,
                        subtitle: s.manageYourPreferences,
                        accentColor: AppColors.primary,
                        onTap: () {
                          context.push(RoutePaths.settings);
                        },
                      ),
                      const _PremiumDivider(),
                      _PremiumTile(
                        icon: Icons.language_rounded,
                        title: s.language,
                        accentColor: AppColors.secondary,
                        onTap: () {
                          context.push(RoutePaths.language);
                        },
                      ),
                      const _PremiumDivider(),
                      _PremiumTile(
                        icon: Icons.notifications_none_rounded,
                        title: s.notifications,
                        accentColor: AppColors.primary,
                        onTap: () {
                          context.push(RoutePaths.notifications);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  _SectionHeader(
                    title: s.helpAndSupport,
                    icon: Icons.support_agent_rounded,
                  ),

                  const SizedBox(height: 12),

                  _PremiumSection(
                    children: [
                      _PremiumTile(
                        icon: Icons.support_agent_rounded,
                        title: s.support,
                        subtitle: s.contactUs,
                        accentColor: AppColors.secondary,
                        onTap: () {
                          context.push(RoutePaths.support);
                        },
                      ),
                      const _PremiumDivider(),
                      _PremiumTile(
                        icon: Icons.privacy_tip_outlined,
                        title: s.privacy,
                        accentColor: AppColors.primary,
                        onTap: () {
                          context.push(RoutePaths.privacy);
                        },
                      ),
                      const _PremiumDivider(),
                      _PremiumTile(
                        icon: Icons.description_outlined,
                        title: s.terms,
                        accentColor: AppColors.secondary,
                        onTap: () {
                          context.push(RoutePaths.terms);
                        },
                      ),
                      const _PremiumDivider(),
                      _PremiumTile(
                        icon: Icons.info_outline_rounded,
                        title: s.about,
                        accentColor: AppColors.primary,
                        onTap: () {
                          context.push(RoutePaths.about);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  _SectionHeader(
                    title: s.accountActions,
                    icon: Icons.shield_outlined,
                  ),

                  const SizedBox(height: 12),

                  _DangerSection(
                    children: [
                      _DangerTile(
                        icon: Icons.logout_rounded,
                        title: s.logout,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                      const Divider(
                        height: 1,
                        indent: 74,
                        endIndent: 18,
                        color: Color(0xFFF0E6E6),
                      ),
                      _DangerTile(
                        icon: Icons.delete_outline_rounded,
                        title: s.deleteAccount,
                        onTap: () {
                          _showDeleteDialog(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const _BrandFooter(),
                ]),
              ),
            ),
          ],
        ),

        if (isUpdating)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x66FFFFFF),
              child: Center(child: _LoadingCard()),
            ),
          ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final s = S.of(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _PremiumDialog(
          icon: Icons.logout_rounded,
          iconColor: AppColors.primary,
          title: s.logout,
          message: s.logoutConfirmation,
          cancelText: s.cancel,
          confirmText: s.logout,
          onCancel: () {
            Navigator.of(dialogContext).pop();
          },
          onConfirm: () async {
            Navigator.of(dialogContext).pop();
            await context.read<AuthCubit>().signOut();
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final s = S.of(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _PremiumDialog(
          icon: Icons.delete_outline_rounded,
          iconColor: const Color(0xFFE5484D),
          title: s.deleteAccount,
          message: s.deleteAccountConfirmation,
          cancelText: s.cancel,
          confirmText: s.deleteAccount,
          danger: true,
          onCancel: () {
            Navigator.of(dialogContext).pop();
          },
          onConfirm: () {
            Navigator.of(dialogContext).pop();
            context.read<AccountCubit>().deleteAccount();
          },
        );
      },
    );
  }
}

// ============================================================================
// BACKGROUND
// ============================================================================

class _ProfileBackground extends StatelessWidget {
  const _ProfileBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FB),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.025),
                    Colors.white,
                    AppColors.secondary.withValues(alpha: 0.025),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -130,
            left: -110,
            child: _GlowBlob(size: 330, color: AppColors.primary),
          ),

          Positioned(
            top: 150,
            right: -130,
            child: _GlowBlob(size: 300, color: AppColors.secondary),
          ),

          Positioned(
            bottom: -140,
            left: 20,
            child: _GlowBlob(size: 320, color: AppColors.secondary),
          ),

          Positioned(
            top: 430,
            right: 30,
            child: _GlowBlob(
              size: 180,
              color: AppColors.primary,
              opacity: 0.045,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.size,
    required this.color,
    this.opacity = 0.085,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: opacity * 0.35),
            Colors.transparent,
          ],
          stops: const [0.0, 0.48, 1.0],
        ),
      ),
    );
  }
}

// ============================================================================
// TOP BAR
// ============================================================================

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Text(
      s.profile,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.7,
      ),
    );
  }
}

// ============================================================================
// PROFILE HERO
// ============================================================================

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final name = (user.displayName ?? '').trim();
    final email = (user.email ?? '').trim();
    final phone = (user.phone ?? '').trim();
    final photoUrl = (user.avatarUrl ?? '').trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.95),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.055),
                blurRadius: 35,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _Avatar(name: name, photoUrl: photoUrl),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name.isEmpty ? 'DeMiX User' : name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],

                        if (phone.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            phone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// AVATAR
// ============================================================================

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.photoUrl});

  final String name;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final firstLetter = name.isEmpty
        ? 'D'
        : name.characters.first.toUpperCase();

    return Container(
      width: 82,
      height: 82,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(3),
        child: ClipOval(
          child: photoUrl.isNotEmpty
              ? AppCachedImage(imageUrl: photoUrl, fit: BoxFit.cover)
              : _AvatarFallback(letter: firstLetter),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.secondary.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SECTION HEADER
// ============================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.10),
                AppColors.secondary.withValues(alpha: 0.10),
              ],
            ),
          ),
          child: Icon(icon, size: 16, color: AppColors.black),
        ),

        const SizedBox(width: 9),

        Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PREMIUM SECTION
// ============================================================================

class _PremiumSection extends StatelessWidget {
  const _PremiumSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.025),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ============================================================================
// PREMIUM TILE
// ============================================================================

class _PremiumTile extends StatelessWidget {
  const _PremiumTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: accentColor.withValues(alpha: 0.05),
        highlightColor: accentColor.withValues(alpha: 0.025),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: 0.10),
                      accentColor.withValues(alpha: 0.045),
                    ],
                  ),
                ),
                child: Icon(icon, size: 21, color: accentColor),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFF8F8FA),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: AppColors.textSecondary,
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
// DIVIDER
// ============================================================================

class _PremiumDivider extends StatelessWidget {
  const _PremiumDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 0.65,
      indent: 76,
      endIndent: 16,
      color: Color(0xFFF0F0F3),
    );
  }
}

// ============================================================================
// DANGER SECTION
// ============================================================================

class _DangerSection extends StatelessWidget {
  const _DangerSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFB),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFF4DEDE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.025),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ============================================================================
// DANGER TILE
// ============================================================================

class _DangerTile extends StatelessWidget {
  const _DangerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const dangerColor = Color(0xFFD92D20);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: dangerColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFFFF2F2),
                ),
                child: Icon(icon, color: dangerColor, size: 21),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: dangerColor,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFF2F2),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: dangerColor,
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
// BRAND FOOTER
// ============================================================================

class _BrandFooter extends StatelessWidget {
  const _BrandFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.16),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'D',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'DeMiX',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          'Food made simple.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Version 1.0',
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.55),
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PREMIUM DIALOG
// ============================================================================

class _PremiumDialog extends StatelessWidget {
  const _PremiumDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
    this.danger = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 35,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                gradient: LinearGradient(
                  colors: [
                    iconColor.withValues(alpha: 0.13),
                    iconColor.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(icon, color: iconColor, size: 27),
            ),

            const SizedBox(height: 17),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 9),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.55,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.black,
                        side: const BorderSide(color: Color(0xFFE8E8EC)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: onConfirm,
                      style: FilledButton.styleFrom(
                        backgroundColor: danger
                            ? const Color(0xFFD92D20)
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(fontWeight: FontWeight.w800),
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
}

// ============================================================================
// LOADING
// ============================================================================

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: _LoadingCard());
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 27,
          height: 27,
          child: CircularProgressIndicator(
            strokeWidth: 2.7,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DELETE LOADING
// ============================================================================

class _DeleteLoading extends StatelessWidget {
  const _DeleteLoading();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _LoadingCard(),
          const SizedBox(height: 18),
          Text(
            s.deleteAccount,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// GUEST
// ============================================================================

class _GuestProfile extends StatelessWidget {
  const _GuestProfile();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Stack(
      children: [
        const Positioned.fill(child: _ProfileBackground()),

        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 460),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.07),
                          blurRadius: 40,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person_outline_rounded,
                                size: 43,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          s.profile,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 9),

                        Text(
                          'Sign in to access your profile, orders and favorites.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.6,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.20,
                                  ),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: FilledButton(
                              onPressed: () {
                                context.go(RoutePaths.login);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                              child: Text(
                                s.loginSignIn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LOGGED OUT
// ============================================================================

class _LoggedOutProfile extends StatelessWidget {
  const _LoggedOutProfile({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _ProfileBackground()),

        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.87),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.10),
                          AppColors.secondary.withValues(alpha: 0.10),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 36,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'You are not signed in',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Sign in to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 23),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: onLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// AUTH ERROR
// ============================================================================

class _AuthErrorView extends StatelessWidget {
  const _AuthErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _CenteredError(message: message, onRetry: onRetry);
  }
}

// ============================================================================
// ACCOUNT ERROR
// ============================================================================

class _AccountErrorView extends StatelessWidget {
  const _AccountErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return _CenteredError(message: s.errorDescription, onRetry: onRetry);
  }
}

// ============================================================================
// CENTER ERROR
// ============================================================================

class _CenteredError extends StatelessWidget {
  const _CenteredError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Stack(
      children: [
        const Positioned.fill(child: _ProfileBackground()),

        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      color: const Color(0xFFFFF2F2),
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      size: 36,
                      color: Color(0xFFD92D20),
                    ),
                  ),

                  const SizedBox(height: 17),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 13,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 21),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: onRetry,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        s.retry,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
