import 'package:flutter/material.dart';

class AuthPasswordRequirements extends StatelessWidget {
  final String password;

  final String minLengthText;
  final String uppercaseText;
  final String lowercaseText;
  final String numberText;
  final String specialText;

  const AuthPasswordRequirements({
    super.key,
    required this.password,
    required this.minLengthText,
    required this.uppercaseText,
    required this.lowercaseText,
    required this.numberText,
    required this.specialText,
  });

  bool get hasMinLength => password.length >= 8;

  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(password);

  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(password);

  bool get hasNumber => RegExp(r'[0-9]').hasMatch(password);

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Rule(text: minLengthText, valid: hasMinLength),
          _Rule(text: uppercaseText, valid: hasUppercase),
          _Rule(text: lowercaseText, valid: hasLowercase),
          _Rule(text: numberText, valid: hasNumber),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  final String text;
  final bool valid;

  const _Rule({required this.text, required this.valid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: valid ? const Color(0xFF35B96F) : Colors.transparent,
              border: valid
                  ? null
                  : Border.all(color: const Color(0xFF17131B), width: 1.4),
            ),
            child: valid
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valid
                    ? const Color(0xFF35B96F)
                    : const Color(0xFF17131B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
