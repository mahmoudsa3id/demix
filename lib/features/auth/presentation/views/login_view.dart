import 'package:demix/core/routing/navigation.dart';
import 'package:demix/core/routing/router_names.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    passwordController.removeListener(_onPasswordChanged);

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();

    if (!key.currentState!.validate()) {
      return;
    }

    key.currentState!.save();

    popOrGo(context, fallback: RoutePaths.home);

    AppSnackBarService.instance.success('Login successful');
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
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
                        TextSpan(text: '${s.loginWelcome} '),
                        TextSpan(
                          text: s.loginBack,
                          style: const TextStyle(color: Color(0xFFFF4C16)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    s.loginDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF66616A),
                    ),
                  ),

                  const SizedBox(height: 38),

                  AuthTextField(
                    controller: emailController,
                    hint: s.loginEmailOrPhone,
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
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

                  const SizedBox(height: 13),

                  GestureDetector(
                    onTap: () {
                      popOrGo(context, fallback: RoutePaths.forgotPassword);
                    },
                    child: Text(
                      s.loginForgotPassword,
                      style: const TextStyle(
                        color: Color(0xFF8037C8),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 27),

                  AuthGradientButton(text: s.loginSignIn, onTap: _login),

                  const SizedBox(height: 28),

                  _orContinue(s),

                  const SizedBox(height: 20),

                  const AuthSocialButtons(),

                  const SizedBox(height: 29),

                  _createAccount(s),

                  const SizedBox(height: 31),

                  const AuthFooter(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
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

  Widget _createAccount(S s) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 17,
          color: Color(0xFF555158),
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: '${s.loginNoAccount} '),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {
                popOrGo(context, fallback: RoutePaths.signup);
              },
              child: Text(
                s.loginCreateAccount,
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
