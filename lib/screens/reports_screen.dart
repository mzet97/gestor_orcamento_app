// reports_screen.dart - Tela de relatórios
import 'package:flutter/material.dart';
import 'package:zeitune_gestor/components/base_components.dart';
import 'package:zeitune_gestor/components/lazy_charts.dart';
import 'package:zeitune_gestor/repository/bank_slip_repository.dart';
import 'package:zeitune_gestor/models/bank_slip.dart';
import 'package:zeitune_gestor/models/category.dart';
import 'package:intl/intl.dart';
import 'package:zeitune_gestor/repository/settings_repository.dart';
import 'package:zeitune_gestor/repository/budget_repository.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Este mês';
  final _repo = BankSlipRepository();
  final DateFormat _monthKeyFormat = DateFormat('yyyy-MM');
  DateFormat _displayDateFormat = DateFormat('dd/MM/yyyy');
  bool _isLoading = true;
  final SettingsRepository _settingsRepo = SettingsRepository();
  final BudgetRepository _budgetRepo = BudgetRepository();
  double _salary = 0.0;

  List<BankSlip> _slips = [];
  List<Category> _categories = [];

  // Dados derivados
  Map<String, double> _monthlyExpense = {}; // yyyy-MM -> total despesas
  Map<String, double> _monthlyIncome = {}; // yyyy-MM -> total receitas
  Map<String, double> _categoryExpenses = {}; // categoria -> total despesas
  Map<String, double> _categoryIncome = {}; // categoria -> total receitas
  List<Map<String, dynamic>> _timelineTxns = [];
  double _totalIncome = 0; // receitas (valores negativos)
  double _totalExpense = 0; // despesas (valores positivos)

  final List<String> _periods = [
    'Esta semana',
    'Este mês',
    'Este trimestre',
    'Este ano',
    'Personalizado',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initDateFormat();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; });
    final slips = await _repo.getAll();
    final cats = await _repo.getCategories();
    _slips = slips;
    _categories = cats;
    // Carregar salário mensal salvo
    try {
      _salary = await _budgetRepo.getSalary();
    } catch (_) {}
    _recomputeAggregates();
    setState(() { _isLoading = false; });
  }

  Future<void> _initDateFormat() async {
    final fmt = await _settingsRepo.getDateFormatOrDefault();
    if (!mounted) return;
    setState(() {
      _displayDateFormat = DateFormat(fmt);
    });
  }

  void _onPeriodChanged(String value) {
    setState(() {
      _selectedPeriod = value;
      _recomputeAggregates();
    });
  }

  DateTimeRange _getDateRangeForPeriod(String selected) {
    final now = DateTime.now();

    if (selected == 'Este mês') {
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);
      return DateTimeRange(start: start, end: end);
    }

    if (selected == 'Último mês') {
      final prevMonth = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
      final start = DateTime(prevMonth.year, prevMonth.month, 1);
      final end = DateTime(prevMonth.year, prevMonth.month + 1, 0);
      return DateTimeRange(start: start, end: end);
    }

    if (selected == 'Últimos 3 meses') {
      final startMonthDate = DateTime(now.year, now.month, 1).subtract(const Duration(days: 60));
      final start = DateTime(startMonthDate.year, startMonthDate.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);
      return DateTimeRange(start: start, end: end);
    }

    if (selected == 'Últimos 6 meses') {
      final startMonthDate = DateTime(now.year, now.month, 1).subtract(const Duration(days: 150));
      final start = DateTime(startMonthDate.year, startMonthDate.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);
      return DateTimeRange(start: start, end: end);
    }

    if (selected == 'Este ano') {
      final start = DateTime(now.year, 1, 1);
      final end = DateTime(now.year, 12, 31);
      return DateTimeRange(start: start, end: end);
    }

    // Fallback: mês atual
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return DateTimeRange(start: start, end: end);
  }

  List<BankSlip> _filteredSlips() {
    final range = _getDateRangeForPeriod(_selectedPeriod);
    return _slips.where((s) {
      final d = DateTime.tryParse(s.date ?? '');
      if (d == null) return false;
      return !d.isBefore(range.start) && !d.isAfter(range.end);
    }).toList();
  }

  void _recomputeAggregates() {
    final filtered = _filteredSlips();
    _monthlyExpense = {};
    _monthlyIncome = {};
    _categoryExpenses = {};
    _categoryIncome = {};
    _timelineTxns = [];
    _totalIncome = 0;
    _totalExpense = 0;

    for (final s in filtered) {
      final d = DateTime.tryParse(s.date ?? '');
      final val = s.value ?? 0;
      final isIncome = val < 0;
      final amountAbs = val.abs();

      // por mês
      if (d != null) {
        final key = _monthKeyFormat.format(d);
        if (isIncome) {
          _monthlyIncome[key] = (_monthlyIncome[key] ?? 0) + amountAbs;
        } else {
          _monthlyExpense[key] = (_monthlyExpense[key] ?? 0) + amountAbs;
        }
      }

      // totais
      if (isIncome) {
        _totalIncome += amountAbs;
      } else {
        _totalExpense += amountAbs;
      }

      // categoria
      final cat = _categories.firstWhere(
        (c) => c.id == s.categoryId,
        orElse: () => Category(id: 0, name: 'Sem categoria', description: '', color: Colors.grey, icon: Icons.more_horiz, budgetLimit: 0),
      );
      final catName = cat.name;
      if (isIncome) {
        _categoryIncome[catName] = (_categoryIncome[catName] ?? 0) + amountAbs;
      } else {
        _categoryExpenses[catName] = (_categoryExpenses[catName] ?? 0) + amountAbs;
      }

      // timeline item
      if (d != null) {
        final dateStr = _displayDateFormat.format(d);
        _timelineTxns.add({
          'title': s.name ?? 'Transação',
          'amount': amountAbs,
          'category': catName,
          'date': dateStr,
          'isIncome': isIncome,
        });
      }
    }
  }

  // Conta meses inteiros entre o início e o fim do período selecionado (inclusivo)
  int _countMonthsInRange(DateTimeRange range) {
    DateTime cursor = DateTime(range.start.year, range.start.month, 1);
    final DateTime endMonth = DateTime(range.end.year, range.end.month, 1);
    int count = 0;
    while (!cursor.isAfter(endMonth)) {
      count++;
      cursor = DateTime(cursor.year, cursor.month + 1, 1);
    }
    return count;
  }

  // Salário acumulado para o período selecionado
  double _salaryForSelectedPeriod() {
    final range = _getDateRangeForPeriod(_selectedPeriod);
    final months = _countMonthsInRange(range);
    return (_salary) * months;
  }

  List<double> _buildMonthlyCombinedTotals() {
    // Combina por mês: despesas + receitas (valores absolutos)
    final keys = {..._monthlyExpense.keys, ..._monthlyIncome.keys}.toList()..sort();
    return keys.map((k) => (_monthlyExpense[k] ?? 0) + (_monthlyIncome[k] ?? 0)).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatCurrency(double v) {
    // Simples formatação, pode usar NumberFormat se necessário
    return 'R\$ ' + v.toStringAsFixed(2);
  }

  String _computeSavingsPercent() {
    // Preferir taxa de economia baseada no salário do período, se disponível.
    final salaryPeriod = _salaryForSelectedPeriod();
    if (salaryPeriod > 0) {
      final savings = salaryPeriod - _totalExpense;
      final perc = savings <= 0 ? 0 : (savings / salaryPeriod) * 100;
      return '${perc.toStringAsFixed(1)}%';
    }
    // Caso não haja salário configurado, usar receitas do período como base.
    final income = _totalIncome;
    if (income <= 0) return '0%';
    final savings = income - _totalExpense;
    final perc = savings <= 0 ? 0 : (savings / income) * 100;
    return '${perc.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_today_rounded),
            onSelected: (value) {
              _onPeriodChanged(value);
            },
            itemBuilder: (context) => [
              'Este mês',
              'Último mês',
              'Últimos 3 meses',
              'Últimos 6 meses',
              'Este ano',
            ].map((period) {
              return PopupMenuItem<String>(
                value: period,
                child: Row(
                  children: [
                    Icon(
                      _selectedPeriod == period
                          ? Icons.radio_button_on_rounded
                          : Icons.radio_button_off_rounded,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(period),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Visão Geral'),
            Tab(text: 'Despesas'),
            Tab(text: 'Receitas'),
            Tab(text: 'Comparativo'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildExpensesTab(),
                _buildIncomeTab(),
                _buildComparisonTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return ResponsiveContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Cards de resumo
            _buildSummaryCards(),
            const SizedBox(height: 24),
            
            // Gráfico de pizza
            ModernCard(
              hasShadow: true,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribuição de Despesas (${_selectedPeriod})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LazyExpensePieChart(
                      data: _categoryExpenses.isEmpty ? {'Sem dados': 0} : _categoryExpenses,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Gráfico de barras mensal
            ModernCard(
              hasShadow: true,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Totais Mensais (${_selectedPeriod})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LazyMonthlyBarChart(
                      monthlyData: _buildMonthlyCombinedTotals(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Linha do tempo de transações
            ModernCard(
              hasShadow: true,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atividades Recentes (${_selectedPeriod})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: LazyExpenseTimeline(
                      transactions: _timelineTxns,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildSummaryCard(
          title: 'Receitas',
          value: _formatCurrency(_totalIncome),
          icon: Icons.trending_up_rounded,
          color: Colors.green,
        ),
        _buildSummaryCard(
          title: 'Despesas',
          value: _formatCurrency(_totalExpense),
          icon: Icons.trending_down_rounded,
          color: Colors.red,
        ),
        _buildSummaryCard(
          title: 'Saldo',
          value: _formatCurrency(_salaryForSelectedPeriod() + _totalIncome - _totalExpense),
          icon: Icons.account_balance_rounded,
          color: Colors.blue,
        ),
        _buildSummaryCard(
          title: 'Economia',
          value: _computeSavingsPercent(),
          icon: Icons.savings_rounded,
          color: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return ModernCard(
      hasShadow: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 20,
              ),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesTab() {
    return ResponsiveContainer(
      child: Column(
        children: [
          ModernCard(
            hasShadow: true,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Categorias de Despesas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildTopExpenseItems(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTopExpenseItems() {
    final total = _totalExpense;
    final sorted = _categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(6).map((e) {
      final perc = total == 0 ? 0.0 : (e.value / total) * 100;
      return _buildExpenseItem(e.key, e.value, perc);
    }).toList();
  }

  Widget _buildExpenseItem(String category, double amount, double percentage) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(amount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.error,
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeTab() {
    return ResponsiveContainer(
      child: Column(
        children: [
          ModernCard(
            hasShadow: true,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fontes de Renda',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildTopIncomeItems(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTopIncomeItems() {
    final total = _totalIncome;
    final sorted = _categoryIncome.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(6).map((e) {
      final perc = total == 0 ? 0.0 : (e.value / total) * 100;
      return _buildIncomeItem(e.key, e.value, perc);
    }).toList();
  }

  Widget _buildIncomeItem(String source, double amount, double percentage) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(amount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.tertiary,
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTab() {
    return ResponsiveContainer(
      child: Column(
        children: [
          ModernCard(
            hasShadow: true,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comparativo Mensal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildMonthlyComparisonItems(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMonthlyComparisonItems() {
    // Ordena meses e cria itens com percent % de despesas vs receitas
    final keys = {..._monthlyExpense.keys, ..._monthlyIncome.keys}.toList()..sort();
    return keys.map((k) {
      final expense = _monthlyExpense[k] ?? 0;
      final income = _monthlyIncome[k] ?? 0;
      final perc = (income + expense) == 0 ? 0.0 : (expense / (income + expense)) * 100;
      final monthLabel = _formatMonthLabel(k);
      return _buildComparisonItem(monthLabel, expense, income, perc);
    }).toList();
  }

  String _formatMonthLabel(String yyyyMm) {
    try {
      final dt = DateTime.parse(yyyyMm + '-01');
      const months = [
        'Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
      ];
      final mName = months[dt.month - 1];
      return '$mName/${dt.year}';
    } catch (_) {
      return yyyyMm;
    }
  }

  Widget _buildComparisonItem(String month, double expenses, double income, double percentage) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Receita: ${_formatCurrency(income)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                Text(
                  'Despesa: ${_formatCurrency(expenses)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: percentage < 80 ? theme.colorScheme.tertiary : theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage < 80 ? theme.colorScheme.tertiary : theme.colorScheme.error,
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}