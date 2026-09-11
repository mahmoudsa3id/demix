import 'package:demix/features/auth/presentation/views/widgets/auth_password_requirements.dart';
import 'package:demix/features/auth/presentation/views/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  final String passwordRequiredText;
  final String noSpacesText;
  final String minLengthText;
  final String uppercaseText;
  final String lowercaseText;
  final String numberText;
  final String specialText;
  final String commonPasswordText;

  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.hint,
    required this.passwordRequiredText,
    required this.noSpacesText,
    required this.minLengthText,
    required this.uppercaseText,
    required this.lowercaseText,
    required this.numberText,
    required this.specialText,
    required this.commonPasswordText,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  bool get hasMinLength => controller.text.length >= 8;

  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(controller.text);

  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(controller.text);

  bool get hasNumber => RegExp(r'[0-9]').hasMatch(controller.text);

  bool get hasSpecial => RegExp(
    r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/~`]',
  ).hasMatch(controller.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthTextField(
          controller: controller,
          hint: hint,
          icon: Icons.lock_outline_rounded,
          obscureText: obscureText,
          suffixIcon: IconButton(
            splashRadius: 22,
            onPressed: onToggleVisibility,
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF8A878D),
              size: 24,
            ),
          ),
          validator: (v) {
            final password = v ?? '';

            if (password.isEmpty) {
              return passwordRequiredText;
            }

            if (password.contains(' ')) {
              return noSpacesText;
            }

            if (!hasMinLength) {
              return minLengthText;
            }

            if (!hasUppercase) {
              return uppercaseText;
            }

            if (!hasLowercase) {
              return lowercaseText;
            }

            if (!hasNumber) {
              return numberText;
            }

            if (!hasSpecial) {
              return specialText;
            }

            const commonPasswords = {
              'password',
              'password123',
              '12345678',
              '123456789',
              '1234567890',
              'qwerty123',
              'qwertyui',
              'admin123',
              'welcome123',
              'letmein123',
              'iloveyou',
            };

            if (commonPasswords.contains(password.toLowerCase())) {
              return commonPasswordText;
            }

            return null;
          },
        ),

        AuthPasswordRequirements(
          password: controller.text,
          minLengthText: minLengthText,
          uppercaseText: uppercaseText,
          lowercaseText: lowercaseText,
          numberText: numberText,
          specialText: specialText,
        ),
      ],
    );
  }
}
