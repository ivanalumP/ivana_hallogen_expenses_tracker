import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hallogen_expenses_tracker/presentation/blocs/add_expense_category_cubit.dart';
import 'package:hallogen_expenses_tracker/data/models/expense_category.dart';
import 'package:hallogen_expenses_tracker/domain/repositories/expense_category_repository.dart';
import 'package:hallogen_expenses_tracker/services/hive_storage_service.dart';

// Generate mocks
@GenerateMocks([ExpenseCategoryRepository, HiveStorageService])

// Mock classes for testing
class MockExpenseCategoryRepository extends Mock
    implements ExpenseCategoryRepository {}

class MockHiveStorageService extends Mock implements HiveStorageService {}

void main() {
  group('AddExpenseCategoryCubit', () {
    late AddExpenseCategoryCubit cubit;
    late MockExpenseCategoryRepository mockRepository;
    late MockHiveStorageService mockStorageService;

    setUp(() {
      mockRepository = MockExpenseCategoryRepository();
      mockStorageService = MockHiveStorageService();
      cubit = AddExpenseCategoryCubit(mockRepository, mockStorageService);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state, isA<AddExpenseCategoryInitial>());
    });

    group('fetchExpenseCategories', () {
      final mockCategories = [
        const ExpenseCategory(
          name: 'Food',
          recommendedPercentage: 20.0,
          isFixed: false,
        ),
        const ExpenseCategory(
          name: 'Transport',
          recommendedPercentage: 15.0,
          isFixed: true,
        ),
      ];
    });

    group('getCategoryByName', () {
      test('returns category when found in loaded state', () {
        final mockCategories = [
          const ExpenseCategory(
            name: 'Food',
            recommendedPercentage: 20.0,
            isFixed: false,
          ),
        ];

        // Set the state to loaded
        cubit.emit(AddExpenseCategoryLoaded(
          expenseCategories: mockCategories,
          localCategories: ['Food'],
        ));

        final result = cubit.getCategoryByName('Food');

        expect(result, equals(mockCategories.first));
      });

      test('returns null when category not found in loaded state', () {
        final mockCategories = [
          const ExpenseCategory(
            name: 'Food',
            recommendedPercentage: 20.0,
            isFixed: false,
          ),
        ];

        // Set the state to loaded
        cubit.emit(AddExpenseCategoryLoaded(
          expenseCategories: mockCategories,
          localCategories: ['Food'],
        ));

        final result = cubit.getCategoryByName('Transport');

        expect(result, isNull);
      });

      test('returns null when not in loaded state', () {
        final result = cubit.getCategoryByName('Food');

        expect(result, isNull);
      });
    });

    group('cubit lifecycle', () {
      test('can be closed', () {
        expect(cubit.isClosed, isFalse);
        cubit.close();
        expect(cubit.isClosed, isTrue);
      });

      test('does not emit after being closed', () {
        cubit.close();

        expect(() => cubit.fetchExpenseCategories(), returnsNormally);
        expect(cubit.state, isA<AddExpenseCategoryInitial>());
      });
    });
  });
}
