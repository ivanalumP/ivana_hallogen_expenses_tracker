import 'package:flutter/foundation.dart';
import '../data/models/expense_category.dart';
import '../data/models/api_response.dart';
import '../data/models/paginated_response.dart';
import '../domain/repositories/expense_category_repository.dart';
import '../dependencyInjection/service_locator.dart';

class ExpenseCategoryService extends ChangeNotifier {
  final ExpenseCategoryRepository _repository;

  List<ExpenseCategory> _categories = [];
  bool _isLoading = false;
  String? _error;
  ApiResponse<List<ExpenseCategory>>? _lastResponse;
  PaginatedResponse<ExpenseCategory>? _paginatedResponse;

  ExpenseCategoryService() : _repository = getIt<ExpenseCategoryRepository>();

  List<ExpenseCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ApiResponse<List<ExpenseCategory>>? get lastResponse => _lastResponse;
  PaginatedResponse<ExpenseCategory>? get paginatedResponse =>
      _paginatedResponse;

  /// Fetch expense categories using the basic method
  Future<void> fetchExpenseCategories() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _categories = await _repository.getExpenseCategories();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Fetch expense categories with API response wrapper
  Future<void> fetchExpenseCategoriesWithResponse() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _lastResponse = await _repository.getExpenseCategoriesWithResponse();

      if (_lastResponse!.isSuccess) {
        _categories = _lastResponse!.data!;
        _error = null;
      } else {
        _error = _lastResponse!.errorMessage;
        _categories = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Fetch expense categories with pagination
  Future<void> fetchExpenseCategoriesPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _paginatedResponse = await _repository.getExpenseCategoriesPaginated(
        page: page,
        limit: limit,
      );

      if (_paginatedResponse!.success) {
        _categories = _paginatedResponse!.data;
        _error = null;
      } else {
        _error = 'Failed to load paginated categories';
        _categories = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Get categories for a specific page
  Future<void> loadPage(int page, {int limit = 20}) async {
    await fetchExpenseCategoriesPaginated(page: page, limit: limit);
  }

  /// Load next page if available
  Future<void> loadNextPage() async {
    if (_paginatedResponse?.hasMorePages == true) {
      final nextPage = _paginatedResponse!.pagination.nextPage;
      if (nextPage != null) {
        await loadPage(nextPage, limit: _paginatedResponse!.pagination.limit);
      }
    }
  }

  /// Load previous page if available
  Future<void> loadPreviousPage() async {
    if (_paginatedResponse?.pagination.hasPrevious == true) {
      final previousPage = _paginatedResponse!.pagination.previousPage;
      if (previousPage != null) {
        await loadPage(previousPage,
            limit: _paginatedResponse!.pagination.limit);
      }
    }
  }

  /// Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get current page information
  int get currentPage => _paginatedResponse?.pagination.page ?? 1;
  int get totalPages => _paginatedResponse?.pagination.totalPages ?? 1;
  int get totalItems => _paginatedResponse?.pagination.total ?? 0;
  bool get hasMorePages => _paginatedResponse?.pagination.hasNext ?? false;
  bool get hasPreviousPages =>
      _paginatedResponse?.pagination.hasPrevious ?? false;
}
