import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/expense_category.dart';
import '../../domain/repositories/expense_category_repository.dart';
import '../../services/hive_storage_service.dart';

// States
abstract class RecommendedState extends Equatable {
  const RecommendedState();

  @override
  List<Object?> get props => [];
}

class RecommendedInitial extends RecommendedState {
  const RecommendedInitial();
}

class RecommendedLoading extends RecommendedState {
  const RecommendedLoading();
}

class RecommendedLoaded extends RecommendedState {
  final List<ExpenseCategory> expenseCategories;
  final List<String> localCategories;

  const RecommendedLoaded({
    required this.expenseCategories,
    required this.localCategories,
  });

  @override
  List<Object?> get props => [expenseCategories, localCategories];
}

class RecommendedError extends RecommendedState {
  final String message;

  const RecommendedError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class RecommendedCubit extends Cubit<RecommendedState> {
  final ExpenseCategoryRepository _repository;
  final HiveStorageService _storageService;

  RecommendedCubit(this._repository, this._storageService)
      : super(const RecommendedInitial());

  /// Fetch expense categories from API and save to local storage
  Future<void> fetchExpenseCategories() async {
    emit(const RecommendedLoading());

    try {
      final categories = await _repository.getExpenseCategories();

      // Save categories to Hive storage
      final categoryNames = categories.map((cat) => cat.name).toList();
      await _storageService.saveCategories(categoryNames);

      // Get local categories for comparison
      final localCategories = _storageService.getCategories();

      emit(RecommendedLoaded(
        expenseCategories: categories,
        localCategories: localCategories,
      ));
    } catch (e) {
      emit(RecommendedError('Failed to load categories: $e'));
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

  /// Get recommended percentage for a category
  double? getRecommendedPercentage(String categoryName) {
    final state = this.state;
    if (state is RecommendedLoaded) {
      final category = state.expenseCategories.firstWhere(
        (cat) => cat.name == categoryName,
        orElse: () => const ExpenseCategory(
          name: '',
          isFixed: false,
        ),
      );
      return category.recommendedPercentage;
    }
    return null;
  }

  /// Get fixed categories
  List<ExpenseCategory> getFixedCategories() {
    final state = this.state;
    if (state is RecommendedLoaded) {
      return state.expenseCategories.where((cat) => cat.isFixed).toList();
    }
    return [];
  }

  /// Get flexible categories
  List<ExpenseCategory> getFlexibleCategories() {
    final state = this.state;
    if (state is RecommendedLoaded) {
      return state.expenseCategories.where((cat) => !cat.isFixed).toList();
    }
    return [];
  }

  /// Refresh local categories from storage
  void refreshLocalCategories() {
    final currentState = state;
    if (currentState is RecommendedLoaded) {
      final localCategories = _storageService.getCategories();
      emit(RecommendedLoaded(
        expenseCategories: currentState.expenseCategories,
        localCategories: localCategories,
      ));
    }
  }
}
