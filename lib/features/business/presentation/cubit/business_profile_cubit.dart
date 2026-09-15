import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demix/features/business/domain/use_cases/get_business_by_id_use_case.dart';
import 'package:demix/features/business/domain/use_cases/get_business_categories_use_case.dart';
import 'package:demix/features/business/domain/use_cases/get_business_products_use_case.dart';
import 'package:demix/features/business/presentation/cubit/business_profile_state.dart';

class BusinessProfileCubit extends Cubit<BusinessProfileState> {
  BusinessProfileCubit({
    required GetBusinessByIdUseCase getBusinessById,
    required GetBusinessCategoriesUseCase getBusinessCategories,
    required GetBusinessProductsUseCase getBusinessProducts,
  })  : _getBusinessById = getBusinessById,
        _getBusinessCategories = getBusinessCategories,
        _getBusinessProducts = getBusinessProducts,
        super(const BusinessProfileInitial());

  final GetBusinessByIdUseCase _getBusinessById;
  final GetBusinessCategoriesUseCase _getBusinessCategories;
  final GetBusinessProductsUseCase _getBusinessProducts;

  Future<void> load(String businessId) async {
    emit(const BusinessProfileLoading());
    try {
      final business = await _getBusinessById(businessId);
      final categoriesFuture = _getBusinessCategories(businessId);
      final productsFuture = _getBusinessProducts(businessId);

      final categories = await categoriesFuture;
      final products = await productsFuture;

      emit(
        BusinessProfileLoaded(
          business: business,
          categories: categories,
          products: products,
        ),
      );
    } catch (e) {
      emit(BusinessProfileFailure(e.toString()));
    }
  }
}
