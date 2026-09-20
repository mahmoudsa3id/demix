import 'package:demix/features/account/presentation/view/simple_account_view.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SimpleAccountPage(
      title: s.privacy,
      icon: Icons.privacy_tip_outlined,
      message: s.privacyPolicyContent,
    );
  }
}
