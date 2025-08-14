import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_constants.dart';

class BudgetEditDialog extends StatefulWidget {
  final double? currentBudget;
  final String month;
  final int year;

  const BudgetEditDialog({
    super.key,
    this.currentBudget,
    required this.month,
    required this.year,
  });

  @override
  State<BudgetEditDialog> createState() => _BudgetEditDialogState();
}

class _BudgetEditDialogState extends State<BudgetEditDialog> {
  late TextEditingController _budgetController;
  late FocusNode _budgetFocusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(
      text: widget.currentBudget?.toStringAsFixed(2) ?? '',
    );
    _budgetFocusNode = FocusNode();

    // Focus the text field when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _budgetFocusNode.requestFocus();
      _budgetController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _budgetController.text.length,
      );
    });
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _budgetFocusNode.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final budgetText = _budgetController.text.trim();

    if (budgetText.isEmpty) {
      setState(() {
        _errorText = 'Please enter a budget amount';
      });
      return;
    }

    final budget = double.tryParse(budgetText);
    if (budget == null) {
      setState(() {
        _errorText = 'Please enter a valid number';
      });
      return;
    }

    if (budget <= 0) {
      setState(() {
        _errorText = 'Budget must be greater than 0';
      });
      return;
    }

    if (budget > 1000000) {
      setState(() {
        _errorText = 'Budget cannot exceed \$1,000,000';
      });
      return;
    }

    // Valid budget, close dialog with result
    Navigator.of(context).pop(budget);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.currentBudget != null
                        ? 'Edit Monthly Budget'
                        : 'Set Monthly Budget',
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.month} ${widget.year}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Budget input field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Budget Amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _budgetController,
                  focusNode: _budgetFocusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.medium),
                      borderSide: BorderSide(
                        color:
                            _errorText != null ? Colors.red : Colors.grey[400]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.medium),
                      borderSide: BorderSide(
                        color:
                            _errorText != null ? Colors.red : AppColors.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppBorderRadius.medium),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: Icon(
                      Icons.attach_money,
                      color: _errorText != null ? Colors.red : Colors.grey[400],
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    if (_errorText != null) {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
                  onFieldSubmitted: (_) => _validateAndSubmit(),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorText!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Quick budget suggestions
            Text(
              'Quick Budget Options',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickBudgetButton('1K', 1000),
                _buildQuickBudgetButton('2K', 2000),
                _buildQuickBudgetButton('3K', 3000),
                _buildQuickBudgetButton('5K', 5000),
                _buildQuickBudgetButton('10K', 10000),
                _buildQuickBudgetButton('15K', 15000),
              ],
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.medium),
                      ),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.medium),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      widget.currentBudget != null ? 'Update' : 'Set Budget',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickBudgetButton(String label, double amount) {
    return InkWell(
      onTap: () {
        _budgetController.text = amount.toStringAsFixed(2);
        if (_errorText != null) {
          setState(() {
            _errorText = null;
          });
        }
      },
      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          '\$$label',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
