import 'package:demix/core/errors/firebase_message_solver.dart';
import 'package:demix/core/routing/navigation.dart';
import 'package:demix/core/routing/router_names.dart';
import 'package:demix/core/theme/app_text_styles.dart';

import 'package:demix/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:demix/features/auth/presentation/cubit/auth_state.dart';

import 'package:demix/features/auth/presentation/views/widgets/auth_background.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_footer.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_gradient_bottun.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_password_field.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_social_bottuns.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_text_field.dart';
import 'package:demix/features/auth/presentation/views/widgets/demix_logo.dart';

import 'package:demix/core/widgets/snack_bar/app_snack_bar_service.dart';
import 'package:demix/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    passwordController.addListener(_onPasswordChanged);
    confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  void _onPasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _loginWithGoogle() {
    FocusScope.of(context).unfocus();

    context.read<AuthCubit>().signInWithGoogle();
  }

  // ---------------------------------------------------------------------------
  // Facebook
  // ---------------------------------------------------------------------------

  void _loginWithFacebook() {
    FocusScope.of(context).unfocus();

    context.read<AuthCubit>().signInWithFacebook();
  }

  void _onConfirmPasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    passwordController.removeListener(_onPasswordChanged);
    confirmPasswordController.removeListener(_onConfirmPasswordChanged);

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  void _signup() {
    FocusScope.of(context).unfocus();

    if (!key.currentState!.validate()) {
      return;
    }

    key.currentState!.save();

    context.read<AuthCubit>().signUp(
      email: emailController.text.trim(),
      password: passwordController.text,
      displayName: nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          AppSnackBarService.instance.success(s.signupSuccess);

          popOrGo(context, fallback: RoutePaths.home);
        }

        if (state is AuthFailed) {
          final message = FailureMessageResolver.resolve(
            state.failure,
            Localizations.localeOf(context).languageCode,
          );

          AppSnackBarService.instance.error(message);
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

                    const DemixLogo(),

                    const SizedBox(height: 4),

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
                          TextSpan(text: '${s.signupCreate} '),
                          TextSpan(
                            text: s.signupAccount,
                            style: const TextStyle(color: Color(0xFFFF4C16)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      s.signupDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF66616A),
                      ),
                    ),

                    const SizedBox(height: 38),

                    AuthTextField(
                      controller: nameController,
                      hint: s.signupName,
                      icon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final value = v?.trim() ?? '';

                        if (value.isEmpty) {
                          return s.signupNameRequired;
                        }

                        if (value.length < 2) {
                          return s.signupNameInvalid;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    AuthTextField(
                      controller: emailController,
                      hint: s.loginEmailOrPhone,
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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

                    const SizedBox(height: 14),

                    AuthPasswordField(
                      controller: passwordController,
                      hint: s.loginPassword,
                      passwordRequiredText: s.loginPasswordRequired,
                      noSpacesText: s.loginPasswordNoSpaces,
                      minLengthText: s.loginPasswordMinLength,
                      uppercaseText: s.loginPasswordUppercase,
                      lowercaseText: s.loginPasswordLowercase,
                      numberText: s.loginPasswordNumber,
                      specialText: s.loginPasswordSpecial,
                      commonPasswordText: s.loginPasswordCommon,
                      obscureText: obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    AuthTextField(
                      controller: confirmPasswordController,
                      hint: s.signupConfirmPassword,
                      icon: Icons.lock_reset_outlined,
                      obscureText: obscureConfirmPassword,
                      suffixIcon: IconButton(
                        splashRadius: 22,
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF8A878D),
                          size: 24,
                        ),
                      ),
                      validator: (v) {
                        final value = v ?? '';

                        if (value.isEmpty) {
                          return s.signupConfirmPasswordRequired;
                        }

                        if (value != passwordController.text) {
                          return s.signupPasswordsDoNotMatch;
                        }

                        return null;
                      },
                    ),

                    _passwordMatch(s),

                    const SizedBox(height: 27),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return AuthGradientButton(
                          onTap: isLoading ? null : _signup,
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Text(
                                  s.signupCreateAccount,
                                  style: AppTextStyles.cairoBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    _orContinue(s),

                    const SizedBox(height: 20),

                    AuthSocialButtons(
                      onGoogleTap: _loginWithGoogle,
                      onFacebookTap: _loginWithFacebook,
                    ),
                    const SizedBox(height: 29),

                    _loginLink(s),

                    const SizedBox(height: 31),

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

  Widget _passwordMatch(S s) {
    if (confirmPasswordController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final matches = confirmPasswordController.text == passwordController.text;

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 6),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: matches
                  ? const Color(0xFF35B96F)
                  : const Color(0xFFE53935),
            ),
            child: Icon(
              matches ? Icons.check : Icons.close,
              color: Colors.white,
              size: 12,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              matches ? s.signupPasswordsMatch : s.signupPasswordsDoNotMatch,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: matches
                    ? const Color(0xFF35B96F)
                    : const Color(0xFFE53935),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orContinue(S s) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFE4E1DF))),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            s.loginOrContinueWith,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF67636A),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        Expanded(child: Container(height: 1, color: const Color(0xFFE4E1DF))),
      ],
    );
  }

  Widget _loginLink(S s) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 17,
          color: Color(0xFF555158),
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: '${s.signupAlreadyHaveAccount} '),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {
                popOrGo(context, fallback: RoutePaths.login);
              },
              child: Text(
                s.signupLogin,
                style: const TextStyle(
                  color: Color(0xFF7737C5),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
