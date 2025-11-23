# Estrutura Principal do Aplicativo - Zet Gestor de Orçamento

## Arquitetura de Navegação por Abas

### MainApp com BottomNavigationBar
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zet_gestor_orcamento/core/app_theme.dart';
import 'package:zet_gestor_orcamento/core/accessibility.dart';
import 'package:zet_gestor_orcamento/screens/dashboard_screen.dart';
import 'package:zet_gestor_orcamento/screens/transactions_screen.dart';
import 'package:zet_gestor_orcamento/screens/budgets_screen.dart';
import 'package:zet_gestor_orcamento/screens/reports_screen.dart';
import 'package:zet_gestor_orcamento/screens/settings_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  int _currentIndex = 0;
  
  // Telas principais
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsScreen(),
    const BudgetsScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];
  
  // Títulos das abas
  final List<String> _titles = [
    'Dashboard',
    'Transações',
    'Orçamentos',
    'Relatórios',
    'Configurações',
  ];
  
  // Ícones das abas
  final List<IconData> _icons = [
    Icons.dashboard_outlined,
    Icons.receipt_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.analytics_outlined,
    Icons.settings_outlined,
  ];
  
  // Ícones ativos das abas
  final List<IconData> _activeIcons = [
    Icons.dashboard,
    Icons.receipt,
    Icons.account_balance_wallet,
    Icons.analytics,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.lightColorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Semantics(
            label: 'Navegação principal do aplicativo',
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                AudioFeedback.playNavigationSound();
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: theme.colorScheme.surface,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: theme.colorScheme.onSurfaceVariant,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: theme.textTheme.labelSmall,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 0,
              items: List.generate(_titles.length, (index) {
                return BottomNavigationBarItem(
                  icon: Icon(_icons[index]),
                  activeIcon: Icon(_activeIcons[index]),
                  label: _titles[index],
                  tooltip: 'Ir para ${_titles[index]}',
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
```

## Estrutura de Pastas Atualizada

```
lib/
├── core/
│   ├── app_theme.dart
│   ├── accessibility.dart
│   ├── app_widgets.dart
│   ├── error_handler.dart
│   └── performance_cache.dart
├── components/
│   ├── cached_image.dart
│   ├── card_total.dart
│   ├── charts.dart
│   ├── expansion_list_wiget.dart
│   ├── lazy_charts.dart
│   ├── menu_drawer.dart
│   ├── menu_header.dart
│   ├── modern_card.dart
│   ├── responsive_wrapper.dart
│   ├── tab_scaffold.dart
│   └── bottom_tab_bar.dart
├── screens/
│   ├── dashboard_screen.dart
│   ├── transactions_screen.dart
│   ├── budgets_screen.dart
│   ├── reports_screen.dart
│   ├── settings_screen.dart
│   ├── analytics_screen.dart
│   ├── bank_slip_form_screen.dart
│   ├── monthly_budget_form_screen.dart
│   ├── salary_form_screen.dart
│   ├── add_transaction_screen.dart
│   ├── transaction_detail_screen.dart
│   ├── budget_detail_screen.dart
│   └── profile_screen.dart
├── models/
│   ├── bank_slip.dart
│   ├── budget.dart
│   ├── category.dart
│   ├── expense_filter.dart
│   ├── financial_insight.dart
│   ├── monthly_budget.dart
│   └── transaction.dart
├── services/
│   ├── budget_alert_service.dart
│   ├── export_service.dart
│   ├── insights_service.dart
│   ├── transaction_service.dart
│   └── budget_service.dart
├── data/
│   └── budget_inherited.dart
└── main.dart
```

## Telas a Serem Implementadas

### 1. DashboardScreen (Tela Inicial - Já Existe)
```dart
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Atualizar dados
          },
          child: CustomScrollView(
            slivers: [
              // Header existente
              // Cards de métricas
              // Gráficos
              // Ações rápidas
              // Transações recentes
            ],
          ),
        ),
      ),
    );
  }
}
```

### 2. TransactionsScreen (Nova)
```dart
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Todas';
  DateTimeRange? _dateRange;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header com busca e filtros
            _buildHeader(theme),
            // Lista de transações
            Expanded(
              child: _buildTransactionsList(theme),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionDialog(),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Nova Transação'),
      ),
    );
  }
  
  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Título e total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transações',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'R\$ 2.450,00',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Barra de busca
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar transações...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),
          // Filtros rápidos
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todas', theme),
                _buildFilterChip('Alimentação', theme),
                _buildFilterChip('Transporte', theme),
                _buildFilterChip('Lazer', theme),
                _buildFilterChip('Outros', theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, ThemeData theme) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? label : 'Todas';
          });
        },
        backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        selectedColor: theme.colorScheme.primaryContainer,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
  
  Widget _buildTransactionsList(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Mock data
      itemBuilder: (context, index) {
        return _buildTransactionItem(theme, index);
      },
    );
  }
  
  Widget _buildTransactionItem(ThemeData theme, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.restaurant,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          'Restaurante ${index + 1}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Hoje • 12:${30 + index * 2}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Text(
          '-R\$ ${(50 + index * 10).toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () => _showTransactionDetail(),
      ),
    );
  }
  
  void _showAddTransactionDialog() {
    // Implementar dialog de adicionar transação
  }
  
  void _showTransactionDetail() {
    // Implementar tela de detalhes
  }
}
```

### 3. BudgetsScreen (Nova)
```dart
class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Orçamentos',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showAddBudgetDialog(),
                  tooltip: 'Adicionar orçamento',
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildBudgetOverview(theme),
                    const SizedBox(height: 24),
                    _buildBudgetList(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBudgetOverview(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resumo do Mês',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Set 2024',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildMetricRow(theme, 'Total Orçado', 'R\$ 3.500,00', theme.colorScheme.primary),
            const SizedBox(height: 16),
            _buildMetricRow(theme, 'Total Gasto', 'R\$ 2.850,00', theme.colorScheme.error),
            const SizedBox(height: 16),
            _buildMetricRow(theme, 'Economizado', 'R\$ 650,00', theme.colorScheme.tertiary),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricRow(ThemeData theme, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBudgetList(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orçamentos por Categoria',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6, // Mock data
          itemBuilder: (context, index) {
            return _buildBudgetItem(theme, index);
          },
        ),
      ],
    );
  }
  
  Widget _buildBudgetItem(ThemeData theme, int index) {
    final categories = ['Alimentação', 'Transporte', 'Lazer', 'Saúde', 'Educação', 'Outros'];
    final spent = [850.0, 320.0, 450.0, 280.0, 150.0, 600.0];
    final budgeted = [1000.0, 400.0, 500.0, 350.0, 200.0, 800.0];
    
    final category = categories[index];
    final spentAmount = spent[index];
    final budgetedAmount = budgeted[index];
    final percentage = (spentAmount / budgetedAmount) * 100;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showBudgetDetail(category),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getCategoryIcon(category),
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        category,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: percentage > 90 ? theme.colorScheme.error : theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage > 90 ? theme.colorScheme.error : theme.colorScheme.primary,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gasto: R\$ ${spentAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Orçado: R\$ ${budgetedAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Alimentação':
        return Icons.restaurant;
      case 'Transporte':
        return Icons.directions_car;
      case 'Lazer':
        return Icons.movie;
      case 'Saúde':
        return Icons.local_hospital;
      case 'Educação':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
  
  void _showAddBudgetDialog() {
    // Implementar dialog de adicionar orçamento
  }
  
  void _showBudgetDetail(String category) {
    // Implementar tela de detalhes do orçamento
  }
}
```

### 4. ReportsScreen (Nova)
```dart
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Mensal';
  String _selectedChart = 'Pizza';
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Relatórios',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.download_outlined),
                  onPressed: () => _exportReport(),
                  tooltip: 'Exportar relatório',
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPeriodSelector(theme),
                    const SizedBox(height: 24),
                    _buildChartSelector(theme),
                    const SizedBox(height: 24),
                    _buildChartSection(theme),
                    const SizedBox(height: 24),
                    _buildInsightsSection(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPeriodSelector(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Período',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['Semanal', 'Mensal', 'Trimestral', 'Anual'].map((period) {
                final isSelected = _selectedPeriod == period;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(period),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedPeriod = period;
                        });
                      },
                      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      selectedColor: theme.colorScheme.primaryContainer,
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChartSelector(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de Gráfico',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['Pizza', 'Barras', 'Linhas'].map((chart) {
                final isSelected = _selectedChart == chart;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(chart),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedChart = chart;
                        });
                      },
                      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      selectedColor: theme.colorScheme.primaryContainer,
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChartSection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Distribuição de Gastos',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showChartDetails(),
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('Detalhes'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Gráfico será implementado com base no tipo selecionado
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pie_chart,
                      size: 64,
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gráfico $_selectedChart - $_selectedPeriod',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
  
  Widget _buildInsightsSection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insights Inteligentes',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightItem(theme, 'Você economizou 15% mais este mês!', Icons.trending_up, theme.colorScheme.tertiary),
            const SizedBox(height: 12),
            _buildInsightItem(theme, 'Gastos com alimentação aumentaram 8%', Icons.warning_amber, theme.colorScheme.error),
            const SizedBox(height: 12),
            _buildInsightItem(theme, 'Média mensal: R\$ 2.850,00', Icons.analytics, theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInsightItem(ThemeData theme, String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _exportReport() {
    // Implementar exportação de relatório
  }
  
  void _showChartDetails() {
    // Implementar detalhes do gráfico
  }
}
```

### 5. SettingsScreen (Nova)
```dart
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedCurrency = 'BRL';
  String _selectedLanguage = 'pt_BR';
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Configurações',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              floating: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(theme),
                    const SizedBox(height: 24),
                    _buildPreferencesSection(theme),
                    const SizedBox(height: 24),
                    _buildSecuritySection(theme),
                    const SizedBox(height: 24),
                    _buildDataSection(theme),
                    const SizedBox(height: 24),
                    _buildAboutSection(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileSection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perfil',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.onPrimary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'João Silva',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'joao.silva@email.com',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editProfile(),
                  tooltip: 'Editar perfil',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPreferencesSection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferências',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              theme,
              'Notificações',
              'Receber alertas de orçamento e lembretes',
              Icons.notifications_outlined,
              _notificationsEnabled,
              (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Moeda',
              'Real Brasileiro (R\$)',
              Icons.attach_money,
              () => _selectCurrency(),
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Idioma',
              'Português (Brasil)',
              Icons.language,
              () => _selectLanguage(),
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Tema',
              'Automático',
              Icons.brightness_6,
              () => _selectTheme(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSecuritySection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Segurança',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              theme,
              'Biometria',
              'Usar impressão digital ou reconhecimento facial',
              Icons.fingerprint,
              _biometricEnabled,
              (value) {
                setState(() {
                  _biometricEnabled = value;
                });
              },
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Alterar Senha',
              'Atualize sua senha de acesso',
              Icons.lock_outline,
              () => _changePassword(),
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Autenticação de Dois Fatores',
              'Adicione uma camada extra de segurança',
              Icons.security,
              () => _setupTwoFactor(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDataSection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildListTile(
              theme,
              'Backup na Nuvem',
              'Salve seus dados com segurança',
              Icons.cloud_upload_outlined,
              () => _setupCloudBackup(),
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Exportar Dados',
              'Baixe seus dados em PDF ou Excel',
              Icons.download_outlined,
              () => _exportData(),
            ),
            const Divider(),
              _buildListTile(
              theme,
              'Limpar Cache',
              'Libere espaço no dispositivo',
              Icons.cleaning_services_outlined,
              () => _clearCache(),
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Excluir Conta',
              'Remova permanentemente seus dados',
              Icons.delete_outline,
              () => _deleteAccount(),
              color: theme.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAboutSection(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sobre',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildListTile(
              theme,
              'Versão',
              '1.0.0',
              Icons.info_outline,
              () {},
              showArrow: false,
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Termos de Uso',
              'Leia nossos termos e condições',
              Icons.description_outlined,
              () => _showTerms(),
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Política de Privacidade',
              'Como protegemos seus dados',
              Icons.privacy_tip_outlined,
              () => _showPrivacyPolicy(),
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Avaliar App',
              'Compartilhe sua experiência',
              Icons.star_outline,
              () => _rateApp(),
            ),
            const Divider(),
            _buildListTile(
              theme,
              'Compartilhar',
              'Indique para seus amigos',
              Icons.share_outlined,
              () => _shareApp(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildListTile(ThemeData theme, String title, String subtitle, IconData icon, VoidCallback onTap, {Color? color, bool showArrow = true}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? theme.colorScheme.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color ?? theme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: color ?? theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: showArrow ? Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ) : null,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Widget _buildSwitchTile(ThemeData theme, String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      onChanged: onChanged,
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
  
  void _editProfile() {
    // Implementar edição de perfil
  }
  
  void _selectCurrency() {
    // Implementar seleção de moeda
  }
  
  void _selectLanguage() {
    // Implementar seleção de idioma
  }
  
  void _selectTheme() {
    // Implementar seleção de tema
  }
  
  void _changePassword() {
    // Implementar alteração de senha
  }
  
  void _setupTwoFactor() {
    // Implementar configuração de 2FA
  }
  
  void _setupCloudBackup() {
    // Implementar configuração de backup
  }
  
  void _exportData() {
    // Implementar exportação de dados
  }
  
  void _clearCache() {
    // Implementar limpeza de cache
  }
  
  void _deleteAccount() {
    // Implementar exclusão de conta
  }
  
  void _showTerms() {
    // Implementar visualização de termos
  }
  
  void _showPrivacyPolicy() {
    // Implementar visualização de política
  }
  
  void _rateApp() {
    // Implementar avaliação do app
  }
  
  void _shareApp() {
    // Implementar compartilhamento
  }
}
```

## Componentes de Suporte

### ResponsiveWrapper
```dart
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  
  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final isDesktop = constraints.maxWidth > 1024;
        
        return Container(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 1200 : double.infinity,
          ),
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: 16,
          ),
          child: child,
        );
      },
    );
  }
}
```

### TabScaffold
```dart
class TabScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool? resizeToAvoidBottomInset;
  
  const TabScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: ResponsiveWrapper(
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
```

## Próximos Passos de Implementação

1. **Criar componentes base** (ModernCard, ResponsiveWrapper, etc.)
2. **Implementar telas uma por uma** mantendo consistência
3. **Adicionar navegação entre telas internas**
4. **Implementar formulários de adição/editação**
5. **Adicionar animações e transições**
6. **Testar responsividade em múltiplos dispositivos**
7. **Otimizar performance e acessibilidade**
8. **Adicionar testes de interface**

Esta estrutura garante que todo o aplicativo mantenha a consistência visual da tela inicial, com navegação intuitiva por abas e responsividade total.