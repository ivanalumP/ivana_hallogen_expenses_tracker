import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dependencyInjection/service_locator.dart';
import '../../core/helpers/category_helpers.dart';

import '../blocs/budget_cubit.dart';
import '../blocs/expense_cubit.dart';
import '../theme/theme_constants.dart';
import '../widgets/budget_summary.dart';
import '../widgets/budget_edit_dialog.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainTabContent();
  }
}

class _MainTabContent extends StatefulWidget {
  const _MainTabContent();

  @override
  State<_MainTabContent> createState() => _MainTabContentState();
}

class _MainTabContentState extends State<_MainTabContent> {
  @override
  void initState() {
    super.initState();
    // Initialize budget and expenses when the tab is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final budgetCubit = context.read<BudgetCubit>();
        budgetCubit.initializeBudget();

        final expenseCubit = context.read<ExpenseCubit>();
        expenseCubit.initializeExpenses();
      }
    });
  }

  void _showBudgetEditDialog(BuildContext context) {
    final budgetCubit = context.read<BudgetCubit>();
    final currentBudget = budgetCubit.currentBudget;

    showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BudgetEditDialog(
          currentBudget: currentBudget?.monthlyBudget,
          month: currentBudget?.month ?? 'December',
          year: currentBudget?.year ?? DateTime.now().year,
        );
      },
    ).then((newBudget) {
      if (newBudget != null) {
        budgetCubit.updateMonthlyBudget(newBudget);
        // Use a post-frame callback to avoid BuildContext async gap
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  currentBudget != null
                      ? 'Budget updated to \$${newBudget.toStringAsFixed(2)}'
                      : 'Budget set to \$${newBudget.toStringAsFixed(2)}',
                ),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                ),
              ),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Overview'),
        backgroundColor: AppColors.primary, // Solid primary color
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.background(context),
        ),
        child: BlocBuilder<BudgetCubit, BudgetState>(
          builder: (context, budgetState) {
            if (budgetState is BudgetLoaded) {
              // Show budget overview with expenses summary
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Budget Summary Section
                    BudgetSummary(
                      onTap: () => _showBudgetEditDialog(context),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Expenses Summary by Category
                    _buildExpensesSummaryByCategory(context),
                  ],
                ),
              );
            } else {
              // Show full-height budget setup when no budget
              return Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    // Budget Summary Section (will show the call-to-action)
                    Expanded(
                      child: BudgetSummary(
                        onTap: () => _showBudgetEditDialog(context),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildExpensesSummaryByCategory(BuildContext context) {
    return BlocBuilder<ExpenseCubit, dynamic>(
      builder: (context, expenseState) {
        if (expenseState is ExpenseLoaded) {
          final expenseCubit = context.read<ExpenseCubit>();
          final expenses = expenseCubit.expenses;

          if (expenses.isEmpty) {
            return const SizedBox.shrink();
          }

          // Group expenses by category
          final Map<String, List<dynamic>> expensesByCategory = {};
          for (final expense in expenses) {
            if (expensesByCategory.containsKey(expense.category)) {
              expensesByCategory[expense.category]!.add(expense);
            } else {
              expensesByCategory[expense.category] = [expense];
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expenses by Category',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...expensesByCategory.entries.map((entry) {
                final category = entry.key;
                final categoryExpenses = entry.value;
                final totalAmount = categoryExpenses.fold<double>(
                  0.0,
                  (sum, expense) => sum + expense.amount,
                );

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Category icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: CategoryHelpers.getCategoryColor(category)
                                .withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.small),
                            border: Border.all(
                              color: CategoryHelpers.getCategoryColor(category)
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            CategoryHelpers.getCategoryIcon(category),
                            color: CategoryHelpers.getCategoryColor(category),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Category details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                '${categoryExpenses.length} expense${categoryExpenses.length == 1 ? '' : 's'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
