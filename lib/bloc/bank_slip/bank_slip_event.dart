import 'package:equatable/equatable.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';

abstract class BankSlipEvent extends Equatable {
  const BankSlipEvent();
  @override
  List<Object?> get props => [];
}

class LoadBankSlips extends BankSlipEvent {
  const LoadBankSlips();
}

class AddBankSlip extends BankSlipEvent {
  final BankSlip slip;
  const AddBankSlip(this.slip);
  @override
  List<Object?> get props => [slip];
}

class UpdateBankSlip extends BankSlipEvent {
  final BankSlip slip;
  const UpdateBankSlip(this.slip);
  @override
  List<Object?> get props => [slip];
}

class DeleteBankSlip extends BankSlipEvent {
  final int id;
  const DeleteBankSlip(this.id);
  @override
  List<Object?> get props => [id];
}