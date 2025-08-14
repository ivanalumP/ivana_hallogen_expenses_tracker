import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/hive_storage_service.dart';
import '../../data/models/expense.dart';

// Events
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class InitializeExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final Expense expense;

  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  const UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;

  const DeleteExpense(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}

// States
abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ExpenseCubit extends Cubit<ExpenseState> {
  final HiveStorageService _storageService;

  ExpenseCubit(this._storageService) : super(ExpenseInitial());

  List<Expense> get expenses => _storageService.getAllExpenses();

  List<Expense> get sortedExpenses {
    final allExpenses = _storageService.getAllExpenses();
    allExpenses.sort((a, b) => b.date.compareTo(a.date)); // Newest first
    return allExpenses;
  }

  List<Expense> getExpensesByCategory(String category) {
    return _storageService
        .getAllExpenses()
        .where((expense) => expense.category == category)
        .toList();
  }

  double get totalAmount {
    return _storageService
        .getAllExpenses()
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  int get expensesCount => _storageService.getAllExpenses().length;

  bool get hasExpenses => _storageService.getAllExpenses().isNotEmpty;

  void initializeExpenses() async {
    emit(ExpenseLoading());

    try {
      final expenses = _storageService.getAllExpenses();
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError('Failed to initialize expenses: $e'));
    }
  }

  void addExpense(Expense expense) async {
    try {
      // Validate category is from API
      if (!_storageService.isValidCategory(expense.category)) {
        emit(ExpenseError('Invalid category: ${expense.category}'));
        return;
      }

      // Emit loading state first
      emit(ExpenseLoading());

      await _storageService.saveExpense(expense);
      final updatedExpenses = _storageService.getAllExpenses();
      emit(ExpenseLoaded(updatedExpenses));
    } catch (e) {
      emit(ExpenseError('Failed to add expense: $e'));
    }
  }

  void updateExpense(Expense updatedExpense) async {
    try {
      // Validate category is from API
      if (!_storageService.isValidCategory(updatedExpense.category)) {
        emit(ExpenseError('Invalid category: ${updatedExpense.category}'));
        return;
      }

      // Emit loading state first
      emit(ExpenseLoading());

      await _storageService.updateExpense(updatedExpense);
      final updatedExpenses = _storageService.getAllExpenses();
      emit(ExpenseLoaded(updatedExpenses));
    } catch (e) {
      emit(ExpenseError('Failed to update expense: $e'));
    }
  }

  void deleteExpense(String expenseId) async {
    try {
      // Emit loading state first
      emit(ExpenseLoading());

      await _storageService.deleteExpense(expenseId);
      final updatedExpenses = _storageService.getAllExpenses();
      emit(ExpenseLoaded(updatedExpenses));
    } catch (e) {
      emit(ExpenseError('Failed to delete expense: $e'));
    }
  }
}
