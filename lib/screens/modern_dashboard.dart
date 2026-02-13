import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zeitune_gestor/bloc/budget/budget_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_event.dart';
import 'package:zeitune_gestor/bloc/budget/budget_state.dart';
import 'package:zeitune_gestor/models/budget.dart';
import 'package:zeitune_gestor/models/bank_slip.dart';
import 'package:zeitune_gestor/models/monthly_budget.dart';
import 'package:zeitune_gestor/components/modern_card.dart';
import 'package:zeitune_gestor/components/lazy_charts.dart';
import 'package:zeitune_gestor/core/accessibility.dart';
import 'package:zeitune_gestor/screens/expense_form_screen.dart';
import 'package:zeitune_gestor/screens/monthly_budget_form_screen.dart';
import 'package:zeitune_gestor/screens/transactions_screen.dart';
import 'package:zeitune_gestor/screens/analytics_screen.dart';
import 'package:zeitune_gestor/models/category.dart';
import 'package:zeitune_gestor/repository/bank_slip_repository.dart';
import 'package:zeitune_gestor/repository/settings_repository.dart';
import 'package:zeitune_gestor/components/base_components.dart';

class ModernDashboard extends StatefulWidget {
  const ModernDashboard({Key? key}) : super(key: key);

  @override
  State<ModernDashboard> createState() => _ModernDashboardState();
}

class _ModernDashboardState extends State<ModernDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedIndex = 0;
  final _categoryRepo = BankSlipRepository();
  List<Category> _categoriesCache = [];
  // Controle de visibilidade do salário
  bool _salaryVisible = false;
  final SettingsRepository _settingsRepo = SettingsRepository();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
    _preloadCategories();
  }

  Future<void> _preloadCategories() async {
    try {
      final list = await _categoryRepo.getCategories();
      setState(() {
        _categoriesCache = list;
      });
    } catch (_) {
      // silently ignore; fallback will handle
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, budgetState) {
        if (budgetState is BudgetInitial) {
          context.read<BudgetBloc>().add(const LoadBudget());
          return const Center(child: CircularProgressIndicator());
        }
        
        if (budgetState is BudgetLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (budgetState is BudgetError) {
          return Center(child: Text('Erro: ${budgetState.message}'));
        }
        
        if (budgetState is BudgetLoaded) {
          final budget = budgetState.budget;
          
          return Scaffold(
            backgroundColor: theme.colorScheme.background,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<BudgetBloc>().add(const LoadBudget());
                  await _preloadCategories();
                },
                color: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surface,
                semanticsLabel: 'Atualizar dashboard',
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 120,
                      floating: true,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: theme.colorScheme.background,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Semantics(
                          label: 'Zeitune Gestor - Seu orçamento mensal',
                          header: true,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  color: theme.colorScheme.onPrimary,
                                  size: 24,
                                  semanticLabel: 'Ícone de carteira',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Zeitune Gestor',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onBackground,
                                    ),
                                  ),
                                  Text(
                                    'Seu orçamento mensal',
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
                      actions: const [],
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildMetricsCards(context, budget),
                            const SizedBox(height: 24),
                            _buildChartsSection(context, budget),
                            const SizedBox(height: 24),
                            _buildRecentTransactions(context, budget),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // bottomNavigationBar removida para evitar duplicação com TabBar principal em MainApp
          );
        }
        
        return const Center(child: Text('Estado desconhecido'));
      },
    );
  }

  Widget _buildMetricsCards(BuildContext context, Budget? budget) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600; // empilha em telas menores

    if (budget == null) {
      return const SizedBox.shrink();
    }

    final salaryCard = AccessibleCard(
      semanticLabel: _salaryVisible
          ? 'Salário mensal: R\$ ${(budget.salary ?? 0.0).toStringAsFixed(2)}'
          : 'Salário oculto. Toque para desbloquear com senha.',
      color: theme.colorScheme.primary,
      onTap: () async {
        if (_salaryVisible) {
          setState(() => _salaryVisible = false);
        } else {
          final ok = await _requestSalaryUnlock();
          if (ok && mounted) setState(() => _salaryVisible = true);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _salaryVisible ? Icons.payments_rounded : Icons.lock_outline,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        'Salário',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      _salaryVisible
                          ? 'R\$ ${(budget.salary ?? 0.0).toStringAsFixed(2)}'
                          : '••••••',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                label: _salaryVisible ? 'Ocultar salário' : 'Mostrar salário (com senha)',
                button: true,
                child: IconButton(
                  icon: Icon(_salaryVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                  color: theme.colorScheme.onPrimary,
                  onPressed: () async {
                    if (_salaryVisible) {
                      setState(() => _salaryVisible = false);
                    } else {
                      final ok = await _requestSalaryUnlock();
                      if (ok && mounted) setState(() => _salaryVisible = true);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final expenseCard = AccessibleCard(
      semanticLabel: 'Total de despesas: R\$ ${budget.getGasto().toStringAsFixed(2)}',
      color: theme.colorScheme.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onError.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_down,
                  color: theme.colorScheme.onError,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Despesas',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onError,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${budget.getGasto().toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onError,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isCompact) {
      // Empilhar verticalmente para melhor leitura no Android/telefones
      return Column(
        children: [
          salaryCard,
          const SizedBox(height: 12),
          expenseCard,
        ],
      );
    }

    return Row(
      children: [
        // Cartão de Salário com proteção por senha
        Expanded(
          child: salaryCard,
        ),
        const SizedBox(width: 12),
        // Cartão de Despesas
        Expanded(
          child: expenseCard,
        ),
      ],
    );
  }

  Future<bool> _requestSalaryUnlock() async {
    final existing = await _settingsRepo.getString(SettingsRepository.keySalaryPasscode);
    String input = '';
    bool unlocked = false;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existing == null ? 'Definir senha do salário' : 'Desbloquear salário'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: existing == null ? 'Nova senha (4–6 dígitos)' : 'Senha',
                    ),
                    onChanged: (v) => input = v.trim(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if ((existing ?? '').isEmpty) {
                      if (input.isEmpty || input.length < 4) {
                        ModernSnackBar.show(
                          context: context,
                          message: 'Defina uma senha de 4 a 6 dígitos',
                          icon: Icons.error_outline,
                        );
                        return;
                      }
                      await _settingsRepo.setString(SettingsRepository.keySalaryPasscode, input);
                      unlocked = true;
                      Navigator.pop(context);
                    } else {
                      if (input == existing) {
                        unlocked = true;
                        Navigator.pop(context);
                      } else {
                        ModernSnackBar.show(
                          context: context,
                          message: 'Senha incorreta',
                          icon: Icons.error_outline,
                        );
                      }
                    }
                  },
                  child: Text(existing == null ? 'Salvar e mostrar' : 'Desbloquear'),
                ),
              ],
            );
          },
        );
      },
    );
    return unlocked;
  }

  Widget _buildChartsSection(BuildContext context, Budget? budget) {
    final theme = Theme.of(context);

    if (budget == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Análise de Gastos',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AccessibleCard(
          semanticLabel: 'Gráfico de distribuição de gastos',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    color: theme.colorScheme.primary,
                    semanticLabel: 'Ícone de gráfico de pizza',
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Distribuição de Gastos',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Define altura fixa para o gráfico (evita layout sem restrição)
              SizedBox(
                height: 200,
                child: LazyExpensePieChart(
                  data: _getExpenseData(budget),
                  delay: const Duration(milliseconds: 400),
                ),
              ),
            ],
          ),
        ).animate().fade(delay: 400.ms).scale(),
      ],
    );
  }

  

  Widget _buildRecentTransactions(BuildContext context, Budget? budget) {
    final theme = Theme.of(context);
    
    if (budget == null) {
      return const SizedBox.shrink();
    }

    final recentTransactions = budget.getAllBankSlips()..sort((a, b) {
      final dateA = a.date ?? '';
      final dateB = b.date ?? '';
      return dateB.compareTo(dateA);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Semantics(
              header: true,
              child: Text(
                'Transações Recentes',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Semantics(
              button: true,
              label: 'Ver todas as transações',
              child: TextButton(
                onPressed: () {
                  AudioFeedback.playNavigationSound();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionsScreen(),
                    ),
                  );
                },
                child: const Text('Ver todas'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentTransactions.isEmpty)
          AccessibleCard(
            semanticLabel: 'Nenhuma transação encontrada',
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_outlined,
                      size: 48,
                      color: theme.colorScheme.outline,
                      semanticLabel: 'Ícone de recibo',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma transação ainda',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Adicione suas primeiras despesas para começar',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fade(delay: 800.ms).scale()
        else
          Column(
            children: recentTransactions.map((transaction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AccessibleCard(
                  semanticLabel: 'Transação: ${transaction.name ?? 'Sem nome'}, valor: R\$ ${transaction.value?.toStringAsFixed(2) ?? '0.00'}, data: ${transaction.date ?? 'Sem data'}',
                  onTap: () {
                    AudioFeedback.playNavigationSound();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseFormScreen(
                          appContext: context,
                          bankSlip: transaction,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: ((transaction.value ?? 0) < 0)
                              ? theme.colorScheme.tertiaryContainer
                              : theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          ((transaction.value ?? 0) < 0)
                              ? Icons.add_rounded
                              : Icons.remove_rounded,
                          color: ((transaction.value ?? 0) < 0)
                              ? theme.colorScheme.onTertiaryContainer
                              : theme.colorScheme.onErrorContainer,
                          semanticLabel: 'Tipo da transação',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Semantics(
                              header: true,
                              child: Text(
                                transaction.name ?? 'Sem nome',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction.date ?? 'Sem data',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Semantics(
                        label: 'Valor da transação',
                        child: Text(
                          'R\$ ${(transaction.value ?? 0).abs().toStringAsFixed(2)}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ((transaction.value ?? 0) < 0)
                                ? theme.colorScheme.tertiary
                                : theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ).animate().fade(delay: 800.ms).scale(),
      ],
    );
  }

  Map<String, double> _getExpenseData(Budget? budget) {
    if (budget == null) return {};

    // Agrupar por nome da transação (BankSlip.name) para refletir itens
    final expensesByItem = <String, double>{};

    for (final monthlyBudget in budget.monthlyBudget ?? []) {
      for (final bankSlip in monthlyBudget.bankSilps ?? []) {
        final String key = (bankSlip.name ?? 'Sem nome').trim();
        final double amount = (bankSlip.value ?? 0).toDouble();
        if (amount > 0) {
          expensesByItem[key] = (expensesByItem[key] ?? 0) + amount;
        }
      }
    }

    return expensesByItem;
  }
}