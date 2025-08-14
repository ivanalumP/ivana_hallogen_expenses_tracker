import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hallogen_expenses_tracker/presentation/blocs/add_expense_form_cubit.dart';

void main() {
  group('AddExpenseFormCubit', () {
    late AddExpenseFormCubit cubit;

    setUp(() {
      cubit = AddExpenseFormCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state, isA<AddExpenseFormState>());
      expect(cubit.selectedCategory, isNull);
      expect(cubit.amount, isEmpty);
      expect(cubit.selectedDate, isA<DateTime>());
      expect(cubit.notes, isEmpty);
      expect(cubit.isFormValid, isFalse);
    });

    group('updateCategory', () {
      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'emits new state with updated category',
        build: () => cubit,
        act: (cubit) => cubit.updateCategory('Food'),
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.selectedCategory,
            'selectedCategory',
            'Food',
          ),
        ],
      );

      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'emits new state with null category',
        build: () => cubit,
        act: (cubit) => cubit.updateCategory(null),
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.selectedCategory,
            'selectedCategory',
            isNull,
          ),
        ],
      );

      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'updates form validity when category changes',
        build: () => cubit,
        act: (cubit) {
          cubit.updateAmount('50.00');
          cubit.updateCategory('Food');
        },
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.isFormValid,
            'isFormValid',
            isFalse,
          ),
          isA<AddExpenseFormState>().having(
            (state) => state.isFormValid,
            'isFormValid',
            isTrue,
          ),
        ],
      );
    });

    group('updateAmount', () {
      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'emits new state with updated amount',
        build: () => cubit,
        act: (cubit) => cubit.updateAmount('100.50'),
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.amount,
            'amount',
            '100.50',
          ),
        ],
      );

      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'emits new state with empty amount',
        build: () => cubit,
        act: (cubit) => cubit.updateAmount(''),
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.amount,
            'amount',
            isEmpty,
          ),
        ],
      );

      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'updates form validity when amount changes',
        build: () => cubit,
        act: (cubit) {
          cubit.updateCategory('Food');
          cubit.updateAmount('75.25');
        },
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.isFormValid,
            'isFormValid',
            isFalse,
          ),
          isA<AddExpenseFormState>().having(
            (state) => state.isFormValid,
            'isFormValid',
            isTrue,
          ),
        ],
      );
    });

    group('updateDate', () {
      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'emits new state with updated date',
        build: () => cubit,
        act: (cubit) {
          final newDate = DateTime(2024, 1, 15);
          cubit.updateDate(newDate);
        },
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.selectedDate,
            'selectedDate',
            DateTime(2024, 1, 15),
          ),
        ],
      );
    });

    group('updateNotes', () {
      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'emits new state with updated notes',
        build: () => cubit,
        act: (cubit) => cubit.updateNotes('Lunch with colleagues'),
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.notes,
            'notes',
            'Lunch with colleagues',
          ),
        ],
      );

      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'emits new state with empty notes',
        build: () => cubit,
        act: (cubit) => cubit.updateNotes(''),
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.notes,
            'notes',
            isEmpty,
          ),
        ],
      );
    });

    group('resetForm', () {
      blocTest<AddExpenseFormCubit, AddExpenseFormState>(
        'emits new state with reset values',
        build: () => cubit,
        act: (cubit) {
          cubit.updateCategory('Food');
          cubit.updateAmount('100.00');
          cubit.updateNotes('Test notes');
          cubit.resetForm();
        },
        expect: () => [
          isA<AddExpenseFormState>().having(
            (state) => state.selectedCategory,
            'selectedCategory',
            'Food',
          ),
          isA<AddExpenseFormState>().having(
            (state) => state.amount,
            'amount',
            '100.00',
          ),
          isA<AddExpenseFormState>().having(
            (state) => state.notes,
            'notes',
            'Test notes',
          ),
          isA<AddExpenseFormState>()
              .having(
                (state) => state.selectedCategory,
                'selectedCategory',
                isNull,
              )
              .having(
                (state) => state.amount,
                'amount',
                isEmpty,
              )
              .having(
                (state) => state.notes,
                'notes',
                isEmpty,
              ),
        ],
      );
    });

    group('form validation', () {
      test('form is valid when category and amount are provided', () {
        cubit.updateCategory('Food');
        cubit.updateAmount('50.00');

        expect(cubit.isFormValid, isTrue);
      });

      test('form is invalid when category is missing', () {
        cubit.updateAmount('50.00');

        expect(cubit.isFormValid, isFalse);
      });

      test('form is invalid when amount is missing', () {
        cubit.updateCategory('Food');

        expect(cubit.isFormValid, isFalse);
      });

      test('form is invalid when amount is zero', () {
        cubit.updateCategory('Food');
        cubit.updateAmount('0.00');

        expect(cubit.isFormValid, isFalse);
      });

      test('form is invalid when amount is negative', () {
        cubit.updateCategory('Food');
        cubit.updateAmount('-10.00');

        expect(cubit.isFormValid, isFalse);
      });

      test('form is invalid when amount is not a valid number', () {
        cubit.updateCategory('Food');
        cubit.updateAmount('invalid');

        expect(cubit.isFormValid, isFalse);
      });
    });

    group('state immutability', () {
      test('state is immutable', () {
        final initialState = cubit.state;
        cubit.updateCategory('Food');

        expect(cubit.state, isNot(same(initialState)));
      });
    });
  });
}
