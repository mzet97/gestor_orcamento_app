import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

class Budget {
  int? id;
  List<MonthlyBudget>? monthlyBudget;
  double? salary;

  Budget.empty();

  Budget({
    required this.salary,
    this.monthlyBudget,
    this.id = 0
  });

  Budget.formMap(Map map) {
    id = map['id'];
    salary = map['salary'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      'salary': salary,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Budget(id: $id, name: $salary)";
  }
}
