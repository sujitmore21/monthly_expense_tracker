import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/hive_service.dart';
import 'core/services/app_initialization_service.dart';
import 'features/expenses/presentation/pages/expense_tracker_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services
  await AppInitializationService.initializeApp();

  runApp(const ProviderScope(child: ExpenseTrackerApp()));
}
