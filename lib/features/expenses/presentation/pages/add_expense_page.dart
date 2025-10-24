import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/expense_model.dart';
import '../providers/expense_provider.dart';
import '../providers/category_provider.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  const AddExpensePage({super.key});

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(expenseCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          TextButton(onPressed: _saveExpense, child: const Text('Save')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter expense title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Row(
                        children: [
                          Text(category.icon),
                          const SizedBox(width: 8),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(height: 16),

              // Date
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date'),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (Optional)',
                  hintText: 'Enter location',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      final expense = ExpenseModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        location: _locationController.text.isEmpty
            ? null
            : _locationController.text,
      );

      ref.read(expenseNotifierProvider.notifier).addExpense(expense);
      Navigator.of(context).pop();
    }
  }
}
