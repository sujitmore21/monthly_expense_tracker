import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../expenses/data/repositories/expense_repository.dart';
import '../../../expenses/data/repositories/category_repository.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../expenses/data/models/category_model.dart';
import '../widgets/spending_pie_chart.dart';
import '../widgets/spending_trend_chart.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedMonth = DateTime.now();
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Monthly Overview', icon: Icon(Icons.pie_chart)),
            Tab(text: 'Trends', icon: Icon(Icons.trending_up)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMonthlyOverview(), _buildTrendsView()],
      ),
    );
  }

  Widget _buildMonthlyOverview() {
    return FutureBuilder(
      future: _getMonthlyData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 48, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  'Error loading data',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final data = snapshot.data as Map<String, dynamic>;
        final expenses = data['expenses'] as List<ExpenseModel>;
        final categories = data['categories'] as List<CategoryModel>;

        return Column(
          children: [
            _buildMonthSelector(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMonthlySummary(expenses),
                    SpendingPieChart(
                      expenses: expenses,
                      categories: categories,
                      month: _selectedMonth,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrendsView() {
    return FutureBuilder(
      future: _getTrendsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 48, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  'Error loading data',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final data = snapshot.data as Map<String, dynamic>;
        final expenses = data['expenses'] as List<ExpenseModel>;

        return Column(
          children: [
            _buildDateRangeSelector(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTrendsSummary(expenses),
                    SpendingTrendChart(
                      expenses: expenses,
                      startDate: _startDate,
                      endDate: _endDate,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMonthSelector() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Month:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month - 1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  '${_selectedMonth.month}/${_selectedMonth.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month + 1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date Range:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    'Start Date',
                    _startDate,
                    (date) => setState(() => _startDate = date),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateButton(
                    'End Date',
                    _endDate,
                    (date) => setState(() => _endDate = date),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(
    String label,
    DateTime date,
    Function(DateTime) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              onChanged(selectedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Icon(Icons.calendar_today, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlySummary(expenses) {
    final totalSpending = expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final expenseCount = expenses.length;
    final averageSpending = expenseCount > 0
        ? totalSpending / expenseCount
        : 0.0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total Spent',
                  '\$${totalSpending.toStringAsFixed(2)}',
                  Colors.red,
                ),
                _buildSummaryItem(
                  'Transactions',
                  expenseCount.toString(),
                  Colors.blue,
                ),
                _buildSummaryItem(
                  'Average',
                  '\$${averageSpending.toStringAsFixed(2)}',
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsSummary(expenses) {
    final totalSpending = expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final expenseCount = expenses.length;
    final days = _endDate.difference(_startDate).inDays + 1;
    final averagePerDay = totalSpending / days;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trends Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total Spent',
                  '\$${totalSpending.toStringAsFixed(2)}',
                  Colors.red,
                ),
                _buildSummaryItem(
                  'Transactions',
                  expenseCount.toString(),
                  Colors.blue,
                ),
                _buildSummaryItem(
                  'Per Day',
                  '\$${averagePerDay.toStringAsFixed(2)}',
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _getMonthlyData() async {
    final expenseRepository = ExpenseRepository();
    final categoryRepository = CategoryRepository();

    final startOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final endOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    );

    final expenses = await expenseRepository.getExpensesByDateRange(
      startOfMonth,
      endOfMonth,
    );
    final categories = await categoryRepository.getAllCategories();

    return {'expenses': expenses, 'categories': categories};
  }

  Future<Map<String, dynamic>> _getTrendsData() async {
    final expenseRepository = ExpenseRepository();

    final expenses = await expenseRepository.getExpensesByDateRange(
      _startDate,
      _endDate,
    );

    return {'expenses': expenses};
  }
}
