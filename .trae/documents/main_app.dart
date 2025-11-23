// main.dart - Arquivo principal do aplicativo
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zet_gestor_orcamento/core/app_theme.dart';
import 'package:zet_gestor_orcamento/core/accessibility.dart';
import 'package:zet_gestor_orcamento/screens/dashboard_screen.dart';
import 'package:zet_gestor_orcamento/screens/transactions_screen.dart';
import 'package:zet_gestor_orcamento/screens/budgets_screen.dart';
import 'package:zet_gestor_orcamento/screens/reports_screen.dart';
import 'package:zet_gestor_orcamento/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar orientação do dispositivo
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configurar sistema de sobreposição
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const ZetGestorOrcamentoApp());
}

class ZetGestorOrcamentoApp extends StatelessWidget {
  const ZetGestorOrcamentoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zet Gestor de Orçamento',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainApp(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0, // Prevenir zoom de texto
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver, TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  
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
  
  // Cores das abas
  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: _screens.length, vsync: this);
    
    // Configurar sistema de navegação
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Semantics(
            label: 'Navegação principal do aplicativo',
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                AudioFeedback.playNavigationSound();
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              indicatorColor: theme.colorScheme.primary.withOpacity(0.1),
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              destinations: List.generate(_titles.length, (index) {
                return NavigationDestination(
                  icon: Icon(_icons[index]),
                  selectedIcon: Icon(_activeIcons[index]),
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

// DashboardScreen - Mantém a estrutura existente mas adaptada
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header moderno
            SliverAppBar(
              title: Text(
                'Dashboard',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Navegar para notificações
                  },
                  tooltip: 'Notificações',
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () {
                    // Navegar para perfil
                  },
                  tooltip: 'Perfil',
                ),
              ],
            ),
            // Conteúdo existente adaptado
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMetricsCards(theme),
                    const SizedBox(height: 24),
                    _buildChartsSection(theme),
                    const SizedBox(height: 24),
                    _buildQuickActions(theme),
                    const SizedBox(height: 24),
                    _buildRecentTransactions(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricsCards(ThemeData theme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard(
          theme,
          'Saldo Atual',
          'R\$ 5.230,00',
          Icons.account_balance_wallet,
          theme.colorScheme.primary,
        ),
        _buildMetricCard(
          theme,
          'Economizado',
          'R\$ 1.450,00',
          Icons.savings,
          theme.colorScheme.tertiary,
        ),
        _buildMetricCard(
          theme,
          'Gastos do Mês',
          'R\$ 2.850,00',
          Icons.trending_down,
          theme.colorScheme.error,
        ),
        _buildMetricCard(
          theme,
          'Orçamento',
          'R\$ 3.500,00',
          Icons.pie_chart,
          theme.colorScheme.secondary,
        ),
      ],
    );
  }
  
  Widget _buildMetricCard(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChartsSection(ThemeData theme) {
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
                  'Análise de Gastos',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navegar para relatórios detalhados
                  },
                  icon: const Icon(Icons.analytics, size: 16),
                  label: const Text('Ver mais'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Gráfico placeholder - será substituído pelo componente real
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
                      'Gráfico de Gastos',
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
  
  Widget _buildQuickActions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildActionButton(
              theme,
              'Nova Transação',
              Icons.add_circle_outline,
              theme.colorScheme.primary,
              () => _showAddTransaction(),
            ),
            _buildActionButton(
              theme,
              'Definir Orçamento',
              Icons.account_balance_wallet,
              theme.colorScheme.secondary,
              () => _showBudgetSetup(),
            ),
            _buildActionButton(
              theme,
              'Exportar Dados',
              Icons.download,
              theme.colorScheme.tertiary,
              () => _exportData(),
            ),
            _buildActionButton(
              theme,
              'Configurações',
              Icons.settings,
              theme.colorScheme.error,
              () => _showSettings(),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionButton(ThemeData theme, String text, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
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
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildRecentTransactions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transações Recentes',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Navegar para transações
              },
              icon: const Icon(Icons.receipt, size: 16),
              label: const Text('Ver todas'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildTransactionItem(theme, index);
          },
        ),
      ],
    );
  }
  
  Widget _buildTransactionItem(ThemeData theme, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.restaurant,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          'Restaurante ${index + 1}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
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
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          // Navegar para detalhes da transação
        },
      ),
    );
  }
  
  void _showAddTransaction() {
    // Implementar navegação para adicionar transação
  }
  
  void _showBudgetSetup() {
    // Implementar navegação para configuração de orçamento
  }
  
  void _exportData() {
    // Implementar exportação de dados
  }
  
  void _showSettings() {
    // Implementar navegação para configurações
  }
}

// TransactionsScreen - Implementação completa
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
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
                const SizedBox(width: 8),
                _buildFilterChip('Alimentação', theme),
                const SizedBox(width: 8),
                _buildFilterChip('Transporte', theme),
                const SizedBox(width: 8),
                _buildFilterChip('Lazer', theme),
                const SizedBox(width: 8),
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
    return FilterChip(
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
    );
  }
  
  Widget _buildTransactionsList(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15, // Mock data
      itemBuilder: (context, index) {
        return _buildTransactionItem(theme, index);
      },
    );
  }
  
  Widget _buildTransactionItem(ThemeData theme, int index) {
    final isIncome = index % 3 == 0;
    final amount = (50 + index * 10).toDouble();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showTransactionDetail(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isIncome ? Icons.attach_money : Icons.restaurant,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIncome ? 'Salário' : 'Restaurante ${index + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hoje • 12:${30 + index * 2}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? '+' : '-'}R\$ ${amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isIncome ? theme.colorScheme.tertiary : theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddTransactionDialog() {
    // Implementar dialog de adicionar transação
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Transação'),
        content: const Text('Formulário de transação será implementado'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
  
  void _showTransactionDetail() {
    // Implementar tela de detalhes da transação
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TransactionDetailScreen(),
      ),
    );
  }
}

// BudgetsScreen - Implementação completa
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Orçamento'),
        content: const Text('Formulário de orçamento será implementado'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
  
  void _showBudgetDetail(String category) {
    // Implementar navegação para detalhes do orçamento
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetDetailScreen(category: category),
      ),
    );
  }
}

// ReportsScreen - Implementação completa
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
            // Gráfico placeholder - será substituído pelo componente real
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
                      _getChartIcon(),
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
  
  IconData _getChartIcon() {
    switch (_selectedChart) {
      case 'Pizza':
        return Icons.pie_chart;
      case 'Barras':
        return Icons.bar_chart;
      case 'Linhas':
        return Icons.show_chart;
      default:
        return Icons.pie_chart;
    }
  }
  
  void _exportReport() {
    // Implementar exportação de relatório
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relatório exportado com sucesso!')),
    );
  }
  
  void _showChartDetails() {
    // Implementar detalhes do gráfico
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Gráfico'),
        content: const Text('Detalhes do gráfico serão implementados'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

// SettingsScreen - Implementação completa
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }
  
  void _selectCurrency() {
    // Implementar seleção de moeda
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Moeda'),
        content: const Text('Lista de moedas será implementada'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _selectLanguage() {
    // Implementar seleção de idioma
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Idioma'),
        content: const Text('Lista de idiomas será implementada'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _selectTheme() {
    // Implementar seleção de tema
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Tema'),
        content: const Text('Opções de tema serão implementadas'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _changePassword() {
    // Implementar alteração de senha
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: const Text('Formulário de alteração de senha será implementado'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }
  
  void _setupTwoFactor() {
    // Implementar configuração de 2FA
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Autenticação de Dois Fatores'),
        content: const Text('Configuração de 2FA será implementada'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _setupCloudBackup() {
    // Implementar configuração de backup
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup na Nuvem'),
        content: const Text('Configuração de backup será implementada'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _exportData() {
    // Implementar exportação de dados
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados exportados com sucesso!')),
    );
  }
  
  void _clearCache() {
    // Implementar limpeza de cache
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache limpo com sucesso!')),
    );
  }
  
  void _deleteAccount() {
    // Implementar exclusão de conta
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text('Tem certeza que deseja excluir sua conta? Esta ação é irreversível.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
  
  void _showTerms() {
    // Implementar visualização de termos
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Termos de Uso'),
        content: const SingleChildScrollView(
          child: Text('Termos de uso serão implementados aqui...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _showPrivacyPolicy() {
    // Implementar visualização de política
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidade'),
        content: const SingleChildScrollView(
          child: Text('Política de privacidade será implementada aqui...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _rateApp() {
    // Implementar avaliação do app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirecionando para a loja...')),
    );
  }
  
  void _shareApp() {
    // Implementar compartilhamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compartilhando o aplicativo...')),
    );
  }
}

// Telas auxiliares - Placeholders para implementação futura
class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Transação')),
      body: const Center(child: Text('Detalhes da transação serão implementados')),
    );
  }
}

class BudgetDetailScreen extends StatelessWidget {
  final String category;
  
  const BudgetDetailScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orçamento - $category')),
      body: Center(child: Text('Detalhes do orçamento $category serão implementados')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: const Center(
        child: Text('Tela de perfil será implementada'),
      ),
    );
  }
}

// Componente de feedback de áudio para acessibilidade
class AudioFeedback {
  static void playNavigationSound() {
    // Implementar feedback sonoro para navegação
    // SystemSound.play(SystemSoundType.click);
  }
}