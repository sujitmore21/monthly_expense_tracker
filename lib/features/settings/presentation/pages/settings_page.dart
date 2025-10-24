import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/csv_provider.dart';
import '../widgets/export_import_section.dart';
import '../widgets/categories_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Export/Import Section
          const ExportImportSection(),
          const SizedBox(height: 24),

          // Categories Section
          const CategoriesSection(),
          const SizedBox(height: 24),

          // App Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.description),
                    title: Text('Monthly Expense Tracker'),
                    subtitle: Text('Track your expenses and manage budgets'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
