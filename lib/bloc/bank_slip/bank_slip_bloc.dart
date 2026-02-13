import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeitune_gestor/bloc/bank_slip/bank_slip_event.dart';
import 'package:zeitune_gestor/bloc/bank_slip/bank_slip_state.dart';
import 'package:zeitune_gestor/repository/bank_slip_repository.dart';
import 'package:zeitune_gestor/models/bank_slip.dart';

class BankSlipBloc extends Bloc<BankSlipEvent, BankSlipState> {
  final BankSlipRepository repo;
  BankSlipBloc({required this.repo}) : super(BankSlipState.initial()) {
    on<LoadBankSlips>(_onLoad);
    on<AddBankSlip>(_onAdd);
    on<UpdateBankSlip>(_onUpdate);
    on<DeleteBankSlip>(_onDelete);
  }

  Future<void> _onLoad(LoadBankSlips event, Emitter<BankSlipState> emit) async {
    emit(state.copyWith(loading: true));
    final list = await repo.getAll();
    emit(state.copyWith(slips: list, loading: false));
  }

  Future<void> _onAdd(AddBankSlip event, Emitter<BankSlipState> emit) async {
    await repo.add(event.slip);
    add(const LoadBankSlips());
  }

  Future<void> _onUpdate(UpdateBankSlip event, Emitter<BankSlipState> emit) async {
    await repo.update(event.slip);
    add(const LoadBankSlips());
  }

  Future<void> _onDelete(DeleteBankSlip event, Emitter<BankSlipState> emit) async {
    // Para web usamos SharedPreferences, para não-web usamos Isar via telas existentes
    final current = await repo.getAll();
    final toDelete = current.firstWhere((e) => e.id == event.id, orElse: () => BankSlip.empty());
    if (toDelete.id != null && toDelete.id != 0) {
      // Web não tem delete direto; vamos atualizar lista removendo
      // Em não-web, a remoção é feita nas telas atuais; aqui apenas reflete o estado
      final updated = current.where((e) => e.id != event.id).toList();
      emit(state.copyWith(slips: updated));
    }
    add(const LoadBankSlips());
  }
}