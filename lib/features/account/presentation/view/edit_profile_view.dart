import 'package:demix/core/theme/app_colors.dart';
import 'package:demix/features/account/presentation/cubit/account_cubit.dart';
import 'package:demix/features/account/presentation/cubit/account_state.dart';
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
      displayName: _nameController.text,
      phone: _phoneController.text,
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
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            s.editProfile,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 45,
                      color: AppColors.secondary,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: s.name,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
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
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),

                const SizedBox(height: 30),

                BlocBuilder<AccountCubit, AccountState>(
                  builder: (context, state) {
                    final loading = state is AccountUpdating;

                    return SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: loading ? null : _save,
                        child: loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                s.save,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
