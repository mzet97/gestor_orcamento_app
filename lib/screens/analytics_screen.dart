import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/budget.dart';
import '../models/bank_slip.dart';
import '../models/category.dart';
import '../models/monthly_budget.dart';
import '../models/financial_insight.dart';
import '../services/export_service.dart';
import '../database/my_database.dart';
import '../services/insights_service.dart';
import '../services/budget_alert_service.dart';
import '../components/lazy_charts.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final MyDatabase _database = MyDatabase();
  final ExportService _exportService = ExportService();
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: 'R\$ ',
    decimalDigits: 2,
  );

  List<BankSlip> _bankSlips = [];
  List<Category> _categories = [];
  List<MonthlyBudget> _monthlyBudgets = [];
  Budget? _budget;
  List<FinancialInsight> _insights = [];

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  int? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      final slips = await _database.getAllBankSlip();
      final categories = await _database.getCategories();
      final monthlyBudgets = await _database.getAllMonthlyBudget();
      final budget = await _database.getBudget();

      // Gerar insights
      final insights = InsightsService.generateInsights(
        _getFilteredSlips(),
        categories,
        budget,
      );

      setState(() {
        _bankSlips = slips;
        _categories = categories;
        _monthlyBudgets = monthlyBudgets;
        _budget = budget;
        _insights = insights;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  List<BankSlip> _getFilteredSlips() {
    return _bankSlips.where((slip) {
      if (slip.date == null) return false;

      final slipDate = DateTime.tryParse(slip.date!);
      if (slipDate == null) return false;

      final dateInRange =
          slipDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
              slipDate.isBefore(_endDate.add(const Duration(days: 1)));

      final categoryMatch =
          _selectedCategoryId == null || slip.categoryId == _selectedCategoryId;

      return dateInRange && categoryMatch;
    }).toList();
  }

  Map<int, double> _getCategoryExpenses() {
    final Map<int, double> expenses = {};
    final filteredSlips = _getFilteredSlips();

    for (final slip in filteredSlips) {
      if (slip.categoryId != null && slip.value != null) {
        expenses[slip.categoryId!] =
            (expenses[slip.categoryId!] ?? 0) + slip.value!;
      }
    }

    return expenses;
  }

  Future<void> _exportToPDF() async {
    try {
      final filePath = await _exportService.exportToPDF(
        budget: _budget ?? Budget.empty(),
        monthlyBudgets: _monthlyBudgets,
        bankSlips: _getFilteredSlips(),
        categories: _categories,
        startDate: _startDate,
        endDate: _endDate,
      );

      await _exportService.shareFile(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao exportar PDF: $e')),
      );
    }
  }

  Future<void> _exportToExcel() async {
    try {
      final filePath = await _exportService.exportToExcel(
        budget: _budget ?? Budget.empty(),
        monthlyBudgets: _monthlyBudgets,
        bankSlips: _getFilteredSlips(),
        categories: _categories,
        startDate: _startDate,
        endDate: _endDate,
      );

      await _exportService.shareFile(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao exportar Excel: $e')),
      );
    }
  }

  Future<void> _testAlerts() async {
    try {
      await BudgetAlertService.checkBudgetAlerts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alertas verificados!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao testar alertas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSlips = _getFilteredSlips();
    final categoryExpenses = _getCategoryExpenses();
    final totalExpenses =
        filteredSlips.fold(0.0, (sum, slip) => sum + (slip.value ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Financeiro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pdf') {
                _exportToPDF();
              } else if (value == 'excel') {
                _exportToExcel();
              } else if (value == 'alert') {
                _testAlerts();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Text('Exportar PDF'),
              ),
              const PopupMenuItem(
                value: 'excel',
                child: Text('Exportar Excel'),
              ),
              const PopupMenuItem(
                value: 'alert',
                child: Text('Testar Alertas'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtros
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filtros',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: _startDate,
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        setState(() => _startDate = date);
                                      }
                                    },
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Data Inicial',
                                        border: OutlineInputBorder(),
                                      ),
                                      child: Text(DateFormat('dd/MM/yyyy')
                                          .format(_startDate)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: _endDate,
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        setState(() => _endDate = date);
                                      }
                                    },
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Data Final',
                                        border: OutlineInputBorder(),
                                      ),
                                      child: Text(DateFormat('dd/MM/yyyy')
                                          .format(_endDate)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<int?>(
                              value: _selectedCategoryId,
                              decoration: const InputDecoration(
                                labelText: 'Categoria',
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('Todas as Categorias'),
                                ),
                                ..._categories
                                    .map((category) => DropdownMenuItem<int?>(
                                          value: category.id,
                                          child: Text(category.name),
                                        )),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedCategoryId = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Resumo Financeiro
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resumo Financeiro',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSummaryItem(
                                  'Total de Gastos',
                                  _currencyFormat.format(totalExpenses),
                                  Icons.attach_money,
                                  Colors.red,
                                ),
                                _buildSummaryItem(
                                  'Transações',
                                  filteredSlips.length.toString(),
                                  Icons.receipt,
                                  Colors.blue,
                                ),
                                _buildSummaryItem(
                                  'Categorias',
                                  categoryExpenses.length.toString(),
                                  Icons.category,
                                  Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Seção de Insights
                    _buildInsightsSection(),

                    const SizedBox(height: 16),

                    // Gráfico de Categorias
                    if (categoryExpenses.isNotEmpty) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Despesas por Categoria',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: LazyExpensePieChart(
                                  data: Map.fromEntries(
                                    categoryExpenses.entries.map((entry) {
                                      final category = _categories.firstWhere(
                                        (c) => c.id == entry.key,
                                        orElse: () => Category(
                                          name: 'Sem categoria',
                                          description: 'Categoria padrão',
                                          color: Colors.grey,
                                          icon: Icons.help_outline,
                                        ),
                                      );
                                      return MapEntry(category.name, entry.value);
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Lista de Categorias
                    if (categoryExpenses.isNotEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalhes por Categoria',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              ...categoryExpenses.entries.map((entry) {
                                final category = _categories.firstWhere(
                                  (c) => c.id == entry.key,
                                  orElse: () => Category(
                                    name: 'Sem categoria',
                                    description: 'Categoria não encontrada',
                                    color: Colors.grey,
                                    icon: Icons.help_outline,
                                  ),
                                );
                                final percentage = totalExpenses > 0
                                    ? (entry.value / totalExpenses) * 100
                                    : 0;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: _getColorForCategory(entry.key),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(category.name),
                                      ),
                                      Text(_currencyFormat.format(entry.value)),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${percentage.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInsightsSection() {
    if (_insights.isEmpty) {
      return Container();
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
                const SizedBox(width: 8),
                const Text(
                  'Insights Financeiros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._insights
                .take(3)
                .map((insight) => _buildInsightCard(insight))
                .toList(),
            if (_insights.length > 3)
              TextButton(
                onPressed: () {
                  // TODO: Abrir tela com todos os insights
                },
                child: const Text('Ver mais insights'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(FinancialInsight insight) {
    Color cardColor;
    IconData icon;

    switch (insight.priority) {
      case InsightPriority.critical:
        cardColor = Colors.red[100]!;
        icon = Icons.warning;
        break;
      case InsightPriority.high:
        cardColor = Colors.red[50]!;
        icon = Icons.warning;
        break;
      case InsightPriority.medium:
        cardColor = Colors.orange[50]!;
        icon = Icons.info_outline;
        break;
      case InsightPriority.low:
        cardColor = Colors.blue[50]!;
        icon = Icons.lightbulb_outline;
        break;
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon,
            color: insight.priority == InsightPriority.critical
                ? Colors.red[700]
                : insight.priority == InsightPriority.high
                    ? Colors.red
                    : insight.priority == InsightPriority.medium
                        ? Colors.orange
                        : Colors.blue),
        title: Text(insight.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(insight.description),
        trailing: insight.relatedAmount != null && insight.relatedAmount! > 0
            ? Text('R\$ ${insight.relatedAmount!.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold))
            : null,
      ),
    );
  }

  Widget _buildSummaryItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getColorForCategory(int categoryId) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];
    return colors[categoryId % colors.length];
  }
}
