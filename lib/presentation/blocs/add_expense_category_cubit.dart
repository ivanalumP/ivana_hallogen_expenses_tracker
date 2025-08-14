import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/expense_category.dart';
import '../../domain/repositories/expense_category_repository.dart';
import '../../services/hive_storage_service.dart';

// States
abstract class AddExpenseCategoryState extends Equatable {
  const AddExpenseCategoryState();

  @override
  List<Object?> get props => [];
}

class AddExpenseCategoryInitial extends AddExpenseCategoryState {
  const AddExpenseCategoryInitial();
}

class AddExpenseCategoryLoading extends AddExpenseCategoryState {
  const AddExpenseCategoryLoading();
}

class AddExpenseCategoryLoaded extends AddExpenseCategoryState {
  final List<ExpenseCategory> expenseCategories;
  final List<String> localCategories;

  const AddExpenseCategoryLoaded({
    required this.expenseCategories,
    required this.localCategories,
  });

  @override
  List<Object?> get props => [expenseCategories, localCategories];
}

class AddExpenseCategoryError extends AddExpenseCategoryState {
  final String message;

  const AddExpenseCategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class AddExpenseCategoryCubit extends Cubit<AddExpenseCategoryState> {
  final ExpenseCategoryRepository _repository;
  final HiveStorageService _storageService;

  AddExpenseCategoryCubit(this._repository, this._storageService)
      : super(const AddExpenseCategoryInitial());

  /// Fetch expense categories from API and save to local storage
  Future<void> fetchExpenseCategories() async {
    // Check if cubit is closed before proceeding
    if (isClosed) {
      return;
    }

    emit(const AddExpenseCategoryLoading());

    try {
      final categories = await _repository.getExpenseCategories();

      // Check again if cubit is closed after async operation
      if (isClosed) {
        return;
      }

      // Save categories to Hive storage
      final categoryNames = categories.map((cat) => cat.name).toList();
      await _storageService.saveCategories(categoryNames);

      // Check again if cubit is closed after storage operation
      if (isClosed) {
        return;
      }

      // Get local categories for comparison
      final localCategories = _storageService.getCategories();

      emit(AddExpenseCategoryLoaded(
        expenseCategories: categories,
        localCategories: localCategories,
      ));
    } catch (e) {
      // Check if cubit is closed before emitting error
      if (isClosed) {
        return;
      }
      emit(AddExpenseCategoryError('Failed to load categories: $e'));
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

  /// Get category names for dropdown
  List<String> getCategoryNames() {
    final state = this.state;
    if (state is AddExpenseCategoryLoaded) {
      return state.expenseCategories.map((cat) => cat.name).toList();
    }
    return getLocalCategories();
  }

  /// Get category by name
  ExpenseCategory? getCategoryByName(String categoryName) {
    final state = this.state;
    if (state is AddExpenseCategoryLoaded) {
      try {
        return state.expenseCategories.firstWhere(
          (cat) => cat.name == categoryName,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
