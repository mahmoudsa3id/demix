import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: const _GoodFoodText()),

        const SizedBox(height: 12),

        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 42),
            child: Text(
              '${s.loginRealFood}\n'
              '${s.loginRealPeople}\n'
              '${s.loginHappierDays}',
              style: const TextStyle(
                fontSize: 10,
                letterSpacing: 3,
                height: 1.45,
                color: Color(0xFF8B878B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GoodFoodText extends StatelessWidget {
  const _GoodFoodText();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SizedBox(
      width: 175,
      height: 115,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              s.loginGood,
              style: const TextStyle(
                fontFamily: 'cursive',
                fontSize: 35,
                height: .9,
                color: Color(0xFF17131B),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          Positioned(
            left: 20,
            top: 29,
            child: Text(
              s.loginFood,
              style: const TextStyle(
                fontFamily: 'cursive',
                fontSize: 34,
                height: .9,
                color: Color(0xFF17131B),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          Positioned(
            left: 7,
            top: 59,
            child: Text(
              s.loginGood,
              style: const TextStyle(
                fontFamily: 'cursive',
                fontSize: 34,
                height: .9,
                color: Color(0xFF17131B),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          Positioned(
            left: 45,
            top: 87,
            child: Text(
              s.loginMood,
              style: const TextStyle(
                fontFamily: 'cursive',
                fontSize: 33,
                height: .9,
                color: Color(0xFF17131B),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          Positioned(
            left: 73,
            bottom: 1,
            child: Transform.rotate(
              angle: -0.34,
              child: Container(
                width: 91,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5A00),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
