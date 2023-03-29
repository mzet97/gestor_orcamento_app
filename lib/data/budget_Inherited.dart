import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/database/my_database.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';

import '../models/monthly_budget.dart';

class BudgetInherited extends InheritedWidget {
  BudgetInherited({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  Budget myBudget = Budget(salary: 0,);
  MyDatabase myDatabase = MyDatabase();

  void addSalary(double salary) {
    myBudget.salary = salary;
    if(myBudget.id != 0){
      myDatabase.updateBudget(myBudget).then((value) => myBudget = value);
    }else{
      myDatabase.saveBudget(myBudget).then((value) => myBudget = value);
    }
  }

  double getSalary(){
    myDatabase.getBudget().then((value) => myBudget = value);
    if(myBudget.salary == null || myBudget.salary! > -1) 0;
    return myBudget.salary!;
  }

  void addMonthlyBudget(MonthlyBudget monthlyBudget){
    myBudget.monthlyBudget ??= <MonthlyBudget>[];
    myBudget.monthlyBudget!.add(monthlyBudget);
  }

  static BudgetInherited of(BuildContext context) {
    final BudgetInherited? result = context.dependOnInheritedWidgetOfExactType<BudgetInherited>();
    assert(result != null, 'No BudgetInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(BudgetInherited old) {
    return old.myBudget.monthlyBudget!.length != myBudget.monthlyBudget!.length;
  }
}
