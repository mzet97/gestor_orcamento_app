import 'package:equatable/equatable.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

abstract class MonthlyBudgetEvent extends Equatable {
  const MonthlyBudgetEvent();
  @override
  List<Object?> get props => [];
}

class LoadMonthlyBudgets extends MonthlyBudgetEvent {
  const LoadMonthlyBudgets();
}

class AddMonthlyBudget extends MonthlyBudgetEvent {
  final MonthlyBudget monthlyBudget;
  const AddMonthlyBudget(this.monthlyBudget);
  @override
  List<Object?> get props => [monthlyBudget];
}

class UpdateMonthlyBudget extends MonthlyBudgetEvent {
  final MonthlyBudget monthlyBudget;
  const UpdateMonthlyBudget(this.monthlyBudget);
  @override
  List<Object?> get props => [monthlyBudget];
}

class DeleteMonthlyBudget extends MonthlyBudgetEvent {
  final int id;
  const DeleteMonthlyBudget(this.id);
  @override
  List<Object?> get props => [id];
}