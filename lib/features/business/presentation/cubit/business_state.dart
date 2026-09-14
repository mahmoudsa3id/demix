import 'package:equatable/equatable.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/business.dart';

sealed class BusinessState extends Equatable {
  const BusinessState();

  @override
  List<Object?> get props => [];
}

class BusinessInitial extends BusinessState {
  const BusinessInitial();
}

class BusinessLoading extends BusinessState {
  const BusinessLoading();
}

class BusinessLoaded extends BusinessState {
  const BusinessLoaded({
    required this.businesses,
    required this.type,
  });

  final List<Business> businesses;
  final String type;

  @override
  List<Object?> get props => [businesses, type];
}

class BusinessEmpty extends BusinessState {
  const BusinessEmpty(this.type);

  final String type;

  @override
  List<Object?> get props => [type];
}

class BusinessFailure extends BusinessState {
  const BusinessFailure(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
