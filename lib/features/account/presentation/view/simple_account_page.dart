import 'package:demix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SimpleAccountPage extends StatelessWidget {
  const SimpleAccountPage({
    super.key,
    required this.title,
    required this.icon,
    required this.message,
  });

  final String title;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 42, color: AppColors.secondary),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
