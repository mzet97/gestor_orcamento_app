import 'package:zeitune_gestor/models/bank_slip.dart';

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

  MonthlyBudget.withId({required int id}) {
    this.id = id;
    isExpanded = false;
    bankSilps = [];
  }

  MonthlyBudget.formMap(Map<String, dynamic> map) {
    id = map['id'];
    month = map['month'];
    year = map['year'];
    isExpanded = false;
  }

  // Corrigir serialização para Map com chaves estáticas
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'year': year,
    };
  }

  // Adicionar fromMap compatível com o repositório
  factory MonthlyBudget.fromMap(Map<String, dynamic> map) {
    return MonthlyBudget(
      id: map['id'] ?? 0,
      month: map['month'],
      year: map['year'],
      isExpanded: false,
    );
  }

  // Adicionar copyWith usado pelo repositório (ex.: gerar novo id)
  MonthlyBudget copyWith({
    int? id,
    String? month,
    String? year,
    List<BankSlip>? bankSilps,
    bool? isExpanded,
  }) {
    return MonthlyBudget(
      id: id ?? this.id,
      month: month ?? this.month,
      year: year ?? this.year,
      bankSilps: bankSilps ?? this.bankSilps,
      isExpanded: isExpanded ?? this.isExpanded,
    );
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