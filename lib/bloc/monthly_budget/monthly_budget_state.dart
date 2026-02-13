import 'package:equatable/equatable.dart';
import 'package:zeitune_gestor/models/monthly_budget.dart';

class MonthlyBudgetState extends Equatable {
  final List<MonthlyBudget> monthlyBudgets;
  final bool loading;
  final String? error;

  const MonthlyBudgetState({
    required this.monthlyBudgets,
    this.loading = false,
    this.error,
  });

  factory MonthlyBudgetState.initial() => const MonthlyBudgetState(monthlyBudgets: [], loading: true);

  MonthlyBudgetState copyWith({
    List<MonthlyBudget>? monthlyBudgets,
    bool? loading,
    String? error,
  }) {
    return MonthlyBudgetState(
      monthlyBudgets: monthlyBudgets ?? this.monthlyBudgets,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [monthlyBudgets, loading, error];
}