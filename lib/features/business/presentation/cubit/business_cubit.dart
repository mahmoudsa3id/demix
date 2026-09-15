import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/domain/use_cases/get_all_business_use_cases.dart';
import 'package:demix/features/business/domain/use_cases/get_business_page_use_cases.dart';
import 'package:demix/features/business/domain/use_cases/get_businesses_by_type_use_case.dart';
import 'package:demix/features/business/presentation/cubit/business_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusinessCubit extends Cubit<BusinessState> {
  BusinessCubit({
    required GetBusinessesByTypeUseCase getBusinessesByType,
    required GetAllBusinessesUseCase getAllBusinesses,
    required GetBusinessesPageUseCase getBusinessesPage,
  }) : _getBusinessesByType = getBusinessesByType,
       _getAllBusinesses = getAllBusinesses,
       _getBusinessesPage = getBusinessesPage,
       super(const BusinessInitial());

  final GetBusinessesByTypeUseCase _getBusinessesByType;
  final GetAllBusinessesUseCase _getAllBusinesses;
  final GetBusinessesPageUseCase _getBusinessesPage;

  static const int _pageSize = 10;

  String _currentType = '';
  String _currentLanguageCode = 'en';
  String _currentSearch = '';

  int _currentPage = 1;

  bool _hasMore = true;
  bool _isLoading = false;

  final List<DocumentSnapshot<Map<String, dynamic>>?> _pageCursors = [null];

  // ============================================================
  // LOAD BY TYPE
  // ============================================================

  Future<void> load(String type) async {
    emit(const BusinessLoading());

    try {
      final businesses = await _getBusinessesByType(type);

      emit(
        BusinessLoaded(
          businesses: businesses,
          page: 1,
          hasMore: false,
          search: '',
        ),
      );
    } catch (e) {
      emit(BusinessFailure(e.toString()));
    }
  }

  // ============================================================
  // LOAD ALL
  // ============================================================

  Future<void> loadAll() async {
    emit(const BusinessLoading());

    try {
      final businesses = await _getAllBusinesses();

      emit(
        BusinessLoaded(
          businesses: businesses,
          page: 1,
          hasMore: false,
          search: '',
        ),
      );
    } catch (e) {
      emit(BusinessFailure(e.toString()));
    }
  }

  // ============================================================
  // FIRST PAGE
  // ============================================================

  Future<void> loadFirstPage({
    required String type,
    required String languageCode,
    String search = '',
  }) async {
    if (_isLoading) return;

    _isLoading = true;

    _currentType = type;
    _currentLanguageCode = languageCode;
    _currentSearch = search.trim();

    _currentPage = 1;
    _hasMore = true;

    _pageCursors
      ..clear()
      ..add(null);

    emit(const BusinessLoading());

    try {
      final result = await _getBusinessesPage(
        type: _currentType,
        languageCode: _currentLanguageCode,
        search: _currentSearch.isEmpty ? null : _currentSearch,
        lastDocument: null,
        limit: _pageSize,
      );

      _hasMore = result.hasMore;

      _pageCursors.add(result.lastDocument);

      emit(
        BusinessLoaded(
          businesses: result.businesses,
          page: 1,
          hasMore: result.hasMore,
          search: _currentSearch,
        ),
      );
    } catch (e) {
      emit(BusinessFailure(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  // ============================================================
  // NEXT PAGE
  // ============================================================

  Future<void> nextPage() async {
    if (_isLoading || !_hasMore) return;

    final currentState = state;

    if (currentState is! BusinessLoaded) return;

    _isLoading = true;

    emit(
      BusinessLoadingMore(
        businesses: currentState.businesses,
        page: currentState.page,
        hasMore: currentState.hasMore,
        search: currentState.search,
      ),
    );

    try {
      final lastDocument = _pageCursors.isNotEmpty ? _pageCursors.last : null;

      final result = await _getBusinessesPage(
        type: _currentType,
        languageCode: _currentLanguageCode,
        search: _currentSearch.isEmpty ? null : _currentSearch,
        lastDocument: lastDocument,
        limit: _pageSize,
      );

      _currentPage++;

      _hasMore = result.hasMore;

      _pageCursors.add(result.lastDocument);

      emit(
        BusinessLoaded(
          businesses: result.businesses,
          page: _currentPage,
          hasMore: result.hasMore,
          search: _currentSearch,
        ),
      );
    } catch (e) {
      emit(BusinessFailure(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  // ============================================================
  // PREVIOUS PAGE
  // ============================================================

  Future<void> previousPage() async {
    if (_isLoading || _currentPage <= 1) return;

    final currentState = state;

    if (currentState is! BusinessLoaded) return;

    _isLoading = true;

    emit(
      BusinessLoadingMore(
        businesses: currentState.businesses,
        page: currentState.page,
        hasMore: currentState.hasMore,
        search: currentState.search,
      ),
    );

    try {
      final targetPage = _currentPage - 1;

      final previousCursor = _pageCursors[targetPage - 1];

      final result = await _getBusinessesPage(
        type: _currentType,
        languageCode: _currentLanguageCode,
        search: _currentSearch.isEmpty ? null : _currentSearch,
        lastDocument: previousCursor,
        limit: _pageSize,
      );

      _currentPage = targetPage;

      _hasMore = result.hasMore;

      emit(
        BusinessLoaded(
          businesses: result.businesses,
          page: _currentPage,
          hasMore: result.hasMore,
          search: _currentSearch,
        ),
      );
    } catch (e) {
      emit(BusinessFailure(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<void> search({
    required String type,
    required String languageCode,
    required String value,
  }) async {
    await loadFirstPage(type: type, languageCode: languageCode, search: value);
  }

  // ============================================================
  // GETTERS
  // ============================================================

  int get currentPage => _currentPage;

  bool get hasMore => _hasMore;

  bool get canGoPrevious => _currentPage > 1;

  bool get isLoading => _isLoading;
}
