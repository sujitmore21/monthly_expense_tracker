import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/notification_service.dart';
import '../../../budgets/data/models/budget_model.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  bool _budgetWarningsEnabled = true;
  bool _billRemindersEnabled = true;
  bool _dailySpendingEnabled = false;
  bool _weeklyReportsEnabled = true;
  bool _monthlyReportsEnabled = true;

  int _budgetWarningThreshold = 80;
  int _billReminderDays = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Budget Notifications'),
          _buildSwitchTile(
            title: 'Budget Warnings',
            subtitle:
                'Get notified when you approach or exceed your budget limits',
            value: _budgetWarningsEnabled,
            onChanged: (value) =>
                setState(() => _budgetWarningsEnabled = value),
          ),
          if (_budgetWarningsEnabled) ...[
            _buildSliderTile(
              title: 'Warning Threshold',
              subtitle:
                  'Get notified when you reach this percentage of your budget',
              value: _budgetWarningThreshold.toDouble(),
              min: 50,
              max: 100,
              divisions: 10,
              onChanged: (value) =>
                  setState(() => _budgetWarningThreshold = value.round()),
            ),
          ],
          const SizedBox(height: 16),
          _buildSectionHeader('Bill Reminders'),
          _buildSwitchTile(
            title: 'Bill Reminders',
            subtitle: 'Get reminded about upcoming recurring bills',
            value: _billRemindersEnabled,
            onChanged: (value) => setState(() => _billRemindersEnabled = value),
          ),
          if (_billRemindersEnabled) ...[
            _buildSliderTile(
              title: 'Reminder Days',
              subtitle: 'How many days before the due date to remind you',
              value: _billReminderDays.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              onChanged: (value) =>
                  setState(() => _billReminderDays = value.round()),
            ),
          ],
          const SizedBox(height: 16),
          _buildSectionHeader('Reports & Insights'),
          _buildSwitchTile(
            title: 'Daily Spending Summary',
            subtitle: 'Get a daily summary of your spending',
            value: _dailySpendingEnabled,
            onChanged: (value) => setState(() => _dailySpendingEnabled = value),
          ),
          _buildSwitchTile(
            title: 'Weekly Reports',
            subtitle: 'Get weekly spending reports and insights',
            value: _weeklyReportsEnabled,
            onChanged: (value) => setState(() => _weeklyReportsEnabled = value),
          ),
          _buildSwitchTile(
            title: 'Monthly Reports',
            subtitle: 'Get monthly spending summaries and budget analysis',
            value: _monthlyReportsEnabled,
            onChanged: (value) =>
                setState(() => _monthlyReportsEnabled = value),
          ),
          const SizedBox(height: 32),
          _buildTestNotificationButton(),
          const SizedBox(height: 16),
          _buildNotificationInfo(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        secondary: Icon(
          value ? Icons.notifications_active : Icons.notifications_off,
          color: value ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: onChanged,
                  ),
                ),
                Text(
                  '${value.round()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestNotificationButton() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Test Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Test your notification settings to make sure they work properly.',
              style: TextStyle(color: Colors.blue[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testBudgetWarning,
                    icon: const Icon(Icons.warning),
                    label: const Text('Test Budget Warning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testBillReminder,
                    icon: const Icon(Icons.schedule),
                    label: const Text('Test Bill Reminder'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
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

  Widget _buildNotificationInfo() {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  'Notification Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Notifications are sent locally on your device\n'
              '• You can disable notifications in your device settings\n'
              '• Budget warnings are sent when you reach your threshold\n'
              '• Bill reminders are sent before due dates\n'
              '• Reports are sent at the end of each period',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testBudgetWarning() async {
    try {
      // Create a mock budget for testing
      final mockBudget = BudgetModel(
        id: 'test_budget',
        name: 'Test Budget',
        amount: 1000.0,
        categoryId: 'test_category',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        spent: 850.0, // 85% spent
        isActive: true,
        warningThreshold: 0.8,
        dangerThreshold: 1.0,
      );

      await NotificationService.showBudgetWarningNotification(mockBudget);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test budget warning sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending test notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testBillReminder() async {
    try {
      await NotificationService.showBillReminderNotification(
        title: 'Test Bill',
        description: 'This is a test bill reminder',
        dueDate: DateTime.now().add(const Duration(days: 3)),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test bill reminder sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending test notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
