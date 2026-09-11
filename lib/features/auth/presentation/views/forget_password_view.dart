import 'package:demix/core/routing/navigation.dart';
import 'package:demix/core/routing/router_names.dart';
import 'package:demix/core/widgets/snack_bar/app_snack_bar_service.dart';

import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:demix/features/auth/presentation/cubit/auth_state.dart';

import 'package:demix/features/auth/presentation/views/widgets/auth_background.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_footer.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_gradient_bottun.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_text_field.dart';
import 'package:demix/features/auth/presentation/views/widgets/demix_logo.dart';

import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    FocusScope.of(context).unfocus();

    if (!key.currentState!.validate()) {
      return;
    }

    key.currentState!.save();

    context.read<AuthCubit>().sendPasswordResetEmail(
      email: emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSent) {
          AppSnackBarService.instance.success(s.forgotPasswordSuccess);

          popOrGo(context, fallback: RoutePaths.login);
        }

        if (state is AuthFailed) {
          AppSnackBarService.instance.error(state.failure.message);
        }
      },
      child: Scaffold(
        body: Form(
          key: key,
          child: AuthBackground(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 44),

                    // =====================================================
                    // NEED HELP
                    // =====================================================
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        s.loginNeedHelp,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17141B),
                        ),
                      ),
                    ),

                    const SizedBox(height: 37),

                    // =====================================================
                    // LOGO
                    // =====================================================
                    const DemixLogo(),

                    const SizedBox(height: 4),

                    // =====================================================
                    // TAGLINE
                    // =====================================================
                    Text(
                      s.loginTagline,
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 2.8,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF77737A),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // =====================================================
                    // TITLE
                    // =====================================================
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 43,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          letterSpacing: -1.8,
                          color: Color(0xFF111018),
                        ),
                        children: [
                          TextSpan(text: '${s.forgotPasswordTitle} '),
                          TextSpan(
                            text: s.forgotPasswordHighlight,
                            style: const TextStyle(color: Color(0xFFFF4C16)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // =====================================================
                    // DESCRIPTION
                    // =====================================================
                    Text(
                      s.forgotPasswordDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF66616A),
                      ),
                    ),

                    const SizedBox(height: 38),

                    // =====================================================
                    // EMAIL
                    // =====================================================
                    AuthTextField(
                      controller: emailController,
                      hint: s.loginEmailOrPhone,
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        final value = v?.trim() ?? '';

                        if (value.isEmpty) {
                          return s.loginEmailRequired;
                        }

                        final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

                        if (!emailRegex.hasMatch(value)) {
                          return s.loginInvalidEmail;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 27),

                    // =====================================================
                    // SEND RESET LINK
                    // =====================================================
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return AuthGradientButton(
                          text: isLoading ? 'Sending...' : s.forgotPasswordSend,
                          onTap: isLoading ? null : _sendResetLink,
                        );
                      },
                    ),

                    const SizedBox(height: 29),

                    // =====================================================
                    // BACK TO LOGIN
                    // =====================================================
                    GestureDetector(
                      onTap: () {
                        popOrGo(context, fallback: RoutePaths.login);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF7737C5),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            s.forgotPasswordBackToLogin,
                            style: const TextStyle(
                              color: Color(0xFF7737C5),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 31),

                    // =====================================================
                    // FOOTER
                    // =====================================================
                    const AuthFooter(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
