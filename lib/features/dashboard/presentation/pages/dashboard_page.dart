import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../budgets/presentation/widgets/budget_overview_widget.dart';
import '../../../budgets/presentation/providers/budget_provider.dart';
import '../../../analytics/presentation/widgets/spending_pie_chart.dart';
import '../../../analytics/presentation/widgets/spending_trend_chart.dart';
import '../../../../core/services/budget_monitoring_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../expenses/data/repositories/expense_repository.dart';
import '../../../expenses/data/repositories/category_repository.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../expenses/data/models/category_model.dart';
import '../../../expenses/presentation/pages/add_expense_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with TickerProviderStateMixin {
  DateTime _selectedMonth = DateTime.now();
  String _selectedCurrency = 'USD';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildModernAppBar(),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildWelcomeSection(),
                    _buildQuickStatsSection(),
                    _buildMonthlyOverview(),
                    _buildBudgetOverview(),
                    _buildAnalyticsSection(),
                    _buildRecentExpenses(),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildModernFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Monthly Expense Tracker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome back! 👋',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _showSettings,
                      icon: const Icon(Icons.settings, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This Month',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_getMonthName(_selectedMonth)} ${_selectedMonth.year}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildCurrencySelector(),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder(
            future: _getQuickStats(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerContainer(height: 40);
              }

              if (snapshot.hasError) {
                return const Text(
                  'Error loading data',
                  style: TextStyle(color: Colors.white70),
                );
              }

              final stats = snapshot.data as Map<String, dynamic>;
              final totalSpent = stats['totalSpent'] as double;

              return Text(
                '\$${totalSpent.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_money, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            _selectedCurrency,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return FutureBuilder(
      future: _getQuickStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerStats();
        }

        if (snapshot.hasError) {
          return _buildErrorCard();
        }

        final stats = snapshot.data as Map<String, dynamic>;
        final totalSpent = stats['totalSpent'] as double;
        final budgetSummary = stats['budgetSummary'] as BudgetSummary;
        final expensesCount = stats['expensesCount'] as int;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildModernStatCard(
                      'Total Spent',
                      '\$${totalSpent.toStringAsFixed(2)}',
                      Colors.red,
                      Icons.shopping_cart_outlined,
                      Colors.red.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernStatCard(
                      'Transactions',
                      expensesCount.toString(),
                      Colors.blue,
                      Icons.receipt_outlined,
                      Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildModernStatCard(
                      'Budget Used',
                      '${(budgetSummary.spentPercentage * 100).toStringAsFixed(1)}%',
                      budgetSummary.isOverBudget ? Colors.red : Colors.green,
                      Icons.account_balance_wallet_outlined,
                      budgetSummary.isOverBudget
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernStatCard(
                      'At Risk',
                      budgetSummary.budgetsAtRisk.toString(),
                      budgetSummary.budgetsAtRisk > 0
                          ? Colors.orange
                          : Colors.green,
                      Icons.warning_outlined,
                      budgetSummary.budgetsAtRisk > 0
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getMonthName(_selectedMonth),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: _getAnalyticsData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerContainer(height: 200);
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error loading analytics data'),
                );
              }

              final data = snapshot.data as Map<String, dynamic>;
              final expenses = data['expenses'] as List<ExpenseModel>;
              final categories = data['categories'] as List<CategoryModel>;

              return SizedBox(
                height: 200,
                child: SpendingPieChart(
                  expenses: expenses,
                  categories: categories,
                  month: _selectedMonth,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetOverview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const BudgetOverviewWidget(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return FutureBuilder(
      future: _getAnalyticsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(16),
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: _buildShimmerContainer(height: 300),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data as Map<String, dynamic>;
        final expenses = data['expenses'] as List<ExpenseModel>;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Spending Trend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: SpendingTrendChart(
                  expenses: expenses,
                  startDate: DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentExpenses() {
    return FutureBuilder(
      future: _getRecentExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...List.generate(3, (index) => _buildShimmerExpenseTile()),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final expenses = snapshot.data as List<ExpenseModel>;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Expenses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to expenses page
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (expenses.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No recent expenses',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...expenses
                    .take(5)
                    .map((expense) => _buildModernExpenseTile(expense)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernExpenseTile(ExpenseModel expense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expense.date.toString().split(' ')[0],
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddExpensePage()),
        );
      },
      backgroundColor: const Color(0xFF667eea),
      foregroundColor: Colors.white,
      elevation: 8,
      icon: const Icon(Icons.add),
      label: const Text(
        'Add Expense',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildShimmerStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildShimmerContainer(height: 100)),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerContainer(height: 100)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildShimmerContainer(height: 100)),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerContainer(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildShimmerExpenseTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Error loading stats',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _getQuickStats() async {
    final expenseRepository = ExpenseRepository();
    final budgetMonitoringService = BudgetMonitoringService(
      ref.read(budgetRepositoryProvider),
      NotificationService(),
    );

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

    final budgetSummary = await budgetMonitoringService.getBudgetSummary();
    final totalSpent = expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    return {
      'totalSpent': totalSpent,
      'budgetSummary': budgetSummary,
      'expensesCount': expenses.length,
    };
  }

  Future<Map<String, dynamic>> _getAnalyticsData() async {
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

  Future<List<ExpenseModel>> _getRecentExpenses() async {
    final expenseRepository = ExpenseRepository();
    final expenses = await expenseRepository.getAllExpenses();
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses.take(5).toList();
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  void _showSettings() {
    // Navigate to settings
  }

  String _getMonthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[date.month - 1];
  }
}
