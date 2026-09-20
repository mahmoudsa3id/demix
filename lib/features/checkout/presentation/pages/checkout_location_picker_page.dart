import 'package:demix/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:demix/features/location/presentation/cubit/location_cubit.dart';
import 'package:demix/features/location/presentation/pages/location_page.dart';
import 'package:demix/features/location/domain/use_cases/get_saved_location_use_case.dart';
import 'package:demix/features/orders/domain/entities/order_entity.dart';

class CheckoutLocationPickerPage extends StatelessWidget {
  const CheckoutLocationPickerPage({super.key});
  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (_) => getIt<LocationCubit>()..initialize(),
    child: LocationPage(
      onConfirmed: () async {
        final r = await getIt<GetSavedLocationUseCase>()();
        if (!c.mounted) return;
        r.fold((_) {}, (v) {
          if (v == null || !c.mounted) return;
          c.pop(
            DeliveryAddressSnapshot(
              formattedAddress: v.formattedAddress ?? '',
              street: v.street ?? '',
              area: v.area ?? '',
              city: v.city ?? '',
              latitude: v.latitude,
              longitude: v.longitude,
            ),
          );
        });
      },
    ),
  );
}
