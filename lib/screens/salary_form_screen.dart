import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_event.dart';
import 'package:zeitune_gestor/bloc/budget/budget_state.dart';
import 'package:zeitune_gestor/components/base_components.dart';

class SalaryFormScreen extends StatefulWidget {
  const SalaryFormScreen({super.key});

  @override
  State<SalaryFormScreen> createState() => _SalaryFormScreenState();
}

class _SalaryFormScreenState extends State<SalaryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _salaryController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pré-preencher com salário atual, se disponível
    final state = context.read<BudgetBloc>().state;
    if (state is BudgetLoaded) {
      final current = state.budget.salary ?? 0.0;
      _salaryController.text = _formatCurrencyInput(current);
    }
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  String _formatCurrencyInput(double value) {
    // Formatação simples com duas casas decimais e separador decimal vírgula
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  double _parseCurrency(String raw) {
    // Aceita valores com vírgula ou ponto como separador decimal
    final normalized = raw.trim().replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  String? _salaryValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o valor do salário';
    }
    final parsed = _parseCurrency(value);
    if (parsed <= 0) {
      return 'Salário deve ser maior que 0';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final salary = _parseCurrency(_salaryController.text);

    try {
      log('Atualizando salário: $salary');
      context.read<BudgetBloc>().add(AddSalary(salary));

      if (!mounted) return;
      ModernSnackBar.show(
        context: context,
        message: 'Salário atualizado',
        icon: Icons.check_circle_outline,
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        final theme = Theme.of(context);
        ModernSnackBar.show(
          context: context,
          message: 'Erro ao salvar salário: $e',
          icon: Icons.error_outline,
          backgroundColor: theme.colorScheme.errorContainer,
          textColor: theme.colorScheme.onErrorContainer,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(title: 'Salário mensal'),
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
                        label: 'Valor do salário',
                        hintText: 'Ex: 5.000,00',
                        controller: _salaryController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        prefixIcon: Icons.payments_outlined,
                        validator: _salaryValidator,
                        textInputAction: TextInputAction.done,
                      ),
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