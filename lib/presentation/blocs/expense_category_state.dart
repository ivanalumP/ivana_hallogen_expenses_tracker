import 'package:equatable/equatable.dart';
import '../../data/models/expense_category.dart';
import '../../data/models/api_response.dart';
import '../../data/models/paginated_response.dart';

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
  final List<ExpenseCategory> categories;
  final ApiResponse<List<ExpenseCategory>>? response;

  const ExpenseCategoryLoaded({
    required this.categories,
    this.response,
  });

  @override
  List<Object?> get props => [categories, response];

  ExpenseCategoryLoaded copyWith({
    List<ExpenseCategory>? categories,
    ApiResponse<List<ExpenseCategory>>? response,
  }) {
    return ExpenseCategoryLoaded(
      categories: categories ?? this.categories,
      response: response ?? this.response,
    );
  }
}

/// Success state when paginated data is loaded
class ExpenseCategoryPaginatedLoaded extends ExpenseCategoryState {
  final List<ExpenseCategory> categories;
  final PaginatedResponse<ExpenseCategory> paginatedResponse;

  const ExpenseCategoryPaginatedLoaded({
    required this.categories,
    required this.paginatedResponse,
  });

  @override
  List<Object?> get props => [categories, paginatedResponse];

  ExpenseCategoryPaginatedLoaded copyWith({
    List<ExpenseCategory>? categories,
    PaginatedResponse<ExpenseCategory>? paginatedResponse,
  }) {
    return ExpenseCategoryPaginatedLoaded(
      categories: categories ?? this.categories,
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
