// categories_screen.dart - Tela de categorias
import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/base_components.dart';
import 'package:zet_gestor_orcamento/models/category.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/repository/bank_slip_repository.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Todas';
  bool _showBudgetExceeded = false;
  final _repo = BankSlipRepository();
  List<Category> _categories = [];
  List<BankSlip> _slips = [];
  Map<int, double> _spentByCategory = {};
  bool _loading = true;

  final List<String> _filters = [
    'Todas',
    'Com orçamento',
    'Sem orçamento',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final categories = await _repo.getCategories();
    final slips = await _repo.getAll();

    final spent = <int, double>{};
    for (final slip in slips) {
      final cid = slip.categoryId ?? 0;
      if (cid > 0) {
        spent[cid] = (spent[cid] ?? 0) + (slip.value ?? 0);
      }
    }

    setState(() {
      _categories = categories;
      _slips = slips;
      _spentByCategory = spent;
      _loading = false;
    });
  }

  double get _totalBudget => _categories.fold(0.0, (sum, c) => sum + c.budgetLimit);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ModernAppBar(
        title: 'Categorias',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              setState(() {
                _showBudgetExceeded = !_showBudgetExceeded;
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
              hintText: 'Buscar categorias...',
              prefixIcon: Icons.search_rounded,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),

            // Filtros
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

            // Resumo de orçamento
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
                          'Total de Categorias',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_categories.length}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
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
                          'Orçamento Total',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'R\$ ${_totalBudget.toStringAsFixed(2)}',
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

            // Lista de categorias
            Expanded(
              child: _buildCategoriesList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(),
        backgroundColor: theme.colorScheme.primary,
        child: Icon(
          Icons.add_rounded,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredCategories = _filterCategories(_categories);

    if (filteredCategories.isEmpty) {
      return ModernEmptyState(
        icon: Icons.category_rounded,
        title: 'Nenhuma categoria encontrada',
        description:
            'Crie sua primeira categoria para começar a organizar suas finanças.',
        buttonText: 'Adicionar Categoria',
        onButtonPressed: () => _showAddCategoryDialog(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return _buildCategoryItem(category);
      },
    );
  }

  List<Category> _filterCategories(List<Category> categories) {
    var filtered = categories.where((category) {
      final name = category.name ?? '';
      final matchesSearch =
          _searchQuery.isEmpty || name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesFilter = true;
      if (_selectedFilter == 'Com orçamento') {
        matchesFilter = (category.budgetLimit) > 0;
      } else if (_selectedFilter == 'Sem orçamento') {
        matchesFilter = (category.budgetLimit) == 0;
      }

      return matchesSearch && matchesFilter;
    }).toList();

    if (_showBudgetExceeded) {
      filtered = filtered.where((category) {
        final budget = category.budgetLimit;
        final spent = _spentByCategory[category.id ?? 0] ?? 0;
        return spent > budget && budget > 0;
      }).toList();
    }

    return filtered.toList();
  }

  Widget _buildCategoryItem(Category category) {
    final theme = Theme.of(context);
    final name = category.name;
    final iconData = category.icon;
    final color = category.color;
    final budget = category.budgetLimit;
    final spent = _spentByCategory[category.id ?? -1] ?? 0.0;
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final isBudgetExceeded = budget > 0 && spent > budget;

    return ModernCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      onTap: () => _showCategoryDetails(category),
      child: Column(
        children: [
          Row(
            children: [
              // Ícone da categoria
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconData,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Informações da categoria
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isBudgetExceeded) ...[
                          const SizedBox(width: 8),
                          ModernBadge(
                            text: 'Excedido',
                            backgroundColor: theme.colorScheme.errorContainer,
                            textColor: theme.colorScheme.onErrorContainer,
                            icon: Icons.warning_rounded,
                          ),
                        ],
                      ],
                    ),
                    if (budget > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gasto: R\$ ${spent.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Orçamento: R\$ ${budget.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isBudgetExceeded
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: theme.colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isBudgetExceeded
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      Text(
                        'Total: R\$ ${spent.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    final budgetController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Categoria'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModernTextField(
                label: 'Nome da categoria',
                hintText: 'Ex.: Alimentação, Moradia, Transporte',
                controller: nameController,
              ),
              const SizedBox(height: 12),
              ModernTextField(
                label: 'Orçamento mensal (R\$)',
                hintText: 'Ex.: 500.00',
                keyboardType: TextInputType.number,
                controller: budgetController,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ModernPrimaryButton(
            text: 'Adicionar',
            onPressed: () async {
              final name = nameController.text.trim();
              final budget = double.tryParse(budgetController.text.trim()) ?? 0;
              if (name.isEmpty) return;

              final category = Category(
                name: name,
                description: '',
                budgetLimit: budget,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.category_rounded,
                createdAt: DateTime.now(),
              );

              await _repo.addCategory(category);
              Navigator.pop(context);
              await _loadData();
            },
          ),
        ],
      ),
    );
  }

  void _showCategoryDetails(Category category) {
    final theme = Theme.of(context);
    final color = category.color;
    final iconData = category.icon;
    final spent = _spentByCategory[category.id ?? -1] ?? 0.0;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detalhes da Categoria',
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
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    iconData,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    category.name ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (category.budgetLimit > 0) ...[
              _buildDetailRow('Orçamento', 'R\$ ${category.budgetLimit.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              _buildDetailRow('Gasto', 'R\$ ${spent.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              _buildDetailRow('Disponível',
                  'R\$ ${(category.budgetLimit - spent).toStringAsFixed(2)}'),
            ] else ...[
              _buildDetailRow('Total', 'R\$ ${spent.toStringAsFixed(2)}'),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ModernSecondaryButton(
                    text: 'Editar',
                    icon: Icons.edit_rounded,
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditCategoryDialog(category);
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
                      await _repo.deleteCategory(category.id!);
                      await _loadData();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCategoryDialog(Category category) {
    final nameController = TextEditingController(text: category.name ?? '');
    final budgetController = TextEditingController(text: category.budgetLimit.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Categoria'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModernTextField(
                label: 'Nome da categoria',
                hintText: 'Ex.: Alimentação, Moradia, Transporte',
                controller: nameController,
              ),
              const SizedBox(height: 12),
              ModernTextField(
                label: 'Orçamento mensal (R\$)',
                hintText: 'Ex.: 500.00',
                keyboardType: TextInputType.number,
                controller: budgetController,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ModernPrimaryButton(
            text: 'Salvar',
            onPressed: () async {
              final name = nameController.text.trim();
              final budget = double.tryParse(budgetController.text.trim()) ?? 0;
              if (name.isEmpty) return;

              final updated = category.copyWith(
                name: name,
                budgetLimit: (budget < 0 ? 0 : double.parse(budget.toStringAsFixed(2))),
              );

              await _repo.updateCategory(updated);
              Navigator.pop(context);
              await _loadData();
            },
          ),
        ],
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