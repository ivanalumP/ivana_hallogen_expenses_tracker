import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/budget.dart';
import '../blocs/budget_cubit.dart';
import '../theme/theme_constants.dart';
import '../../services/hive_storage_service.dart';
import '../../dependencyInjection/service_locator.dart';

class BudgetSummary extends StatelessWidget {
  final VoidCallback? onTap;
  const BudgetSummary({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetCubit, BudgetState>(
      builder: (context, state) {
        if (state is BudgetLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BudgetLoaded) {
          return _buildBudgetCard(context, state.budget);
        } else if (state is BudgetError) {
          return _buildErrorCard(context, state.message);
        } else {
          return _buildDefaultCard(context);
        }
      },
    );
  }

  Widget _buildBudgetCard(BuildContext context, Budget budget) {
    final storageService = getIt<HiveStorageService>();
    final statistics = storageService.calculateBudgetStatistics();

    final progressColor = statistics.isBudgetExceeded
        ? Colors.red
        : statistics.isBudgetWarning
            ? Colors.orange
            : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month and Year Title above the card
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            '${budget.month} ${budget.year} Budget',
            style: AppTextStyles.heading.copyWith(
              fontSize: 20,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Budget Card
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.large)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress section
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: LinearProgressIndicator(
                    value:
                        _getSafeProgressValue(statistics.budgetUsagePercentage),
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_getSafePercentageText(statistics.budgetUsagePercentage)}% used',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Budget details grid - ListView form
                Column(
                  children: [
                    _buildBudgetDetailRow(
                      'Monthly Budget',
                      statistics.monthlyBudget.toStringAsFixed(2),
                      Icons.account_balance_wallet,
                      AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    _buildBudgetDetailRow(
                      'Total Spent',
                      statistics.totalSpent.toStringAsFixed(2),
                      Icons.shopping_cart,
                      Colors.red,
                    ),
                    const SizedBox(height: 12),
                    _buildBudgetDetailRow(
                      'Budget Left',
                      statistics.budgetLeft.toStringAsFixed(2),
                      Icons.savings,
                      Colors.green,
                    ),
                  ],
                ),

                // Edit budget button
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Budget'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.medium),
                      ),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetDetailRow(
      String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.small),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        Text(
          '\$$value',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height *
          0.6, // Full height for main content
      decoration: BoxDecoration(
        gradient: AppGradients.background(context),
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Budget Set',
              style: AppTextStyles.heading.copyWith(
                fontSize: 24,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Set your monthly budget to start tracking\nyour expenses and managing your finances.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  ),
                ),
                child: const Text(
                  'Set Budget',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String errorMessage) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.large)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Error Loading Budget',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Get safe progress value for LinearProgressIndicator (0.0 to 1.0)
  double _getSafeProgressValue(double percentage) {
    if (percentage.isNaN || percentage.isInfinite) {
      return 0.0;
    }
    // Ensure value is between 0.0 and 1.0
    return (percentage / 100).clamp(0.0, 1.0);
  }

  /// Get safe percentage text
  String _getSafePercentageText(double percentage) {
    if (percentage.isNaN || percentage.isInfinite) {
      return '0.0';
    }
    return percentage.toStringAsFixed(1);
  }
}
