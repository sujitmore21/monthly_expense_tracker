import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../expenses/presentation/providers/category_provider.dart';
import '../../../expenses/data/models/category_model.dart';
import 'add_category_dialog.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddCategoryDialog(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Category'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            categoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return const Text('No categories found');
                }

                return Column(
                  children: categories.map((category) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(category.color),
                        child: Text(
                          category.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      title: Text(category.name),
                      subtitle: Text(category.isIncome ? 'Income' : 'Expense'),
                      trailing: category.isDefault
                          ? const Icon(Icons.lock, color: Colors.grey)
                          : IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteDialog(context, ref, category);
                              },
                            ),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    CategoryModel category,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(categoryNotifierProvider.notifier)
                  .deleteCategory(category.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
