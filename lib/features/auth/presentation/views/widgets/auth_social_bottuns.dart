import 'package:demix/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            child: SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset(Assets.assetsSvgGoogleLogo),
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
