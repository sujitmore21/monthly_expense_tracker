import 'package:flutter/material.dart';
import '../../data/models/budget_model.dart';

class BudgetProgressWidget extends StatelessWidget {
  final BudgetModel budget;
  final VoidCallback? onTap;

  const BudgetProgressWidget({super.key, required this.budget, this.onTap});

  @override
  Widget build(BuildContext context) {
    final spentPercentage = budget.spent / budget.amount;
    final remaining = budget.amount - budget.spent;
    final isOverBudget = spentPercentage >= 1.0;
    final isNearWarning = spentPercentage >= budget.warningThreshold;
    final isNearDanger = spentPercentage >= budget.dangerThreshold;

    Color progressColor;
    if (isOverBudget) {
      progressColor = Colors.red;
    } else if (isNearDanger) {
      progressColor = Colors.orange;
    } else if (isNearWarning) {
      progressColor = Colors.amber;
    } else {
      progressColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    budget.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: progressColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${(spentPercentage * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: progressColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: spentPercentage.clamp(0.0, 1.0),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spent: \$${budget.spent.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Budget: \$${budget.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isOverBudget)
                        Text(
                          'Over by \$${(-remaining).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          'Remaining: \$${remaining.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (isNearWarning && !isOverBudget)
                        Text(
                          isNearDanger ? 'Danger Zone!' : 'Warning Zone',
                          style: TextStyle(
                            color: progressColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
