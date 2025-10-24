import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/category_model.dart';
import '../providers/category_provider.dart';

class ExpenseListItem extends ConsumerWidget {
  final ExpenseModel expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ExpenseListItem({
    super.key,
    required this.expense,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: categoriesAsync.when(
            data: (categories) {
              final category = categories.firstWhere(
                (cat) => cat.id == expense.categoryId,
                orElse: () => const CategoryModel(
                  id: 'unknown',
                  name: 'Unknown',
                  icon: '❓',
                  color: 0xFF9E9E9E,
                ),
              );
              return Text(category.icon, style: const TextStyle(fontSize: 20));
            },
            loading: () => const Icon(Icons.receipt),
            error: (_, __) => const Icon(Icons.receipt),
          ),
        ),
        title: Text(expense.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (expense.description != null) Text(expense.description!),
            Text(
              expense.date.toString().split(' ')[0],
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Text(
          '\$${expense.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
