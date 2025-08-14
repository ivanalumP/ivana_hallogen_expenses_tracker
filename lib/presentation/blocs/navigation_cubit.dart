import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// State for navigation
class NavigationState extends Equatable {
  final int currentIndex;

  const NavigationState({required this.currentIndex});

  @override
  List<Object?> get props => [currentIndex];

  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

/// Cubit for managing navigation state
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(currentIndex: 0));

  /// Navigate to a specific tab
  void navigateToTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
