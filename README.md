# Monthly Expense Tracker

A comprehensive Flutter application for tracking monthly expenses with advanced features including budgets, analytics, and data export capabilities.

## Features

### 🏠 Dashboard
- Monthly expense overview
- Recent transactions display
- Budget progress tracking
- Quick expense entry

### 💰 Expense Management
- Add, edit, and delete expenses
- Categorize expenses with custom categories
- Add descriptions, locations, and tags
- Date-based filtering and sorting

### 📊 Budget System
- Create and manage budgets by category
- Set warning and danger thresholds
- Visual progress indicators
- Budget alerts and notifications

### 📈 Analytics & Reports
- Interactive charts using fl_chart
- Daily expense trends
- Category-wise spending analysis
- Monthly summaries and insights

### 📁 Data Management
- CSV export/import functionality
- Local data storage with Hive
- Backup and restore capabilities
- Custom category management

### 🔄 Recurring Transactions
- Set up recurring expenses
- Automatic transaction generation
- Flexible recurrence patterns (daily, weekly, monthly, yearly)

## Architecture

This project follows **Clean Architecture** principles with a feature-based folder structure:

```
lib/
├── core/                    # Core utilities and services
│   ├── constants/          # App constants
│   ├── errors/            # Error handling
│   ├── services/          # Core services (Hive, etc.)
│   └── utils/             # Utility functions
├── features/              # Feature modules
│   ├── expenses/          # Expense management
│   ├── budgets/           # Budget management
│   ├── analytics/         # Charts and analytics
│   └── settings/         # App settings
└── shared/               # Shared components
    ├── theme/            # App theming
    └── widgets/          # Reusable widgets
```

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Riverpod** - State management with providers
- **Hive** - Fast, lightweight local database
- **Freezed** - Immutable data classes with code generation
- **fl_chart** - Beautiful charts and graphs
- **CSV** - Data export/import functionality

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd monthly_expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Platform Support
- ✅ Android
- ✅ iOS  
- ✅ macOS
- ✅ Web (with limitations for file operations)

## Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9      # State management
  hive: ^2.2.3                   # Local storage
  hive_flutter: ^1.1.0          # Hive Flutter integration
  freezed: ^2.4.6               # Immutable data classes
  fl_chart: ^0.66.0             # Charts and graphs
  csv: ^6.0.0                   # CSV processing
  file_picker: ^6.1.1           # File selection
  path_provider: ^2.1.1         # File system access
  uuid: ^4.2.1                  # Unique ID generation
```

## Usage

### Adding Expenses
1. Navigate to the Expenses tab
2. Tap the + button
3. Fill in expense details (title, amount, category, date)
4. Save the expense

### Creating Budgets
1. Go to the Budgets tab
2. Tap the + button
3. Set budget name, amount, category, and date range
4. Configure warning and danger thresholds
5. Save the budget

### Viewing Analytics
1. Navigate to the Analytics tab
2. Select a month to view
3. Explore daily trends and category breakdowns
4. Use interactive charts for insights

### Exporting Data
1. Go to Settings
2. Use "Export Expenses to CSV" to download your data
3. Use "Import Expenses from CSV" to restore data

## Data Models

### ExpenseModel
```dart
class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String? description;
  final String? location;
  final List<String> tags;
  final bool isRecurring;
  final String? recurringId;
}
```

### BudgetModel
```dart
class BudgetModel {
  final String id;
  final String name;
  final double amount;
  final String categoryId;
  final DateTime startDate;
  final DateTime endDate;
  final double spent;
  final bool isActive;
  final double warningThreshold;
  final double dangerThreshold;
}
```

### CategoryModel
```dart
class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int color;
  final bool isDefault;
  final bool isIncome;
}
```

## State Management

The app uses **Riverpod** for state management with the following providers:

- `expenseNotifierProvider` - Manages expense state
- `categoryNotifierProvider` - Handles category operations
- `budgetNotifierProvider` - Manages budget state
- `analyticsProvider` - Provides analytics data

## Local Storage

**Hive** is used for local data persistence:

- Fast, lightweight NoSQL database
- Type-safe with generated adapters
- Cross-platform compatibility
- Automatic data serialization

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Roadmap

- [ ] Recurring transaction management UI
- [ ] Advanced filtering and search
- [ ] Data synchronization across devices
- [ ] Expense photo attachments
- [ ] Budget templates
- [ ] Spending goals and challenges
- [ ] Multi-currency support
- [ ] Dark mode improvements
- [ ] Widget support for quick expense entry

## Documentation

Comprehensive documentation is available:

- **[COMPLETE_ARCHITECTURE.md](COMPLETE_ARCHITECTURE.md)** - Full architecture documentation, data structures, and all features
- **[FEATURE_STATUS.md](FEATURE_STATUS.md)** - Detailed feature status dashboard and roadmap
- **[ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md)** - Visual architecture diagrams and data flows

## Support

For issues and questions:
1. Check the existing issues
2. Create a new issue with detailed description
3. Provide device and Flutter version information

---

**Built with ❤️ using Flutter**