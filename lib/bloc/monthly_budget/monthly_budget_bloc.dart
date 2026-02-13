import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeitune_gestor/bloc/monthly_budget/monthly_budget_event.dart';
import 'package:zeitune_gestor/bloc/monthly_budget/monthly_budget_state.dart';
import 'package:zeitune_gestor/repository/monthly_budget_repository.dart';

class MonthlyBudgetBloc extends Bloc<MonthlyBudgetEvent, MonthlyBudgetState> {
  final MonthlyBudgetRepository repo;
  MonthlyBudgetBloc({required this.repo}) : super(MonthlyBudgetState.initial()) {
    on<LoadMonthlyBudgets>(_onLoad);
    on<AddMonthlyBudget>(_onAdd);
    on<UpdateMonthlyBudget>(_onUpdate);
    on<DeleteMonthlyBudget>(_onDelete);
  }

  Future<void> _onLoad(LoadMonthlyBudgets event, Emitter<MonthlyBudgetState> emit) async {
    emit(state.copyWith(loading: true));
    final list = await repo.getMonthlyBudgets();
    emit(state.copyWith(monthlyBudgets: list, loading: false));
  }

  Future<void> _onAdd(AddMonthlyBudget event, Emitter<MonthlyBudgetState> emit) async {
    await repo.addMonthlyBudget(event.monthlyBudget);
    add(const LoadMonthlyBudgets());
  }

  Future<void> _onUpdate(UpdateMonthlyBudget event, Emitter<MonthlyBudgetState> emit) async {
    await repo.updateMonthlyBudget(event.monthlyBudget);
    add(const LoadMonthlyBudgets());
  }

  Future<void> _onDelete(DeleteMonthlyBudget event, Emitter<MonthlyBudgetState> emit) async {
    await repo.deleteMonthlyBudget(event.id);
    add(const LoadMonthlyBudgets());
  }
}