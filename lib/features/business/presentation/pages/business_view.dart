import 'package:demix/core/di/injection.dart';
import 'package:demix/features/business/presentation/cubit/business_cubit.dart';
import 'package:demix/features/business/presentation/pages/widgets/business_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusinessView extends StatelessWidget {
  const BusinessView({super.key, required this.type});

  final String type;

  bool get isCafe => type.toLowerCase() == 'cafe';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BusinessCubit>()..load(type),
      child: BusinessViewBody(type: type, isCafe: isCafe),
    );
  }
}
