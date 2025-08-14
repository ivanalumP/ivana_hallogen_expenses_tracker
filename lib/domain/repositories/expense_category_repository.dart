import '../../data/models/expense_category.dart';
import '../../data/models/api_response.dart';
import '../../data/models/paginated_response.dart';

abstract class ExpenseCategoryRepository {
  /// Get all expense categories
  Future<List<ExpenseCategory>> getExpenseCategories();

  /// Get expense categories with pagination
  Future<PaginatedResponse<ExpenseCategory>> getExpenseCategoriesPaginated({
    int page,
    int limit,
  });

  /// Get expense categories with API response wrapper
  Future<ApiResponse<List<ExpenseCategory>>> getExpenseCategoriesWithResponse();
}
