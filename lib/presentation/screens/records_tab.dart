import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/expense.dart';
import '../blocs/expense_cubit.dart';
import '../blocs/budget_cubit.dart';
import '../theme/theme_constants.dart';
import '../widgets/expense_item.dart';
import '../../dependencyInjection/service_locator.dart';
import '../../core/router/app_router.dart';

class RecordsTab extends StatelessWidget {
  const RecordsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BudgetCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ExpenseCubit>(),
        ),
      ],
      child: const _RecordsTabContent(),
    );
  }
}

class _RecordsTabContent extends StatefulWidget {
  const _RecordsTabContent();

  @override
  State<_RecordsTabContent> createState() => _RecordsTabContentState();
}

class _RecordsTabContentState extends State<_RecordsTabContent> {
  late final AppRouter _appRouter;
  String _sortBy = 'date'; // 'date' or 'amount'
  bool _sortAscending =
      false; // false = newest/highest first, true = oldest/lowest first
  String? _selectedCategory; // null means show all categories

  @override
  void initState() {
    super.initState();
    // Get the app router instance from service locator
    _appRouter = getIt<AppRouter>();

    // Initialize expenses when the tab is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final expenseCubit = context.read<ExpenseCubit>();
        expenseCubit.initializeExpenses();
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Expenses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Sort by options
            Text(
              'Sort by:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),

            // Date option
            RadioListTile<String>(
              title: const Text('Date'),
              value: 'date',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.pop(context);
              },
              activeColor: AppColors.primary,
            ),

            // Amount option
            RadioListTile<String>(
              title: const Text('Amount'),
              value: 'amount',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.pop(context);
              },
              activeColor: AppColors.primary,
            ),

            const SizedBox(height: 20),

            // Sort order options
            Text(
              'Sort order:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),

            // Ascending/Descending options
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sortAscending = true;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _sortAscending ? AppColors.primary : Colors.grey[300],
                      foregroundColor:
                          _sortAscending ? Colors.white : Colors.grey[700],
                    ),
                    child: const Text('Oldest/Lowest First'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sortAscending = false;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_sortAscending
                          ? AppColors.primary
                          : Colors.grey[300],
                      foregroundColor:
                          !_sortAscending ? Colors.white : Colors.grey[700],
                    ),
                    child: const Text('Newest/Highest First'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Reset to default button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _sortBy = 'date';
                    _sortAscending = false;
                  });
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                ),
                child: const Text('Reset to Default (Newest First)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Expense> _sortExpenses(List<Expense> expenses) {
    final sortedExpenses = List<Expense>.from(expenses);

    if (_sortBy == 'date') {
      if (_sortAscending) {
        sortedExpenses.sort((a, b) => a.date.compareTo(b.date)); // Oldest first
      } else {
        sortedExpenses.sort((a, b) => b.date.compareTo(a.date)); // Newest first
      }
    } else if (_sortBy == 'amount') {
      if (_sortAscending) {
        sortedExpenses
            .sort((a, b) => a.amount.compareTo(b.amount)); // Lowest first
      } else {
        sortedExpenses
            .sort((a, b) => b.amount.compareTo(a.amount)); // Highest first
      }
    }

    return sortedExpenses;
  }

  List<String> _getUniqueCategories(List<Expense> expenses) {
    final categories = expenses.map((e) => e.category).toSet().toList();
    categories.sort(); // Sort alphabetically
    return categories;
  }

  List<Expense> _filterExpensesByCategory(List<Expense> expenses) {
    if (_selectedCategory == null) {
      return expenses; // Show all categories
    }
    return expenses
        .where((expense) => expense.category == _selectedCategory)
        .toList();
  }

  void _showEditExpenseDialog(BuildContext context, Expense expense) {
    // TODO: Implement edit expense dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit expense: ${expense.title}'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  void _navigateToAddExpenses() {
    _appRouter.push(const AddExpensesRoute());
  }

  void _showDeleteExpenseDialog(BuildContext context, Expense expense) {
    // Get the cubits from the parent context before showing the dialog
    final expenseCubit = context.read<ExpenseCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Expense'),
          content: Text('Are you sure you want to delete "${expense.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                expenseCubit.deleteExpense(expense.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Records'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddExpenses,
            tooltip: 'Add New Expense',
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.sort),
                if (_sortBy != 'date' || _sortAscending != false)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showSortOptions,
            tooltip: 'Sort Expenses',
          ),
        ],
      ),
      body: BlocConsumer<ExpenseCubit, ExpenseState>(
        listener: (context, state) {
          // Handle state changes
        },
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading expenses...'),
                ],
              ),
            );
          } else if (state is ExpenseError) {
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
                    'Error Loading Expenses',
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
                      context.read<ExpenseCubit>().initializeExpenses();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ExpenseLoaded) {
            final expenses = state.expenses;

            if (expenses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Expenses Recorded',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your expenses will appear here once you add them',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Sort expenses by date (newest first)
            final sortedExpenses = _sortExpenses(expenses);

            // Filter expenses by selected category
            final filteredAndSortedExpenses =
                _filterExpensesByCategory(sortedExpenses);

            // Check if filtered results are empty
            if (filteredAndSortedExpenses.isEmpty &&
                _selectedCategory != null) {
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
                      'No Expenses in $_selectedCategory',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try selecting a different category or clear the filter',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                        });
                      },
                      child: const Text('Clear Filter'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Summary header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedCategory != null
                                    ? 'Expenses in $_selectedCategory'
                                    : 'Total Expenses',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '\$${filteredAndSortedExpenses.fold<double>(0.0, (sum, expense) => sum + expense.amount).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${filteredAndSortedExpenses.length} expense${filteredAndSortedExpenses.length == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Sort indicator
                      Row(
                        children: [
                          Icon(
                            _sortBy == 'date'
                                ? Icons.calendar_today
                                : Icons.attach_money,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Sorted by ${_sortBy == 'date' ? 'Date' : 'Amount'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _sortAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          Text(
                            _sortAscending
                                ? (_sortBy == 'date'
                                    ? 'Oldest First'
                                    : 'Lowest First')
                                : (_sortBy == 'date'
                                    ? 'Newest First'
                                    : 'Highest First'),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Category filter dropdown
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter by Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.medium),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          hintText: 'All Categories',
                          suffixIcon: _selectedCategory != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _selectedCategory = null;
                                    });
                                  },
                                  tooltip: 'Clear Filter',
                                )
                              : null,
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Categories'),
                          ),
                          ..._getUniqueCategories(expenses).map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Expenses list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: filteredAndSortedExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredAndSortedExpenses[index];
                      return ExpenseItem(
                        expense: expense,
                        onEdit: () => _showEditExpenseDialog(context, expense),
                        onDelete: () =>
                            _showDeleteExpenseDialog(context, expense),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No expenses loaded'),
            );
          }
        },
      ),
    );
  }
}
