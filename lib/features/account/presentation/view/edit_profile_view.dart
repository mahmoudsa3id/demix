import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/account/presentation/cubit/account_cubit.dart';
import 'package:demix/features/account/presentation/cubit/account_state.dart';
import 'package:demix/features/account/presentation/view/account_page_shell.dart';
import 'package:demix/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    final state = context.read<AccountCubit>().state;
    final user = state is AccountLoaded ? state.user : null;

    _nameController = TextEditingController(text: user?.displayName ?? '');

    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AccountCubit>().updateProfile(
      displayName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is AccountLoaded) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(s.profileUpdated)));

          context.pop();
        }

        if (state is AccountFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      child: AccountPageShell(
        title: s.editProfile,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AccountSectionHeader(
                  title: s.editProfile,
                  icon: Icons.edit_outlined,
                ),

                const SizedBox(height: 12),

                AccountCard(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: s.name,
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return s.requiredField;
                            }

                            if (value.trim().length < 2) {
                              return s.invalidName;
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: s.phone,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        BlocBuilder<AccountCubit, AccountState>(
                          builder: (context, state) {
                            final loading = state is AccountUpdating;

                            return AccountPrimaryButton(
                              text: s.save,
                              loading: loading,
                              onPressed: _save,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
