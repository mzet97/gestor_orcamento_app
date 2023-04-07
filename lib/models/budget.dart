import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

class Budget {
  int? id;
  List<MonthlyBudget>? monthlyBudget;
  double? salary;

  Budget.empty(){
    id = 0;
    salary = 0;
    monthlyBudget = [];
  }

  Budget({
    required this.salary,
    this.monthlyBudget,
    this.id = 0
  });

  Budget.formMap(Map<String, dynamic> map) {
    id = map['id'];
    salary =  map['salary'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'salary': salary,
    };
    map['id'] = id;
    return map;
  }

  double getGasto(){
    if(monthlyBudget != null){
      return 1;
    }
    return 0;
  }

  double getPoupado(){
    if(monthlyBudget != null){
      return 1;
    }
    return 0;
  }

  @override
  String toString() {
    return "Budget(id: $id, salary: $salary)";
  }
}
