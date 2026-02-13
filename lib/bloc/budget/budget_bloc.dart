import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeitune_gestor/bloc/budget/budget_event.dart';
import 'package:zeitune_gestor/bloc/budget/budget_state.dart';
import 'package:zeitune_gestor/repository/budget_repository.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository _budgetRepository;

  BudgetBloc({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(const BudgetInitial()) {
    on<LoadBudget>(_onLoadBudget);
    on<AddSalary>(_onAddSalary);
    on<AddMonthlyBudget>(_onAddMonthlyBudget);
    on<RemoveMonthlyBudget>(_onRemoveMonthlyBudget);
    on<AddBankSlip>(_onAddBankSlip);
    on<RemoveBankSlip>(_onRemoveBankSlip);
  }

  Future<void> _onLoadBudget(LoadBudget event, Emitter<BudgetState> emit) async {
    try {
      emit(const BudgetLoading());
      final budget = await _budgetRepository.getBudget();
      emit(BudgetLoaded(budget));
    } catch (e) {
      emit(BudgetError('Erro ao carregar orçamento: $e'));
    }
  }

  Future<void> _onAddSalary(AddSalary event, Emitter<BudgetState> emit) async {
    try {
      emit(const BudgetLoading());
      final budget = await _budgetRepository.addSalary(event.salary);
      emit(BudgetLoaded(budget));
    } catch (e) {
      emit(BudgetError('Erro ao adicionar salário: $e'));
    }
  }

  Future<void> _onAddMonthlyBudget(AddMonthlyBudget event, Emitter<BudgetState> emit) async {
    try {
      emit(const BudgetLoading());
      final budget = await _budgetRepository.addMonthlyBudget(event.monthlyBudget);
      emit(BudgetLoaded(budget));
    } catch (e) {
      emit(BudgetError('Erro ao adicionar orçamento mensal: $e'));
    }
  }

  Future<void> _onRemoveMonthlyBudget(RemoveMonthlyBudget event, Emitter<BudgetState> emit) async {
    try {
      emit(const BudgetLoading());
      final budget = await _budgetRepository.removeMonthlyBudget(event.monthlyBudget);
      emit(BudgetLoaded(budget));
    } catch (e) {
      emit(BudgetError('Erro ao remover orçamento mensal: $e'));
    }
  }

  Future<void> _onAddBankSlip(AddBankSlip event, Emitter<BudgetState> emit) async {
    try {
      emit(const BudgetLoading());
      final budget = await _budgetRepository.addBankSlip(event.bankSlip, event.monthYear);
      emit(BudgetLoaded(budget));
    } catch (e) {
      emit(BudgetError('Erro ao adicionar despesa: $e'));
    }
  }

  Future<void> _onRemoveBankSlip(RemoveBankSlip event, Emitter<BudgetState> emit) async {
    try {
      emit(const BudgetLoading());
      final budget = await _budgetRepository.removeBankSlip(event.bankSlip);
      emit(BudgetLoaded(budget));
    } catch (e) {
      emit(BudgetError('Erro ao remover despesa: $e'));
    }
  }
}