import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_event.dart';
import 'package:zeitune_gestor/bloc/budget/budget_state.dart';
import 'package:zeitune_gestor/models/budget.dart';

class CardTotal extends StatefulWidget {
  final BuildContext appContext;

  CardTotal({
    super.key,
    required this.appContext,
  });

  @override
  State<CardTotal> createState() => _CardTotalState();
}

class _CardTotalState extends State<CardTotal> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(4),
      ),
      height: 160,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<BudgetBloc, BudgetState>(
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
              
              if (budget != null) {
                // Calcula saldo: receitas (valores negativos) + salário - despesas (valores positivos)
                final allSlips = budget.getAllBankSlips();
                double totalIncome = 0;
                double totalExpenses = 0;
                for (final s in allSlips) {
                  final v = s.value ?? 0;
                  if (v < 0) {
                    totalIncome += v.abs();
                  } else {
                    totalExpenses += v;
                  }
                }
                final saldo = (budget.salary ?? 0) + totalIncome - totalExpenses;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo: ${saldo}',
                      style: const TextStyle(
                          fontSize: 30, overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      'Gasto: ${budget.getGasto()}',
                      style: const TextStyle(
                          fontSize: 30, overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      'Sobrou: ${budget.getPoupado()}',
                      style: const TextStyle(
                          fontSize: 30, overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      'Media de gasto: ${budget.getMedia()}',
                      style: const TextStyle(
                          fontSize: 30, overflow: TextOverflow.ellipsis),
                    )
                  ],
                );
              }
              return const Text('Não há dados cadastrados');
            }
            
            return const Text('Estado desconhecido');
          },
        ),
      ),
    );
  }
}
