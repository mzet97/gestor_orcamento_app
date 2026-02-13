import 'package:equatable/equatable.dart';
import 'package:zeitune_gestor/models/monthly_budget.dart';
import 'package:zeitune_gestor/models/bank_slip.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();
  @override
  List<Object?> get props => [];
}

class LoadBudget extends BudgetEvent {
  const LoadBudget();
}

class AddSalary extends BudgetEvent {
  final double salary;
  const AddSalary(this.salary);
  @override
  List<Object?> get props => [salary];
}

class AddMonthlyBudget extends BudgetEvent {
  final MonthlyBudget monthlyBudget;
  const AddMonthlyBudget(this.monthlyBudget);
  @override
  List<Object?> get props => [monthlyBudget];
}

class RemoveMonthlyBudget extends BudgetEvent {
  final MonthlyBudget monthlyBudget;
  const RemoveMonthlyBudget(this.monthlyBudget);
  @override
  List<Object?> get props => [monthlyBudget];
}

class AddBankSlip extends BudgetEvent {
  final BankSlip bankSlip;
  final String monthYear;
  const AddBankSlip(this.bankSlip, this.monthYear);
  @override
  List<Object?> get props => [bankSlip, monthYear];
}

class RemoveBankSlip extends BudgetEvent {
  final BankSlip bankSlip;
  const RemoveBankSlip(this.bankSlip);
  @override
  List<Object?> get props => [bankSlip];
}