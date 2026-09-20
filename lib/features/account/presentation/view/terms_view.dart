import 'package:demix/features/account/presentation/view/simple_account_view.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SimpleAccountPage(
      title: s.terms,
      icon: Icons.description_outlined,
      message: s.termsAndConditionsContent,
    );
  }
}
