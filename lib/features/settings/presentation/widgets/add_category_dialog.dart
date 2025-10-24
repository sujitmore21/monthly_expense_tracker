import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../expenses/data/models/category_model.dart';
import '../../../expenses/presentation/providers/category_provider.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _iconController = TextEditingController();

  bool _isIncome = false;
  Color _selectedColor = Colors.blue;

  final List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
    Colors.grey,
  ];

  final List<String> _availableIcons = [
    '🍽️',
    '🚗',
    '🛍️',
    '🎬',
    '💡',
    '🏥',
    '💰',
    '🏠',
    '📱',
    '🎮',
    '✈️',
    '🏋️',
    '📚',
    '🎵',
    '🍕',
    '☕',
    '🎁',
    '💊',
    '🔧',
    '🎯',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: SizedBox(
        width: 300,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'Enter category name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Icon
              TextFormField(
                controller: _iconController,
                decoration: const InputDecoration(
                  labelText: 'Icon',
                  hintText: 'Enter emoji or text',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an icon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Icon picker
              SizedBox(
                height: 100,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _availableIcons[index];
                    return GestureDetector(
                      onTap: () {
                        _iconController.text = icon;
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _iconController.text == icon
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Income/Expense toggle
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Expense'),
                      value: false,
                      groupValue: _isIncome,
                      onChanged: (value) {
                        setState(() {
                          _isIncome = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Income'),
                      value: true,
                      groupValue: _isIncome,
                      onChanged: (value) {
                        setState(() {
                          _isIncome = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Color picker
              Text('Color', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.black
                              : Colors.grey,
                          width: _selectedColor == color ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _saveCategory, child: const Text('Save')),
      ],
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final category = CategoryModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        icon: _iconController.text,
        color: _selectedColor.value,
        isIncome: _isIncome,
      );

      ref.read(categoryNotifierProvider.notifier).addCategory(category);
      Navigator.of(context).pop();
    }
  }
}
