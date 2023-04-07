import 'package:zet_gestor_orcamento/models/bank_slip.dart';

class MonthlyBudget {
  int? id;
  String? month;
  String? year;
  List<BankSlip>? bankSilps;
  bool? isExpanded;

  MonthlyBudget.empty(){
    id = 0;
    bankSilps = [];
    isExpanded = false;
  }

  MonthlyBudget({
    required this.month,
    required this.year,
    this.isExpanded = false,
    this.bankSilps,
    this.id = 0
  });

  MonthlyBudget.formMap(Map<String, dynamic> map) {
    id = map['id'];
    month = map['month'];
    year = map['year'];
    isExpanded = false;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      month!: month!,
      year!: year!,
    };
    map['id'] = id;
    return map;
  }

  void adicionarConta(BankSlip bankSlip){
    bankSilps ??= <BankSlip>[];
    bankSilps!.add(bankSlip);
  }

  double obterTotal(){
    double total = 0;

    if(bankSilps != null){
      for (var bankSlip in bankSilps!) {
        total += bankSlip.value!;
      }
    }

    return total;
  }

  @override
  String toString() {
    return "MonthlyBudget(id: $id, month: $month, year:$year)";
  }
}