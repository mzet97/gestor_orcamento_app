import 'package:equatable/equatable.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';

class BankSlipState extends Equatable {
  final List<BankSlip> slips;
  final bool loading;
  final String? error;

  const BankSlipState({
    required this.slips,
    this.loading = false,
    this.error,
  });

  factory BankSlipState.initial() => const BankSlipState(slips: [], loading: true);

  BankSlipState copyWith({
    List<BankSlip>? slips,
    bool? loading,
    String? error,
  }) {
    return BankSlipState(
      slips: slips ?? this.slips,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [slips, loading, error];
}