// transactions_screen.dart - Tela de transações
import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/base_components.dart';
import 'package:zet_gestor_orcamento/models/transaction.dart';
import 'package:zet_gestor_orcamento/models/category.dart';
import 'package:zet_gestor_orcamento/repository/bank_slip_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/database/isar_database.dart';
import 'package:zet_gestor_orcamento/screens/expense_form_screen.dart';
import 'package:zet_gestor_orcamento/test_agendamentos.dart' as test_agendamentos;

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Todas';
  bool _showFilters = false;
  final _repo = BankSlipRepository();
  List<BankSlip> _slips = [];
  List<Category> _categories = [];

  // Totais dinâmicos baseados nos dados carregados
  double get _totalExpenses {
    double sum = 0;
    for (final s in _slips) {
      final v = s.value ?? 0;
      if (v > 0) sum += v;
    }
    return sum;
  }

  double get _totalIncome {
    double sum = 0;
    for (final s in _slips) {
      final v = s.value ?? 0;
      if (v < 0) sum += v.abs();
    }
    return sum;
  }

  String _formatCurrency(double v) {
    return 'R\$ ' + v.toStringAsFixed(2);
  }

  final List<String> _filters = [
    'Todas',
    'Despesas',
    'Receitas',
    'Esta semana',
    'Este mês',
    'Este ano',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Carregar via repositório (usa Isar em não-web)
    _categories = await _repo.getCategories();
    _slips = await _repo.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: ModernAppBar(
        title: 'Transações',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            // Campo de busca
            ModernTextField(
              hintText: 'Buscar transações...',
              prefixIcon: Icons.search_rounded,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Filtros
            if (_showFilters) ...[
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = filter == _selectedFilter;
                    
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 8,
                        right: index == _filters.length - 1 ? 16 : 0,
                      ),
                      child: ModernChip(
                        label: filter,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Resumo rápido
            ModernCard(
              hasShadow: true,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total de Despesas',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatCurrency(_totalExpenses),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total de Receitas',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatCurrency(_totalIncome),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Lista de transações
            Expanded(
              child: _buildTransactionsList(context),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botão principal de adicionar
          FloatingActionButton(
            heroTag: 'add_btn',
            onPressed: () async {
              // Abrir tela de nova despesa
              final added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpenseFormScreen(appContext: context),
                ),
              );
              if (added == true) {
                await _loadData();
              }
            },
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              Icons.add_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    final theme = Theme.of(context);
    
    final transactions = _slips.map((s) {
      final cat = _categories.firstWhere(
        (c) => c.id == s.categoryId,
        orElse: () => Category(
          id: 0,
          name: 'Sem categoria',
          description: '',
          color: Colors.grey,
          icon: Icons.more_horiz,
        ),
      );
      // Definir tipo pela regra de sinal: negativo = receita, positivo = despesa
      final type = (s.value ?? 0) < 0 ? TransactionType.income : TransactionType.expense;
      return Transaction(
        id: s.id,
        description: s.name ?? '',
        amount: s.value?.abs() ?? 0,
        category: cat,
        date: DateTime.tryParse(s.date ?? '') ?? DateTime.now(),
        type: type,
      );
    }).where((t) {
      final matchesSearch = _searchQuery.isEmpty || t.description.toLowerCase().contains(_searchQuery);
      return matchesSearch;
    }).toList();

    if (transactions.isEmpty) {
      return ModernEmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'Nenhuma transação encontrada',
        description: 'Adicione sua primeira transação para começar a controlar suas finanças.',
        buttonText: 'Adicionar Transação',
        onButtonPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExpenseFormScreen(appContext: context),
            ),
          );
          if (added == true) {
            await _loadData();
          }
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return _buildTransactionItem(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final theme = Theme.of(context);
    final isIncome = transaction.type == TransactionType.income;
    final slip = _slips.firstWhere(
      (s) => s.id == transaction.id,
      orElse: () => BankSlip.empty(),
    );
    final statusLabel = (slip.isPaid ?? false) ? 'Pago' : 'Pendente';
    final statusColor = (slip.isPaid ?? false) ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant;
    
    return ModernCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      onTap: () => _showTransactionDetails(transaction),
      child: Row(
        children: [
          // Ícone da categoria
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Icons.add_rounded : Icons.remove_rounded,
              color: isIncome ? theme.colorScheme.tertiary : theme.colorScheme.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Informações da transação
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.category.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Valor e data
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${transaction.amount.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? theme.colorScheme.tertiary : theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(transaction.date),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                statusLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detalhes da Transação',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow('Descrição', transaction.description),
                const SizedBox(height: 16),
                _buildDetailRow('Categoria', transaction.category.name),
                const SizedBox(height: 16),
                _buildDetailRow('Valor', 'R\$ ${transaction.amount.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                _buildDetailRow('Data', _formatDate(transaction.date)),
                const SizedBox(height: 16),
                _buildDetailRow('Tipo', transaction.type == TransactionType.income ? 'Receita' : 'Despesa'),
                const SizedBox(height: 16),
                Builder(
                  builder: (_) {
                    final slip = _slips.firstWhere(
                      (s) => s.id == transaction.id,
                      orElse: () => BankSlip.empty(),
                    );
                    final statusLabel = (slip.isPaid ?? false) ? 'Pago' : 'Pendente';
                    return _buildDetailRow('Status', statusLabel);
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ModernSecondaryButton(
                        text: 'Editar',
                        icon: Icons.edit_rounded,
                        onPressed: () async {
                          Navigator.pop(context);
                          final bankSlip = _slips.firstWhere(
                            (s) => s.id == transaction.id,
                            orElse: () => BankSlip.empty(),
                          );
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExpenseFormScreen(appContext: context, bankSlip: bankSlip),
                            ),
                          );
                          if (updated == true) {
                            await _loadData();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ModernPrimaryButton(
                        text: 'Excluir',
                        icon: Icons.delete_rounded,
                        onPressed: () async {
                          Navigator.pop(context);
                          if (!kIsWeb) {
                            final bs = BankSlip(id: transaction.id, name: '', date: '', value: 0);
                            await IsarDatabase().deleteBankSlipt(bs);
                            await _loadData();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Exclusão direta não suportada no modo web.')),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}