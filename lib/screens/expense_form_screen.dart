import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';
import 'package:zet_gestor_orcamento/components/base_components.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/category.dart';
import 'package:zet_gestor_orcamento/repository/bank_slip_repository.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_event.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_state.dart';
import 'package:zet_gestor_orcamento/database/isar_database.dart';
import 'package:zet_gestor_orcamento/screens/monthly_budget_form_Screen.dart';
import 'package:zet_gestor_orcamento/repository/monthly_budget_repository.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({Key? key, required this.appContext, this.bankSlip}) : super(key: key);

  final BuildContext appContext;
  final BankSlip? bankSlip;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final BankSlipRepository _repo = BankSlipRepository();

  List<Category> _categories = [];
  int? _selectedCategoryId;

  String _selectedMonthlyBudget = '';
  List<String> _monthlyBudgetOptions = [];
  bool _isPaid = false;
  bool _isIncome = false;

  @override
  void initState() {
    super.initState();
    _loadBankSlipData();
  }

  Future<void> _delete() async {
    final slipId = widget.bankSlip?.id ?? 0;
    if (slipId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação inválida para exclusão.')),
      );
      return;
    }

    try {
      if (!kIsWeb) {
        await IsarDatabase().deleteBankSlipt(BankSlip(id: slipId, name: '', date: '', value: 0));
      } else {
        await _repo.delete(slipId);
      }

      if (mounted) {
        // Recarrega o orçamento para refletir mudanças na UI
        context.read<BudgetBloc>().add(const LoadBudget());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transação excluída')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir transação: $e')),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Carregar categorias
    final categories = await _repo.getCategories();

    // Garantir que o Budget esteja carregado antes de popular o dropdown
    final budgetBloc = context.read<BudgetBloc>();
    BudgetState budgetState = budgetBloc.state;
    final monthlyList = <String>[];

    if (budgetState is! BudgetLoaded) {
      budgetBloc.add(const LoadBudget());
      budgetState = await budgetBloc.stream.firstWhere((s) => s is BudgetLoaded || s is BudgetError);
    }

    if (budgetState is BudgetLoaded) {
      final list = budgetState.budget.monthlyBudget ?? [];
      for (var item in list) {
        monthlyList.add('${item.year}-${item.month}');
      }
    } else if (kIsWeb) {
      // Fallback no Web: buscar diretamente do repositório de orçamentos mensais
      final repo = MonthlyBudgetRepository();
      final list = await repo.getMonthlyBudgets();
      for (var item in list) {
        monthlyList.add('${item.year}-${item.month}');
      }
    }

    // Pré-seleção do orçamento mensal baseada na data do slip (se houver)
    String selectedBudget = _selectedMonthlyBudget;
    if (selectedBudget.isEmpty && widget.bankSlip != null && monthlyList.isNotEmpty) {
      try {
        final date = DateTime.tryParse(widget.bankSlip!.date ?? '');
        if (date != null) {
          const months = [
            'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
            'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
          ];
          final monthStr = months[date.month - 1];
          final yearStr = DateFormat('yyyy').format(date);
          final candidate = '$yearStr-$monthStr';
          if (monthlyList.contains(candidate)) {
            selectedBudget = candidate;
          }
        }
      } catch (_) {}
    }

    setState(() {
      _categories = categories;
      if (_categories.isNotEmpty) {
        _selectedCategoryId = _selectedCategoryId ?? _categories.first.id;
      }
      _monthlyBudgetOptions = monthlyList;
      if (_monthlyBudgetOptions.isNotEmpty) {
        _selectedMonthlyBudget = selectedBudget.isNotEmpty ? selectedBudget : _monthlyBudgetOptions.first;
      }
    });
  }

  void _loadBankSlipData() {
    if (widget.bankSlip != null) {
      final slip = widget.bankSlip!;
      _nameController.text = slip.name ?? '';
      final v = slip.value ?? 0;
      _isIncome = v < 0;
      _valueController.text = v.abs().toString();
      _dateController.text = slip.date ?? '';
      _descriptionController.text = slip.description ?? '';
      _selectedCategoryId = slip.categoryId;
      _isPaid = slip.isPaid ?? false;
      // Pré-seleciona orçamento mensal com base na data do slip (yyyy-MM)
      try {
        final date = DateTime.tryParse(slip.date ?? '');
        if (date != null) {
          const months = [
            'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
            'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
          ];
          final monthStr = months[date.month - 1];
          final yearStr = DateFormat('yyyy').format(date);
          final candidate = '$yearStr-$monthStr';
          if (_monthlyBudgetOptions.contains(candidate)) {
            _selectedMonthlyBudget = candidate;
          }
        }
      } catch (_) {}
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  String? _requiredTextValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  String? _valueValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe um valor';
    }
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return 'Valor inválido';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Parse do valor com segurança (suporta vírgula e ponto)
    final rawValue = _valueController.text.trim().replaceAll(',', '.');
    double parsedValue;
    try {
      parsedValue = double.parse(rawValue);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor inválido. Use números com vírgula ou ponto.')),
      );
      return;
    }

    // Aplicar sinal conforme tipo selecionado
    final signedValue = _isIncome ? -parsedValue.abs() : parsedValue.abs();

    // Derivar mês/ano automaticamente a partir da data da despesa
    String _monthYearFromDateStr(String dateStr) {
      try {
        final date = DateTime.tryParse(dateStr);
        if (date == null) return '';
        const months = [
          'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
          'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
        ];
        final monthStr = months[date.month - 1];
        final yearStr = DateFormat('yyyy').format(date);
        return '$yearStr-$monthStr';
      } catch (_) {
        return '';
      }
    }
    final monthYearAuto = _monthYearFromDateStr(_dateController.text.trim());

    final slip = BankSlip(
      id: widget.bankSlip?.id ?? 0,
      name: _nameController.text.trim(),
      date: _dateController.text.trim(),
      value: signedValue,
      categoryId: _selectedCategoryId,
      description: _descriptionController.text.trim(),
      tags: '',
      isPaid: _isPaid,
    );

    if (widget.bankSlip == null) {
      // Adição
      if (kIsWeb) {
        await _repo.add(slip);
        // Recarrega o orçamento para refletir imediatamente no dashboard (web)
        if (mounted) {
          context.read<BudgetBloc>().add(const LoadBudget());
        }
      } else {
        // Associar automaticamente com base na data e aguardar conclusão
        context.read<BudgetBloc>().add(AddBankSlip(slip, monthYearAuto));
        // Espera até que o bloco finalize (Loaded ou Error) para garantir que a escrita
        // na base termine antes de retornar e recarregar a lista
        final doneState = await context
            .read<BudgetBloc>()
            .stream
            .firstWhere((s) => s is BudgetLoaded || s is BudgetError);
        if (doneState is BudgetError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(doneState.message)),
          );
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação adicionada')),
      );
    } else {
      // Atualização
      if (kIsWeb) {
        await _repo.update(slip);
        // Recarrega o orçamento após atualização para refletir no dashboard (web)
        if (mounted) {
          context.read<BudgetBloc>().add(const LoadBudget());
        }
      } else {
        // Atualização direta vinculando automaticamente ao orçamento mensal pela data
        try {
          final date = DateTime.tryParse(slip.date ?? '');
          if (date == null) {
            throw Exception('Data inválida para associar orçamento mensal');
          }
          const months = [
            'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
            'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
          ];
          final month = months[date.month - 1];
          final year = DateFormat('yyyy').format(date);

          final db = IsarDatabase();
          final monthly = await db.getByMonthAndYearMonthlyBudget(month, year);
          var idMonthly = monthly.id ?? 0;

          // Criar orçamento mensal automaticamente se não existir
          if (idMonthly == 0) {
            final created = await db.saveMonthlyBudget(MonthlyBudget(month: month, year: year));
            idMonthly = created?.id ?? 0;
          }

          if (idMonthly == 0) {
            throw Exception('Falha ao criar/recuperar orçamento mensal');
          }

          await db.updateBankSlipt(slip, idMonthly);
          // Recarregar orçamento para refletir a mudança
          context.read<BudgetBloc>().add(const LoadBudget());
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao atualizar orçamento: $e')),
          );
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação atualizada')),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Cores e estilos para chips com melhor contraste
    final expenseSelected = !_isIncome;
    final incomeSelected = _isIncome;
    final chipBg = theme.colorScheme.surfaceVariant.withOpacity(0.6);
    final chipBorder = theme.colorScheme.outline.withOpacity(0.3);
    final expenseLabelColor = expenseSelected
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onSurfaceVariant;
    final incomeLabelColor = incomeSelected
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bankSlip == null ? 'Nova Transação' : 'Editar Transação'),
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernCard(
                  hasShadow: true,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ModernTextField(
                        label: 'Nome',
                        hintText: 'Digite o nome da transação',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.drive_file_rename_outline,
                        validator: _requiredTextValidator,
                      ),
                      const SizedBox(height: 16),
                      ModernTextField(
                        label: 'Valor',
                        hintText: 'Ex: 125.50',
                        controller: _valueController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        prefixIcon: Icons.monetization_on,
                        validator: _valueValidator,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tipo',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Despesa'),
                            selected: !_isIncome,
                            onSelected: (selected) {
                              setState(() {
                                _isIncome = !selected;
                              });
                            },
                            labelStyle: theme.textTheme.bodyMedium?.copyWith(color: expenseLabelColor, fontWeight: FontWeight.w600),
                            selectedColor: theme.colorScheme.errorContainer,
                            backgroundColor: chipBg,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: expenseSelected ? theme.colorScheme.error : chipBorder)),
                            showCheckmark: false,
                          ),
                          ChoiceChip(
                            label: const Text('Receita'),
                            selected: _isIncome,
                            onSelected: (selected) {
                              setState(() {
                                _isIncome = selected;
                              });
                            },
                            labelStyle: theme.textTheme.bodyMedium?.copyWith(color: incomeLabelColor, fontWeight: FontWeight.w600),
                            selectedColor: theme.colorScheme.tertiaryContainer,
                            backgroundColor: chipBg,
                            labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: incomeSelected ? theme.colorScheme.tertiary : chipBorder)),
                            showCheckmark: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Data
                      ModernTextField(
                        label: 'Data',
                        hintText: 'Selecione a data',
                        controller: _dateController,
                        readOnly: true,
                        prefixIcon: Icons.calendar_today,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: _pickDate,
                        ),
                        validator: _requiredTextValidator,
                      ),
                      const SizedBox(height: 16),
                      // Categoria
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categoria',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int?>(
                            value: _selectedCategoryId,
                            items: _categories.map((c) => DropdownMenuItem<int?>(
                              value: c.id,
                              child: Text(c.name),
                            )).toList(),
                            onChanged: (value) => setState(() => _selectedCategoryId = value),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.outline.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ModernTextField(
                        label: 'Descrição',
                        hintText: 'Descrição adicional (opcional)',
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        prefixIcon: Icons.description,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ModernSecondaryButton(
                        text: 'Cancelar',
                        icon: Icons.close_rounded,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.bankSlip != null) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ModernPrimaryButton(
                          text: 'Excluir',
                          icon: Icons.delete_rounded,
                          onPressed: _delete,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ModernPrimaryButton(
                        text: widget.bankSlip == null ? 'Adicionar' : 'Atualizar',
                        icon: Icons.check_circle_outline,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  title: const Text('Marcar como pago'),
                  value: _isPaid,
                  onChanged: (v) => setState(() => _isPaid = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}