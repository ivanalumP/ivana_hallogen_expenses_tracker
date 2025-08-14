import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/expense_category.dart';
import '../../data/models/api_response.dart';
import '../../data/models/paginated_response.dart';
import '../../domain/repositories/expense_category_repository.dart';
import '../../services/hive_storage_service.dart';

/// Base state for expense category operations
abstract class ExpenseCategoryState extends Equatable {
  const ExpenseCategoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no operation has been performed
class ExpenseCategoryInitial extends ExpenseCategoryState {
  const ExpenseCategoryInitial();
}

/// Loading state when fetching data
class ExpenseCategoryLoading extends ExpenseCategoryState {
  const ExpenseCategoryLoading();
}

/// Success state when data is loaded successfully
class ExpenseCategoryLoaded extends ExpenseCategoryState {
  final List<ExpenseCategory> expenseCategories;
  final ApiResponse<List<ExpenseCategory>>? response;

  const ExpenseCategoryLoaded({
    required this.expenseCategories,
    this.response,
  });

  @override
  List<Object?> get props => [expenseCategories, response];

  ExpenseCategoryLoaded copyWith({
    List<ExpenseCategory>? expenseCategories,
    ApiResponse<List<ExpenseCategory>>? response,
  }) {
    return ExpenseCategoryLoaded(
      expenseCategories: expenseCategories ?? this.expenseCategories,
      response: response ?? this.response,
    );
  }
}

/// Success state when paginated data is loaded
class ExpenseCategoryPaginatedLoaded extends ExpenseCategoryState {
  final List<ExpenseCategory> expenseCategories;
  final PaginatedResponse<ExpenseCategory> paginatedResponse;

  const ExpenseCategoryPaginatedLoaded({
    required this.expenseCategories,
    required this.paginatedResponse,
  });

  @override
  List<Object?> get props => [expenseCategories, paginatedResponse];

  ExpenseCategoryPaginatedLoaded copyWith({
    List<ExpenseCategory>? expenseCategories,
    PaginatedResponse<ExpenseCategory>? paginatedResponse,
  }) {
    return ExpenseCategoryPaginatedLoaded(
      expenseCategories: expenseCategories ?? this.expenseCategories,
      paginatedResponse: paginatedResponse ?? this.paginatedResponse,
    );
  }
}

/// Error state when operation fails
class ExpenseCategoryError extends ExpenseCategoryState {
  final String message;

  const ExpenseCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Cubit for managing expense category operations
class ExpenseCategoryCubit extends Cubit<ExpenseCategoryState> {
  final ExpenseCategoryRepository _repository;
  final HiveStorageService _storageService;

  ExpenseCategoryCubit(this._repository, this._storageService)
      : super(const ExpenseCategoryInitial());

  /// Fetch expense categories from API and save to local storage
  Future<void> fetchExpenseCategories() async {
    emit(const ExpenseCategoryLoading());

    try {
      final categories = await _repository.getExpenseCategories();

      // Save categories to Hive storage
      final categoryNames = categories.map((cat) => cat.name).toList();
      await _storageService.saveCategories(categoryNames);

      emit(ExpenseCategoryLoaded(
        expenseCategories: categories,
        response: null,
      ));
    } catch (e) {
      emit(ExpenseCategoryError('Failed to load categories: $e'));
    }
  }

  /// Get categories from local storage
  List<String> getLocalCategories() {
    return _storageService.getCategories();
  }

  /// Check if a category is valid (exists in API categories)
  bool isValidCategory(String category) {
    return _storageService.isValidCategory(category);
  }
}
