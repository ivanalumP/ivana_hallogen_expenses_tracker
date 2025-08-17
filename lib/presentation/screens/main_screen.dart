import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'recommended_tab.dart';
import '../../dependencyInjection/service_locator.dart';
import '../theme/theme_constants.dart';
import '../blocs/navigation_cubit.dart';
import '../blocs/expense_cubit.dart';
import '../blocs/budget_cubit.dart';
import 'main_tab.dart';
import 'records_tab.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<NavigationCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ExpenseCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<BudgetCubit>(),
        ),
      ],
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  const _MainScreenContent();

  @override
  Widget build(BuildContext context) {
    final navigationCubit = context.read<NavigationCubit>();

    final List<Widget> tabs = [
      const MainTab(),
      const RecordsTab(),
      const RecommendedTab(),
    ];

    return Scaffold(
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return tabs[state.currentIndex];
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.navigation(context),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                navigationCubit.navigateToTab(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withValues(alpha: 0.7),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Budget',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Records',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Recommendations',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
