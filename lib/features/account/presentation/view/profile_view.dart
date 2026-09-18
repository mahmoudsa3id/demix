import 'package:demix/core/routing/route_paths.dart';
import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/account/presentation/cubit/account_cubit.dart';
import 'package:demix/features/account/presentation/cubit/account_state.dart';
import 'package:demix/features/account/presentation/view/widgets/account_header.dart';
import 'package:demix/features/account/presentation/view/widgets/account_section.dart';
import 'package:demix/features/account/presentation/view/widgets/account_tile.dart';
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
    final s = S.of(context);

    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is AccountDeleted) {
          context.go(RoutePaths.login);
        }

        if (state is AccountFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            s.profile,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is GuestSession) {
              return const _GuestProfile();
            }

            if (authState is! Authenticated) {
              return const SizedBox.shrink();
            }

            return BlocBuilder<AccountCubit, AccountState>(
              builder: (context, state) {
                if (state is AccountInitial || state is AccountLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AccountFailure && state.previousUser == null) {
                  return _ErrorState(
                    onRetry: () {
                      context.read<AccountCubit>().load();
                    },
                  );
                }

                final user = switch (state) {
                  AccountLoaded() => state.user,
                  AccountUpdating() => state.user,
                  AccountFailure() => state.previousUser!,
                  _ => null,
                };

                if (user == null) {
                  return const SizedBox.shrink();
                }

                return SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    children: [
                      AccountHeader(
                        name: user.displayName ?? '',
                        email: user.email ?? '',
                        phone: user.phone,
                        photoUrl: user.avatarUrl,
                      ),

                      const SizedBox(height: 24),

                      AccountSection(
                        title: s.profile,
                        children: [
                          AccountTile(
                            icon: Icons.person_outline_rounded,
                            title: s.editProfile,
                            onTap: () {
                              context.push(RoutePaths.editProfile);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      AccountSection(
                        title: s.accountPreferences,
                        children: [
                          AccountTile(
                            icon: Icons.location_on_outlined,
                            title: s.myAddresses,
                            subtitle: s.manageYourAddresses,
                            onTap: () {
                              context.push(RoutePaths.addresses);
                            },
                          ),
                          const Divider(height: 1),
                          AccountTile(
                            icon: Icons.receipt_long_outlined,
                            title: s.orders,
                            subtitle: s.viewYourOrders,
                            onTap: () {
                              context.push(RoutePaths.orders);
                            },
                          ),
                          const Divider(height: 1),
                          AccountTile(
                            icon: Icons.favorite_border_rounded,
                            title: s.favorites,
                            subtitle: s.savedItems,
                            onTap: () {
                              context.push(RoutePaths.favorites);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      AccountSection(
                        title: s.settings,
                        children: [
                          AccountTile(
                            icon: Icons.settings_outlined,
                            title: s.settings,
                            subtitle: s.manageYourPreferences,
                            onTap: () {
                              context.push(RoutePaths.settings);
                            },
                          ),
                          const Divider(height: 1),
                          AccountTile(
                            icon: Icons.language_rounded,
                            title: s.language,
                            onTap: () {
                              context.push(RoutePaths.language);
                            },
                          ),
                          const Divider(height: 1),
                          AccountTile(
                            icon: Icons.notifications_none_rounded,
                            title: s.notifications,
                            onTap: () {
                              context.push(RoutePaths.notifications);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      AccountSection(
                        title: s.helpAndSupport,
                        children: [
                          AccountTile(
                            icon: Icons.support_agent_rounded,
                            title: s.support,
                            subtitle: s.contactUs,
                            onTap: () {
                              context.push(RoutePaths.support);
                            },
                          ),
                          const Divider(height: 1),
                          AccountTile(
                            icon: Icons.privacy_tip_outlined,
                            title: s.privacy,
                            onTap: () {
                              context.push(RoutePaths.privacy);
                            },
                          ),
                          const Divider(height: 1),
                          AccountTile(
                            icon: Icons.description_outlined,
                            title: s.terms,
                            onTap: () {
                              context.push(RoutePaths.terms);
                            },
                          ),
                          const Divider(height: 1),
                          AccountTile(
                            icon: Icons.info_outline_rounded,
                            title: s.about,
                            onTap: () {
                              context.push(RoutePaths.about);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      AccountSection(
                        title: s.accountActions,
                        children: [
                          AccountTile(
                            icon: Icons.logout_rounded,
                            title: s.logout,
                            danger: true,
                            onTap: () {
                              _showLogoutDialog(context);
                            },
                          ),
                          const Divider(height: 1),
                          AccountTile(
                            icon: Icons.delete_outline_rounded,
                            title: s.deleteAccount,
                            danger: true,
                            onTap: () {
                              _showDeleteDialog(context);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Center(
                        child: Text(
                          'DeMiX',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final s = S.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(s.logout),
          content: Text(s.logoutConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(s.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<AuthCubit>().signOut();
                context.go(RoutePaths.login);
              },
              child: Text(s.logout, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final s = S.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(s.deleteAccount),
          content: Text(s.deleteAccountConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(s.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<AccountCubit>().deleteAccount();
              },
              child: Text(
                s.deleteAccount,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GuestProfile extends StatelessWidget {
  const _GuestProfile();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 70,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 20),
            Text(
              s.profile,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  context.go(RoutePaths.login);
                },
                child: Text(s.loginSignIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 55, color: Colors.red),
            const SizedBox(height: 15),
            Text(s.errorDescription, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onRetry, child: Text(s.retry)),
          ],
        ),
      ),
    );
  }
}
