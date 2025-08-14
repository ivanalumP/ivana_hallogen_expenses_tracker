import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/hive_storage_service.dart';
import '../../data/models/budget.dart';

// Events
abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class InitializeBudget extends BudgetEvent {}

class UpdateMonthlyBudget extends BudgetEvent {
  final double newBudget;

  const UpdateMonthlyBudget(this.newBudget);

  @override
  List<Object?> get props => [newBudget];
}

class AddExpense extends BudgetEvent {
  final double amount;

  const AddExpense(this.amount);

  @override
  List<Object?> get props => [amount];
}

// States
abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final Budget budget;

  const BudgetLoaded(this.budget);

  @override
  List<Object?> get props => [budget];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class BudgetCubit extends Cubit<BudgetState> {
  final HiveStorageService _storageService;

  BudgetCubit(this._storageService) : super(BudgetInitial());

  Budget? get currentBudget => _storageService.getBudget();

  void initializeBudget() async {
    emit(BudgetLoading());

    try {
      final budget = _storageService.getBudget();
      if (budget != null && budget.monthlyBudget > 0) {
        emit(BudgetLoaded(budget));
      } else {
        // Don't create a default budget with zero amount
        // Just emit initial state and wait for user to set budget
        emit(BudgetInitial());
      }
    } catch (e) {
      emit(BudgetError('Failed to initialize budget: $e'));
    }
  }

  void updateMonthlyBudget(double newBudget) async {
    try {
      // Validate budget amount
      if (newBudget <= 0) {
        emit(const BudgetError('Budget must be greater than 0'));
        return;
      }

      final currentBudget = _storageService.getBudget();
      final updatedBudget = currentBudget?.copyWith(
            monthlyBudget: newBudget,
            currentBalance: newBudget,
          ) ??
          Budget(
            monthlyBudget: newBudget,
            currentBalance: newBudget,
            totalSpent: 0.0,
            month: _getCurrentMonth(),
            year: DateTime.now().year,
          );

      await _storageService.saveBudget(updatedBudget);
      emit(BudgetLoaded(updatedBudget));
    } catch (e) {
      emit(BudgetError('Failed to update budget: $e'));
    }
  }

  void addExpense(double amount) async {
    try {
      final currentBudget = _storageService.getBudget();
      if (currentBudget != null) {
        final updatedBudget = currentBudget.copyWith(
          totalSpent: currentBudget.totalSpent + amount,
        );
        await _storageService.saveBudget(updatedBudget);
        emit(BudgetLoaded(updatedBudget));
      }
    } catch (e) {
      emit(BudgetError('Failed to add expense: $e'));
    }
  }

  String _getCurrentMonth() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[DateTime.now().month - 1];
  }
}
