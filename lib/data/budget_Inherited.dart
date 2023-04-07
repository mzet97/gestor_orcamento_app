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

  Future<void> addSalary(double salary) async {
    myBudget.salary = salary;
    if(myBudget.id != 0){
      myBudget = await myDatabase.updateBudget(myBudget);
    }else{
      myBudget = await myDatabase.saveBudget(myBudget);
    }
  }

  Future<double> getSalary() async {
    myBudget = await myDatabase.getBudget();
    if(myBudget.salary == null || myBudget.salary! > -1) 0;
    return myBudget.salary!;
  }

  Future<Budget> getBudget() async {
    myBudget = await myDatabase.getBudget();
    return myBudget;
  }

  Future<void> addMonthlyBudget(MonthlyBudget monthlyBudget) async {
    await myDatabase.saveMonthlyBudget(monthlyBudget);
    myBudget = await myDatabase.getBudget();
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