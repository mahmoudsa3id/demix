import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDFC),
        borderRadius: BorderRadius.circular(23),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontSize: 17, color: Color(0xFF252129)),
        cursorColor: Color(0xFF7B38C8),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFFFDFC),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: const BorderSide(color: Color(0xFFE6E1DE), width: 1.3),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: const BorderSide(color: Color(0xFFE6E1DE), width: 1.3),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: const BorderSide(color: Color(0xFF7B38C8), width: 1.5),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),

          prefixIcon: Icon(icon, size: 27, color: Color(0xFF18151B)),

          prefixIconConstraints: const BoxConstraints(minWidth: 67),

          suffixIcon: suffixIcon,

          hintText: hint,

          hintStyle: const TextStyle(
            fontSize: 17,
            color: Color(0xFF99959B),
            fontWeight: FontWeight.w400,
          ),

          errorStyle: const TextStyle(
            color: Color(0xFFE53935),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),

          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 18,
          ),
        ),
      ),
    );
  }
}
