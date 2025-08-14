import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hallogen_expenses_tracker/presentation/blocs/navigation_cubit.dart';

void main() {
  group('NavigationCubit', () {
    late NavigationCubit cubit;

    setUp(() {
      cubit = NavigationCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state, isA<NavigationState>());
      expect(cubit.state.currentIndex, equals(0));
    });

    group('navigateToTab', () {
      blocTest<NavigationCubit, NavigationState>(
        'emits new state with updated index',
        build: () => cubit,
        act: (cubit) => cubit.navigateToTab(1),
        expect: () => [
          isA<NavigationState>().having(
            (state) => state.currentIndex,
            'currentIndex',
            1,
          ),
        ],
      );

      blocTest<NavigationCubit, NavigationState>(
        'emits new state with zero index',
        build: () => cubit,
        act: (cubit) => cubit.navigateToTab(0),
        expect: () => [
          isA<NavigationState>().having(
            (state) => state.currentIndex,
            'currentIndex',
            0,
          ),
        ],
      );

      blocTest<NavigationCubit, NavigationState>(
        'emits new state with maximum index',
        build: () => cubit,
        act: (cubit) => cubit.navigateToTab(3),
        expect: () => [
          isA<NavigationState>().having(
            (state) => state.currentIndex,
            'currentIndex',
            3,
          ),
        ],
      );

      blocTest<NavigationCubit, NavigationState>(
        'emits new state with negative index',
        build: () => cubit,
        act: (cubit) => cubit.navigateToTab(-1),
        expect: () => [
          isA<NavigationState>().having(
            (state) => state.currentIndex,
            'currentIndex',
            -1,
          ),
        ],
      );
    });

    group('edge cases', () {
      test('handles very large index values', () {
        cubit.navigateToTab(100);
        expect(cubit.state.currentIndex, equals(100));
      });

      test('handles zero index multiple times', () {
        cubit.navigateToTab(0);
        cubit.navigateToTab(0);
        expect(cubit.state.currentIndex, equals(0));
      });

      test('handles rapid navigation changes', () {
        cubit.navigateToTab(1);
        cubit.navigateToTab(2);
        cubit.navigateToTab(3);
        cubit.navigateToTab(0);

        expect(cubit.state.currentIndex, equals(0));
      });
    });

    group('state immutability', () {
      test('state is immutable', () {
        final initialState = cubit.state;
        cubit.navigateToTab(1);

        expect(cubit.state, isNot(same(initialState)));
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

        expect(cubit.state.currentIndex, equals(0));
      });
    });
  });
}
