import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_event.dart';
import 'package:zeitune_gestor/components/base_components.dart';
import 'package:zeitune_gestor/models/monthly_budget.dart';

class MonthlyBudgetFormScreen extends StatefulWidget {
  const MonthlyBudgetFormScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyBudgetFormScreen> createState() => _MonthlyBudgetFormScreenState();
}

class _MonthlyBudgetFormScreenState extends State<MonthlyBudgetFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _yearController = TextEditingController();
  String _selectedMonth = _portugueseMonthNames[DateTime.now().month - 1];
  bool _isLoading = false;

  static const List<String> _portugueseMonthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  String? _yearValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ano é obrigatório';
    }
    final trimmed = value.trim();
    final parsed = int.tryParse(trimmed);
    if (parsed == null) {
      return 'Ano deve ser numérico';
    }
    if (trimmed.length != 4) {
      return 'Ano deve ter 4 dígitos';
    }
    if (parsed < 1900 || parsed > 2100) {
      return 'Ano deve estar entre 1900 e 2100';
    }
    return null;
  }

  String? _monthValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mês é obrigatório';
    }
    if (!_portugueseMonthNames.contains(value)) {
      return 'Selecione um mês válido';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final monthlyBudget = MonthlyBudget(
        month: _selectedMonth,
        year: _yearController.text.trim(),
      );
      
      log("Criando orçamento mensal: $monthlyBudget");
      
      // Usar o BudgetBloc para adicionar o orçamento mensal (mantém budget global coerente)
      context.read<BudgetBloc>().add(AddMonthlyBudget(monthlyBudget));

      if (!mounted) return;

      ModernSnackBar.show(
        context: context,
        message: 'Orçamento mensal adicionado',
        icon: Icons.check_circle_outline,
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        final theme = Theme.of(context);
        ModernSnackBar.show(
          context: context,
          message: 'Erro ao salvar orçamento: $e',
          icon: Icons.error_outline,
          backgroundColor: theme.colorScheme.errorContainer,
          textColor: theme.colorScheme.onErrorContainer,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(
        title: 'Orçamento Mensal',
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
                        label: 'Ano',
                        hintText: 'Ex: 2025',
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.calendar_today_outlined,
                        validator: _yearValidator,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 16),
                      _buildMonthDropdown(),
                      const SizedBox(height: 24),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthDropdown() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mês',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedMonth,
          items: _portugueseMonthNames
              .map((m) => DropdownMenuItem<String>(
                    value: m,
                    child: Text(m),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _selectedMonth = value ?? _selectedMonth),
          validator: _monthValidator,
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
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ModernSecondaryButton(
            text: 'Cancelar',
            icon: Icons.close_rounded,
            onPressed: () => Navigator.pop(context),
            isDisabled: _isLoading,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ModernPrimaryButton(
            text: 'Salvar',
            icon: Icons.check_circle_outline,
            onPressed: _submit,
            isLoading: _isLoading,
            isDisabled: _isLoading,
          ),
        ),
      ],
    );
  }
}