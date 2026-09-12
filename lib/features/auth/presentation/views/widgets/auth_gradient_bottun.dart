import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const AuthGradientButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFF6500), Color(0xFFF32E3B), Color(0xFF8032E7)],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: child),
              const SizedBox(width: 17),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 31,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
