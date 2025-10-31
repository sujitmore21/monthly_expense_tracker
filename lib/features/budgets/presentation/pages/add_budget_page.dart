import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/budget_model.dart';
import '../providers/budget_provider.dart';
import '../../../expenses/presentation/providers/category_provider.dart';

class AddBudgetPage extends ConsumerStatefulWidget {
  const AddBudgetPage({super.key});

  @override
  ConsumerState<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends ConsumerState<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  String? _selectedCategoryId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  double _warningThreshold = 0.8;
  double _dangerThreshold = 1.0;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(expenseCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget'),
        actions: [
          TextButton(onPressed: _saveBudget, child: const Text('Save')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Budget Name',
                  hintText: 'Enter budget name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Budget Amount',
                  hintText: '0.00',
                  prefixText: '₹',
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

              // Start Date
              InkWell(
                onTap: () => _selectStartDate(),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  child: Text(
                    '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // End Date
              InkWell(
                onTap: () => _selectEndDate(),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'End Date'),
                  child: Text(
                    '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Warning Threshold
              Text(
                'Warning Threshold: ${(_warningThreshold * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Slider(
                value: _warningThreshold,
                min: 0.5,
                max: 0.9,
                divisions: 8,
                onChanged: (value) {
                  setState(() {
                    _warningThreshold = value;
                    if (_dangerThreshold <= value) {
                      _dangerThreshold = value + 0.1;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              // Danger Threshold
              Text(
                'Danger Threshold: ${(_dangerThreshold * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Slider(
                value: _dangerThreshold,
                min: _warningThreshold + 0.1,
                max: 1.0,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _dangerThreshold = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _startDate = date;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      final budget = BudgetModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        categoryId: _selectedCategoryId!,
        startDate: _startDate,
        endDate: _endDate,
        warningThreshold: _warningThreshold,
        dangerThreshold: _dangerThreshold,
      );

      ref.read(budgetNotifierProvider.notifier).addBudget(budget);
      Navigator.of(context).pop();
    }
  }
}
