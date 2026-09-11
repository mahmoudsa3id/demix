import 'package:flutter/material.dart';

class AuthSocialButtons extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;

  const AuthSocialButtons({super.key, this.onGoogleTap, this.onFacebookTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            onTap: onGoogleTap,
            child: const SizedBox(
              width: 32,
              height: 32,
              child: CustomPaint(painter: _GoogleLogoPainter()),
            ),
          ),
        ),

        const SizedBox(width: 22),

        Expanded(
          child: _SocialButton(
            onTap: onFacebookTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF1877F2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'f',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _SocialButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      width: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6E1DE), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width * .39;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .16
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round;

    final rect = Rect.fromCircle(center: center, radius: radius);

    paint.color = const Color(0xFF4285F4);

    canvas.drawArc(rect, -0.72, 1.48, false, paint);

    paint.color = const Color(0xFFEA4335);

    canvas.drawArc(rect, 2.05, 1.38, false, paint);

    paint.color = const Color(0xFFFBBC05);

    canvas.drawArc(rect, 3.43, .92, false, paint);

    paint.color = const Color(0xFF34A853);

    canvas.drawArc(rect, 4.35, 1.22, false, paint);

    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4285F4);

    final barTop = center.dy - size.height * .075;

    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - size.width * .01,
        barTop,
        size.width * .40,
        size.height * .15,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
