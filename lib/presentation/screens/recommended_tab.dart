import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/recommended_cubit.dart';
import '../theme/theme_constants.dart';
import '../../core/helpers/category_helpers.dart';
import '../../data/models/expense_category.dart';
import '../../dependencyInjection/service_locator.dart';
import '../../presentation/widgets/expense_category_item.dart';

class RecommendedTab extends StatefulWidget {
  const RecommendedTab({super.key});

  @override
  State<RecommendedTab> createState() => _RecommendedTabState();
}

class _RecommendedTabState extends State<RecommendedTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecommendedCubit>(),
      child: const _RecommendedTabContent(),
    );
  }
}

class _RecommendedTabContent extends StatefulWidget {
  const _RecommendedTabContent();

  @override
  State<_RecommendedTabContent> createState() => _RecommendedTabContentState();
}

class _RecommendedTabContentState extends State<_RecommendedTabContent> {
  late final RecommendedCubit _recommendedCubit;

  @override
  void initState() {
    super.initState();
    // Automatically fetch categories when tab is first accessed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _recommendedCubit = context.read<RecommendedCubit>();
        _recommendedCubit.fetchExpenseCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Expenses'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          // Reload button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _recommendedCubit.fetchExpenseCategories();
            },
            tooltip: 'Reload Categories',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.background(context),
        ),
        child: BlocBuilder<RecommendedCubit, RecommendedState>(
          builder: (context, state) {
            if (state is RecommendedLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is RecommendedError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _recommendedCubit.fetchExpenseCategories();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is RecommendedLoaded) {
              return _buildCategoriesList(context, state.expenseCategories);
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Categories Available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Categories will appear here once loaded',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _recommendedCubit.fetchExpenseCategories();
                      },
                      child: const Text('Load Categories'),
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

  Widget _buildCategoriesList(
      BuildContext context, List<ExpenseCategory> categories) {
    // Separate fixed and non-fixed categories
    final fixedCategories = categories.where((cat) => cat.isFixed).toList();
    final nonFixedCategories = categories.where((cat) => !cat.isFixed).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Categories Section
          if (fixedCategories.isNotEmpty) ...[
            _buildSectionHeader('Fixed Categories', Icons.lock, Colors.blue),
            const SizedBox(height: AppSpacing.md),
            ...fixedCategories.map((category) => _buildCategoryCard(category)),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Non-Fixed Categories Section
          if (nonFixedCategories.isNotEmpty) ...[
            _buildSectionHeader(
                'Flexible Categories', Icons.category, Colors.green),
            const SizedBox(height: AppSpacing.md),
            ...nonFixedCategories
                .map((category) => _buildCategoryCard(category)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(ExpenseCategory category) {
    return ExpenseCategoryItem(
      category: category,
      onTap: () {
        // Handle category tap if needed
      },
    );
  }
}
