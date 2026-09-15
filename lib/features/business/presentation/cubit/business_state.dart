import 'package:demix/features/business/domain/entities/business.dart';

sealed class BusinessState {
  const BusinessState();
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
    required this.page,
    required this.hasMore,
    required this.search,
  });

  final List<Business> businesses;
  final int page;
  final bool hasMore;
  final String search;
}

class BusinessLoadingMore extends BusinessLoaded {
  const BusinessLoadingMore({
    required super.businesses,
    required super.page,
    required super.hasMore,
    required super.search,
  });
}

class BusinessFailure extends BusinessState {
  const BusinessFailure(this.message);

  final String message;
}
