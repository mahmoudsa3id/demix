import 'package:demix/features/account/presentation/view/simple_account_view.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SimpleAccountPage(
      title: s.support,
      icon: Icons.support_agent_rounded,
      message: s.contactUs,
    );
  }
}
