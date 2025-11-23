import 'package:equatable/equatable.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();
  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

class BudgetLoaded extends BudgetState {
  final Budget budget;
  const BudgetLoaded(this.budget);
  @override
  List<Object?> get props => [budget];
}

class BudgetError extends BudgetState {
  final String message;
  const BudgetError(this.message);
  @override
  List<Object?> get props => [message];
}