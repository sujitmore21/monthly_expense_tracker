# 🏗️ Monthly Expense Tracker - Architecture Diagrams

## 📐 System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Monthly Expense Tracker                       │
│                                                                       │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    Presentation Layer                           │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │  │
│  │  │Dashboard │  │ Expenses │  │ Budgets  │  │ Analytics│      │  │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘      │  │
│  │       │             │             │             │             │  │
│  │       └─────────────┴─────────────┴─────────────┘             │  │
│  │                          │                                      │  │
│  └──────────────────────────┼──────────────────────────────────────┘  │
│                             │                                         │
│  ┌──────────────────────────▼──────────────────────────────────────┐  │
│  │                    State Management (Riverpod)                   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │  │
│  │  │Expense       │  │Budget        │  │Analytics     │          │  │
│  │  │Providers     │  │Providers     │  │Providers     │          │  │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │  │
│  └─────────┼──────────────────┼──────────────────┼─────────────────┘  │
│            │                  │                  │                     │
│  ┌─────────▼──────────────────▼──────────────────▼─────────────────┐  │
│  │                    Business Logic Layer                          │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │  │
│  │  │Expense       │  │Budget        │  │Recurring     │          │  │
│  │  │Repository    │  │Repository    │  │Service       │          │  │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │  │
│  └─────────┼──────────────────┼──────────────────┼─────────────────┘  │
│            │                  │                  │                     │
│  ┌─────────▼──────────────────▼──────────────────▼─────────────────┐  │
│  │                    Data Access Layer                             │
│  │  ┌──────────────────────────────────────────────────────────┐   │  │
│  │  │                      Hive Service                         │   │  │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐              │   │  │
│  │  │  │Expenses  │  │Categories│  │Budgets   │              │   │  │
│  │  │  │Box       │  │Box       │  │Box       │              │   │  │
│  │  │  └──────────┘  └──────────┘  └──────────┘              │   │  │
│  │  └──────────────────────────────────────────────────────────┘   │  │
│  └───────────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow Diagram

### Adding an Expense

```
┌─────────────────────────────────────────────────────────────────┐
│  User Input: Add Expense Form                                    │
│  - Title, Amount, Category, Date, Description                    │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  AddExpensePage (ConsumerStatefulWidget)                         │
│  - Form validation                                               │
│  - Collects input data                                           │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  ref.read(expenseNotifierProvider.notifier).addExpense(expense) │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  ExpenseNotifier (StateNotifier)                                 │
│  - Validates business rules                                      │
│  - Calls repository                                              │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  ExpenseRepository.addExpense(expense)                           │
│  - Creates ExpenseModel                                          │
│  - Stores in Hive                                                │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  Hive Box Storage                                                │
│  await Hive.box<ExpenseModel>('expenses').put(id, expense)      │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  State Update                                                    │
│  - Notifier updates state                                        │
│  - Providers refresh                                             │
│  - UI rebuilds automatically                                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗂️ Repository Pattern

### Expense Repository Structure

```
┌───────────────────────────────────────────────────────┐
│              ExpenseRepository                         │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │  // Data Source Access                          │ │
│  │  Box<ExpenseModel> get _box =>                  │ │
│  │    Hive.box<ExpenseModel>('expenses')          │ │
│  └─────────────────────────────────────────────────┘ │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │  // CRUD Operations                             │ │
│  │  • Future<void> addExpense(ExpenseModel)       │ │
│  │  • Future<void> updateExpense(ExpenseModel)    │ │
│  │  • Future<void> deleteExpense(String id)       │ │
│  │  • Future<List<ExpenseModel>> getAllExpenses() │ │
│  └─────────────────────────────────────────────────┘ │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │  // Query Operations                            │ │
│  │  • getExpensesByDateRange(start, end)          │ │
│  │  • getExpensesByCategory(categoryId)           │ │
│  │  • searchExpenses(query)                       │ │
│  └─────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────┘
```

---

## 🎯 State Management Flow

### Riverpod Provider Hierarchy

```
┌──────────────────────────────────────────────────────────────────────┐
│                         Provider Hierarchy                            │
│                                                                        │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  Repository Providers (Singleton)                               │  │
│  │  ┌────────────────────┐  ┌────────────────────┐                │  │
│  │  │expenseRepository   │  │budgetRepository    │                │  │
│  │  │Provider            │  │Provider            │                │  │
│  │  └──────────┬─────────┘  └──────────┬─────────┘                │  │
│  └─────────────┼────────────────────────┼──────────────────────────┘  │
│                │                        │                              │
│  ┌─────────────▼────────────────────────▼──────────────────────────┐  │
│  │  State Notifier Providers (Mutable State)                       │  │
│  │  ┌────────────────────┐  ┌────────────────────┐                │  │
│  │  │expenseNotifier     │  │budgetNotifier      │                │  │
│  │  │Provider            │  │Provider            │                │  │
│  │  │StateNotifier       │  │StateNotifier       │                │  │
│  │  └──────────┬─────────┘  └──────────┬─────────┘                │  │
│  └─────────────┼────────────────────────┼──────────────────────────┘  │
│                │                        │                              │
│  ┌─────────────▼────────────────────────▼──────────────────────────┐  │
│  │  Future Providers (Async Data)                                  │  │
│  │  ┌────────────────────┐  ┌────────────────────┐                │  │
│  │  │expensesProvider    │  │budgetsProvider     │                │  │
│  │  │FutureProvider      │  │FutureProvider      │                │  │
│  │  └──────────┬─────────┘  └──────────┬─────────┘                │  │
│  └─────────────┼────────────────────────┼──────────────────────────┘  │
│                │                        │                              │
│  ┌─────────────▼────────────────────────▼──────────────────────────┐  │
│  │  UI Consumers                                                    │  │
│  │  ┌────────────────────┐  ┌────────────────────┐                │  │
│  │  │DashboardPage       │  │ExpensesPage        │                │  │
│  │  │ConsumerWidget      │  │ConsumerWidget      │                │  │
│  │  │ref.watch()         │  │ref.watch()         │                │  │
│  │  └────────────────────┘  └────────────────────┘                │  │
│  └────────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Data Models Architecture

### Model Relationships

```
┌────────────────────────────────────────────────────────────────────┐
│                         Data Models                                 │
│                                                                      │
│  ┌─────────────────────┐      ┌─────────────────────┐             │
│  │   ExpenseModel      │      │   CategoryModel     │             │
│  │  ┌────────────────┐ │      │  ┌────────────────┐ │             │
│  │  │ id: String     │ │◄─────┤  │ id: String     │ │             │
│  │  │ title: String  │ │refers│  │ name: String   │ │             │
│  │  │ amount: double │ │ to   │  │ icon: String   │ │             │
│  │  │ categoryId     │─┘      │  │ color: int     │ │             │
│  │  │ date: DateTime │        │  │ isDefault      │ │             │
│  │  │ description    │        │  │ isIncome       │ │             │
│  │  │ location       │        │  └────────────────┘ │             │
│  │  │ tags           │        └─────────────────────┘             │
│  │  │ isRecurring    │                                           │
│  │  │ recurringId    │───┐                                       │
│  │  │ currency       │   │                                       │
│  │  └────────────────┘   │                                       │
│  └───────────────────────┘   │                                   │
│                              │                                   │
│  ┌───────────────────────────▼────────────────────────────────┐  │
│  │                                                              │  │
│  │  ┌─────────────────────┐      ┌─────────────────────────┐  │  │
│  │  │   BudgetModel       │      │RecurringTransactionModel│  │  │
│  │  │  ┌────────────────┐ │      │  ┌────────────────────┐ │  │  │
│  │  │  │ id: String     │ │      │  │ id: String         │ │  │  │
│  │  │  │ name: String   │ │      │  │ title: String      │ │  │  │
│  │  │  │ amount: double │ │      │  │ amount: double     │ │  │  │
│  │  │  │ categoryId     │◄┤      │  │ categoryId         │◄┤  │  │
│  │  │  │ startDate      │ │      │  │ recurrenceType     │ │  │  │
│  │  │  │ endDate        │ │      │  │ startDate          │ │  │  │
│  │  │  │ spent          │ │      │  │ endDate            │ │  │  │
│  │  │  │ warningThreshold│       │  │ isActive           │ │  │  │
│  │  │  │ dangerThreshold│        │  │ dayOfMonth         │ │  │  │
│  │  │  └────────────────┘        │  │ dayOfWeek          │ │  │  │
│  │  └────────────────────────────┘  │  └────────────────────┘ │  │
│  │                                  └─────────────────────────┘  │
│  │                                                               │
│  └───────────────────────────────────────────────────────────────┘
```

---

## 🔄 Recurring Transaction Flow

### Auto-Generation Process

```
┌─────────────────────────────────────────────────────────────────┐
│  App Launch                                                     │
│  AppInitializationService.initializeApp()                       │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  RecurringService.processRecurringTransactions()                │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  For each Active Recurring Transaction:                         │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  1. Get last processed date                              │ │
│  │  2. Calculate next occurrence                            │ │
│  │     • Daily:   lastDate + 1 day                         │ │
│  │     • Weekly:  lastDate + 7 days                        │ │
│  │     • Monthly: same day next month                      │ │
│  │     • Yearly:  same date next year                      │ │
│  └────────────────────┬──────────────────────────────────────┘ │
│                       │                                         │
│                       ▼                                         │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  3. Check if occurrence is due                           │ │
│  │     if (nextOccurrence <= today)                         │ │
│  └────────────────────┬──────────────────────────────────────┘ │
│                       │                                         │
│                       ▼                                         │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  4. Check if expense already exists                      │ │
│  │     Search by recurringId and date                       │ │
│  └────────────────────┬──────────────────────────────────────┘ │
│                       │                                         │
│                       ▼                                         │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  5. Create new Expense                                    │ │
│  │     ExpenseModel(                                         │ │
│  │       title: recurring.title                             │ │
│  │       amount: recurring.amount                           │ │
│  │       isRecurring: true                                  │ │
│  │       recurringId: recurring.id                          │ │
│  │     )                                                     │ │
│  └────────────────────┬──────────────────────────────────────┘ │
│                       │                                         │
│                       ▼                                         │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  6. Save to database                                      │ │
│  │     expenseRepository.addExpense(expense)                 │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

---

## 📊 Budget Monitoring Flow

### Budget Warning System

```
┌─────────────────────────────────────────────────────────────────┐
│  BudgetMonitoringService.checkBudgetWarnings()                  │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  Query Active Budgets                                           │
│  • Get all active budgets                                       │
│  • Calculate spent amounts                                      │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  Filter Budgets by Status:                                      │
│                                                                   │
│  ┌──────────────────────┐  ┌──────────────────────┐            │
│  │ Near Threshold       │  │ Exceeded             │            │
│  │ • spent >= warning%  │  │ • spent >= danger%   │            │
│  │ • spent < danger%    │  │                      │            │
│  └──────────┬───────────┘  └──────────┬───────────┘            │
│             │                         │                          │
└─────────────┼─────────────────────────┼──────────────────────────┘
              │                         │
              ▼                         ▼
┌─────────────────────────────────────────────────────────────────┐
│  For each budget in category:                                   │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  NotificationService.showBudgetWarningNotification()     │ │
│  │  • Create notification                                    │ │
│  │  • Set title: "Budget Warning: {budgetName}"            │ │
│  │  • Set body: "{percentage}% spent"                      │ │
│  │  • Schedule local notification                           │ │
│  └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗄️ Storage Architecture

### Hive Box Organization

```
┌─────────────────────────────────────────────────────────────────┐
│                        Hive Storage                              │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Box: expenses                                             │ │
│  │  Type: Box<ExpenseModel>                                   │ │
│  │  Adapter: ExpenseModelAdapter                              │ │
│  │  ├── Expense 1                                             │ │
│  │  ├── Expense 2                                             │ │
│  │  └── Expense N                                             │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Box: categories                                           │ │
│  │  Type: Box<CategoryModel>                                  │ │
│  │  Adapter: CategoryModelAdapter                             │ │
│  │  ├── Category 1 (Food)                                     │ │
│  │  ├── Category 2 (Transport)                                │ │
│  │  ├── Category 3 (Shopping)                                 │ │
│  │  └── Default Categories                                    │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Box: budgets                                              │ │
│  │  Type: Box<BudgetModel>                                    │ │
│  │  Adapter: BudgetModelAdapter                               │ │
│  │  ├── Budget 1                                              │ │
│  │  ├── Budget 2                                              │ │
│  │  └── Budget N                                              │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Box: recurring                                            │ │
│  │  Type: Box<RecurringTransactionModel>                      │ │
│  │  Adapter: RecurringTransactionModelAdapter                 │ │
│  │  ├── Recurring 1                                           │ │
│  │  ├── Recurring 2                                           │ │
│  │  └── Recurring N                                           │ │
│  └────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
```

---

## 🎨 UI Component Hierarchy

### Main Navigation Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                    ExpenseTrackerApp                              │
│                      MaterialApp                                  │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DashboardPage                                  │
│                  ConsumerStatefulWidget                           │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  BottomNavigationBar                                       │ │
│  │  ├── Dashboard Tab                                         │ │
│  │  ├── Expenses Tab                                          │ │
│  │  ├── Budgets Tab                                           │ │
│  │  ├── Analytics Tab                                         │ │
│  │  └── Settings Tab                                          │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  IndexedStack (Pages)                                            │
│  ├── DashboardHomePage                                           │
│  │   ├── Stats Cards                                            │
│  │   ├── Charts                                                 │
│  │   └── Recent Expenses                                        │
│  ├── ExpensesPage                                                │
│  │   ├── ExpenseListView                                        │
│  │   ├── Filter Controls                                        │
│  │   └── FAB → AddExpensePage                                   │
│  ├── BudgetsPage                                                 │
│  │   ├── BudgetListView                                         │
│  │   ├── BudgetCards                                            │
│  │   └── FAB → AddBudgetPage                                    │
│  ├── AnalyticsPage                                               │
│  │   ├── Monthly Overview                                       │
│  │   └── Trends                                                 │
│  └── SettingsPage                                                │
│       ├── Export/Import                                          │
│       └── Categories                                             │
└───────────────────────────────────────────────────────────────────┘
```

---

## 🔐 Service Layer Architecture

### Core Services

```
┌─────────────────────────────────────────────────────────────────┐
│                      Core Services                               │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  HiveService                                              │  │
│  │  • init() - Initialize database                           │  │
│  │  • Box accessors                                          │  │
│  │  • Adapter registration                                   │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  NotificationService                                      │  │
│  │  • initialize() - Setup notifications                      │  │
│  │  • showBudgetWarningNotification()                        │  │
│  │  • Request permissions                                    │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  RecurringService                                         │  │
│  │  • processRecurringTransactions()                         │  │
│  │  • createRecurringTransaction()                           │  │
│  │  • pause/resume transactions                              │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  BudgetMonitoringService                                  │  │
│  │  • checkBudgetWarnings()                                  │  │
│  │  • updateAllBudgetSpent()                                 │  │
│  │  • getBudgetSummary()                                     │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  CsvService                                               │  │
│  │  • exportExpensesToCsv()                                  │  │
│  │  • importExpensesFromCsv()                                │  │
│  │  • shareCsvFile()                                         │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  AppInitializationService                                 │  │
│  │  • initializeApp() - Called on startup                    │  │
│  │  • Process recurring transactions                         │  │
│  │  • Check budget warnings                                  │  │
│  └───────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────┘
```

---

## 📱 Feature Module Structure

### Clean Architecture per Feature

```
┌─────────────────────────────────────────────────────────────────┐
│                    Feature: Expenses                             │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Presentation Layer                                       │   │
│  │  ├── pages/                                              │   │
│  │  │   ├── expenses_page.dart                              │   │
│  │  │   ├── add_expense_page.dart                           │   │
│  │  │   └── dashboard_page.dart                             │   │
│  │  ├── providers/                                          │   │
│  │  │   ├── expense_provider.dart                           │   │
│  │  │   └── category_provider.dart                          │   │
│  │  └── widgets/                                            │   │
│  │      └── expense_list_item.dart                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                           │                                       │
│                           ▼                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Domain Layer                                             │   │
│  │  ├── entities/                                            │   │
│  │  │   └── expense_entity.dart                             │   │
│  │  ├── repositories/                                        │   │
│  │  │   └── expense_repository_interface.dart                │   │
│  │  └── usecases/                                            │   │
│  │      ├── add_expense_usecase.dart                         │   │
│  │      ├── get_expenses_usecase.dart                        │   │
│  │      └── delete_expense_usecase.dart                      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                           │                                       │
│                           ▼                                       │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Data Layer                                               │   │
│  │  ├── models/                                              │   │
│  │  │   ├── expense_model.dart                               │   │
│  │  │   ├── expense_model.freezed.dart                       │   │
│  │  │   └── expense_model.g.dart                             │   │
│  │  ├── repositories/                                        │   │
│  │  │   ├── expense_repository.dart                          │   │
│  │  │   └── category_repository.dart                         │   │
│  │  └── datasources/                                         │   │
│  │      ├── local_datasource.dart                            │   │
│  │      └── remote_datasource.dart (future)                  │   │
│  └──────────────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Dependency Injection

### Provider Setup

```dart
┌────────────────────────────────────────────────────────────┐
│  Repository Layer (Singleton)                              │
│                                                            │
│  final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {│
│    return ExpenseRepository();                             │
│  });                                                       │
│                                                            │
│  final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {│
│    return CategoryRepository();                            │
│  });                                                       │
└────────────────────────────────────────────────────────────┘
              │                      │
              ▼                      ▼
┌────────────────────────────────────────────────────────────┐
│  Notifier Layer (State Management)                         │
│                                                            │
│  final expenseNotifierProvider =                           │
│    StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {│
│      final repo = ref.watch(expenseRepositoryProvider);   │
│      return ExpenseNotifier(repo);                         │
│    });                                                     │
└────────────────────────────────────────────────────────────┘
              │
              ▼
┌────────────────────────────────────────────────────────────┐
│  Service Layer (Cross-cutting concerns)                    │
│                                                            │
│  final budgetMonitoringProvider = Provider<BudgetMonitoringService>((ref) {│
│    final budgetRepo = ref.read(budgetRepositoryProvider); │
│    return BudgetMonitoringService(budgetRepo, NotificationService());│
│  });                                                       │
└────────────────────────────────────────────────────────────┘
```

---

## 📊 Analytics Data Pipeline

### Chart Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│  User Request: View Analytics                                   │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  AnalyticsPage                                                  │
│  - User selects month/date range                                │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  FutureBuilder with async data                                 │
│  ref.watch(analyticsDataProvider(month))                       │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  Data Aggregation                                              │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │  1. Get expenses by date range                           │ │
│  │  2. Get categories                                       │ │
│  │  3. Group by category                                    │ │
│  │  4. Calculate totals                                     │ │
│  └──────────────────────────────────────────────────────────┘ │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│  Chart Components                                              │
│  ├── SpendingPieChart                                          │
│  │   └── Category breakdown                                   │
│  ├── SpendingTrendChart                                        │
│  │   └── Daily/weekly trends                                  │
│  └── MonthlySummary                                            │
│      └── Stats cards                                           │
└─────────────────────────────────────────────────────────────────┘
```

---

**End of Architecture Diagrams**
