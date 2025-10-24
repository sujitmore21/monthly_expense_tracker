import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/csv_provider.dart';

class ExportImportSection extends ConsumerWidget {
  const ExportImportSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final csvAsync = ref.watch(csvNotifierProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export & Import',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(csvNotifierProvider.notifier).exportExpenses();
                },
                icon: const Icon(Icons.download),
                label: const Text('Export Expenses to CSV'),
              ),
            ),
            const SizedBox(height: 8),

            // Import Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['csv'],
                  );

                  if (result != null && result.files.single.path != null) {
                    ref
                        .read(csvNotifierProvider.notifier)
                        .importExpenses(result.files.single.path!);
                  }
                },
                icon: const Icon(Icons.upload),
                label: const Text('Import Expenses from CSV'),
              ),
            ),
            const SizedBox(height: 16),

            // Status
            csvAsync.when(
              data: (message) {
                if (message != null) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.contains('successful')
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          message.contains('successful')
                              ? Icons.check_circle
                              : Icons.info,
                          color: message.contains('successful')
                              ? Colors.green
                              : Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            message.contains('successful')
                                ? 'Import completed successfully!'
                                : 'Export saved to: $message',
                            style: TextStyle(
                              color: message.contains('successful')
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Processing...'),
                ],
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
