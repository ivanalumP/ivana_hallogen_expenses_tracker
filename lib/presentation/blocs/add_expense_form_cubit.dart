import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AddExpenseFormEvent extends Equatable {
  const AddExpenseFormEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCategory extends AddExpenseFormEvent {
  final String? category;

  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateAmount extends AddExpenseFormEvent {
  final String amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class UpdateDate extends AddExpenseFormEvent {
  final DateTime date;

  const UpdateDate(this.date);

  @override
  List<Object?> get props => [date];
}

class UpdateNotes extends AddExpenseFormEvent {
  final String notes;

  const UpdateNotes(this.notes);

  @override
  List<Object?> get props => [notes];
}

class ResetForm extends AddExpenseFormEvent {}

// States
class AddExpenseFormState extends Equatable {
  final String? selectedCategory;
  final String amount;
  final DateTime selectedDate;
  final String notes;
  final bool isFormValid;

  const AddExpenseFormState({
    this.selectedCategory,
    this.amount = '',
    required this.selectedDate,
    this.notes = '',
    this.isFormValid = false,
  });

  @override
  List<Object?> get props => [
        selectedCategory,
        amount,
        selectedDate,
        notes,
        isFormValid,
      ];

  AddExpenseFormState copyWith({
    String? selectedCategory,
    String? amount,
    DateTime? selectedDate,
    String? notes,
    bool? isFormValid,
  }) {
    return AddExpenseFormState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      amount: amount ?? this.amount,
      selectedDate: selectedDate ?? this.selectedDate,
      notes: notes ?? this.notes,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}

// Cubit
class AddExpenseFormCubit extends Cubit<AddExpenseFormState> {
  AddExpenseFormCubit()
      : super(AddExpenseFormState(selectedDate: DateTime.now()));

  void updateCategory(String? category) {
    final newState = state.copyWith(
      selectedCategory: category,
      isFormValid: _calculateFormValidity(category, state.amount),
    );
    emit(newState);
  }

  void updateAmount(String amount) {
    final newState = state.copyWith(
      amount: amount,
      isFormValid: _calculateFormValidity(state.selectedCategory, amount),
    );
    emit(newState);
  }

  void updateDate(DateTime date) {
    final newState = state.copyWith(selectedDate: date);
    emit(newState);
  }

  void updateNotes(String notes) {
    final newState = state.copyWith(notes: notes);
    emit(newState);
  }

  void resetForm() {
    emit(AddExpenseFormState(selectedDate: DateTime.now()));
  }

  bool _calculateFormValidity(String? category, String amount) {
    // Check if category is selected
    if (category == null || category.isEmpty) {
      return false;
    }

    // Check if amount is entered and valid
    if (amount.isEmpty) {
      return false;
    }

    final amountValue = double.tryParse(amount);
    if (amountValue == null || amountValue <= 0) {
      return false;
    }

    // Date is always set (defaults to current date), so no need to check

    return true;
  }

  // Getters for easy access
  String? get selectedCategory => state.selectedCategory;
  String get amount => state.amount;
  DateTime get selectedDate => state.selectedDate;
  String get notes => state.notes;
  bool get isFormValid => state.isFormValid;
}
