import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../blocs/add_expense_category_cubit.dart';
import '../blocs/add_expense_form_cubit.dart';
import '../blocs/expense_cubit.dart';
import '../blocs/budget_cubit.dart';
import '../theme/theme_constants.dart';
import '../../dependencyInjection/service_locator.dart';
import '../../core/router/app_router.dart';
import '../../data/models/expense.dart';
import '../../services/hive_storage_service.dart';

@RoutePage()
class AddExpensesScreen extends StatelessWidget {
  const AddExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AddExpenseCategoryCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<AddExpenseFormCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<ExpenseCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<BudgetCubit>(),
        ),
      ],
      child: const _AddExpensesScreenContent(),
    );
  }
}

class _AddExpensesScreenContent extends StatefulWidget {
  const _AddExpensesScreenContent();

  @override
  State<_AddExpensesScreenContent> createState() =>
      _AddExpensesScreenContentState();
}

class _AddExpensesScreenContentState extends State<_AddExpensesScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listener to amount controller to update cubit
    _amountController.addListener(() {
      if (mounted) {
        final formCubit = context.read<AddExpenseFormCubit>();
        formCubit.updateAmount(_amountController.text);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AddExpenseCategoryCubit>().fetchExpenseCategories();
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final formCubit = context.read<AddExpenseFormCubit>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: formCubit.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != formCubit.selectedDate) {
      formCubit.updateDate(picked);
    }
  }

  void _saveExpense() {
    final formCubit = context.read<AddExpenseFormCubit>();
    if (_formKey.currentState!.validate() &&
        formCubit.selectedCategory != null) {
      // Create the expense object
      final expense = Expense(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Generate unique ID
        title: formCubit.selectedCategory!, // Use category as title for now
        amount: double.parse(formCubit.amount),
        category: formCubit.selectedCategory!,
        date: formCubit.selectedDate,
        description: formCubit.notes,
      );

      // Save the expense using ExpenseCubit singleton
      final expenseCubit = getIt<ExpenseCubit>();
      expenseCubit.addExpense(expense);

      // Update the budget using BudgetCubit singleton
      final budgetCubit = getIt<BudgetCubit>();
      budgetCubit.addExpense(expense.amount);

      // Update local storage with new category if it doesn't exist
      final storageService = getIt<HiveStorageService>();
      final existingCategories = storageService.getCategories();
      if (!existingCategories.contains(formCubit.selectedCategory!)) {
        existingCategories.add(formCubit.selectedCategory!);
        storageService.saveCategories(existingCategories);
      }

      // Reset the form
      formCubit.resetForm();
      _amountController.clear();
      _notesController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense added successfully! Budget updated.'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          ),
        ),
      );

      // Navigate back
      getIt<AppRouter>().maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.background(context),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Dropdown
                      Text('Category',
                          style: AppTextStyles.heading.copyWith(
                              fontSize: 16, color: AppColors.primary)),
                      const SizedBox(height: AppSpacing.sm),
                      BlocBuilder<AddExpenseCategoryCubit,
                          AddExpenseCategoryState>(
                        builder: (context, state) {
                          if (state is AddExpenseCategoryLoading) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.medium),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Loading categories...'),
                                ],
                              ),
                            );
                          } else if (state is AddExpenseCategoryLoaded) {
                            final categories = state.expenseCategories
                                .map((cat) => cat.name)
                                .toList();

                            return BlocBuilder<AddExpenseFormCubit,
                                AddExpenseFormState>(
                              builder: (context, formState) {
                                return DropdownButtonFormField<String>(
                                  value: formState.selectedCategory,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppBorderRadius.medium)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    hintText: 'Select a category',
                                  ),
                                  items: categories.map((String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    final formCubit =
                                        context.read<AddExpenseFormCubit>();
                                    formCubit.updateCategory(newValue);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a category';
                                    }
                                    return null;
                                  },
                                );
                              },
                            );
                          } else if (state is AddExpenseCategoryError) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red[400]!),
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.medium),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red[400], size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Failed to load categories: ${state.message}',
                                      style: TextStyle(color: Colors.red[600]),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.medium),
                              ),
                              child: const Text('No categories available'),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Amount Input
                      Text('Amount',
                          style: AppTextStyles.heading.copyWith(
                              fontSize: 16, color: AppColors.primary)),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'))
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppBorderRadius.medium)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          prefixText: '\$ ',
                          hintText: '0.00',
                        ),
                        onChanged: (value) {
                          final formCubit = context.read<AddExpenseFormCubit>();
                          formCubit.updateAmount(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid amount';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Amount must be greater than 0';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Date Input
                      Text('Date',
                          style: AppTextStyles.heading.copyWith(
                              fontSize: 16, color: AppColors.primary)),
                      const SizedBox(height: AppSpacing.sm),
                      InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.medium),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.medium),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 12),
                              BlocBuilder<AddExpenseFormCubit,
                                  AddExpenseFormState>(
                                builder: (context, formState) {
                                  return Text(
                                      '${formState.selectedDate.day}/${formState.selectedDate.month}/${formState.selectedDate.year}',
                                      style: const TextStyle(fontSize: 16));
                                },
                              ),
                              const Spacer(),
                              Icon(Icons.arrow_drop_down,
                                  color: Colors.grey[600]),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Notes Input
                      Text('Notes (Optional)',
                          style: AppTextStyles.heading.copyWith(
                              fontSize: 16, color: AppColors.primary)),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppBorderRadius.medium)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          hintText: 'Add any additional notes...',
                        ),
                        onChanged: (value) {
                          final formCubit = context.read<AddExpenseFormCubit>();
                          formCubit.updateNotes(value);
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
            // Save Button at bottom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: BlocBuilder<AddExpenseFormCubit, AddExpenseFormState>(
                builder: (context, formState) {
                  return ElevatedButton(
                    onPressed: formState.isFormValid ? _saveExpense : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: formState.isFormValid
                          ? AppColors.primary
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.medium)),
                    ),
                    child: Text(
                      'Save Expense',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: formState.isFormValid
                            ? Colors.white
                            : Colors.white70,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
