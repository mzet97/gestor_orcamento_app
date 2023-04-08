import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/database/my_database.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';

import '../models/bank_slip.dart';
import '../models/monthly_budget.dart';

class BudgetInherited extends InheritedWidget {
  BudgetInherited({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  Budget myBudget = Budget(
    salary: 0,
  );
  MyDatabase myDatabase = MyDatabase();

  Future<void> addSalary(double salary) async {
    myBudget.salary = salary;
    if (myBudget.id != 0) {
      myBudget = await myDatabase.updateBudget(myBudget);
    } else {
      myBudget = await myDatabase.saveBudget(myBudget);
    }
  }

  Future<double> getSalary() async {
    myBudget = await myDatabase.getBudget();
    if (myBudget.salary == null || myBudget.salary! > -1) 0;
    return myBudget.salary!;
  }

  Future<Budget> getBudget() async {
    myBudget = await myDatabase.getBudget();
    for(MonthlyBudget mt in myBudget.monthlyBudget ?? []){
      print('mt: $mt');
      for(BankSlip sb in mt.bankSilps ?? []){
        print('sb: $sb');
      }
    }
    return myBudget;
  }

  Future<void> addMonthlyBudget(MonthlyBudget monthlyBudget) async {
    await myDatabase.saveMonthlyBudget(monthlyBudget);
    myBudget = await myDatabase.getBudget();
  }

  Future<void> removeMonthlyBudget(MonthlyBudget monthlyBudget) async {
    await myDatabase.deleteMonthlyBudget(monthlyBudget);
    myBudget = await myDatabase.getBudget();
  }

  Future<void> addBankSlip(BankSlip bankSlip, String monthYear) async {
    String year = monthYear.split('-')[0];
    String month = monthYear.split('-')[1];
    var monthlyBudget = await myDatabase.getByMonthAndYearMonthlyBudget(month, year);
    int id = monthlyBudget.id ?? 1;
    var bds = await myDatabase.saveBankSlip(bankSlip, id);
    myBudget = await myDatabase.getBudget();
  }

  Future<void> removeBankSlip(BankSlip bankSlip) async {
    await myDatabase.deleteBankSlipt(bankSlip);
    myBudget = await myDatabase.getBudget();
  }

  bool compare(BudgetInherited old) {
    if (old.myBudget == null && myBudget != null) {
      return old.myBudget == null && myBudget != null;
    }
    if ((old.myBudget != null && myBudget != null) &&
        ((old.myBudget.salary != myBudget.salary) ||
            (old.myBudget.id != myBudget.id) ||
            (old.myBudget.monthlyBudget!.length !=
                myBudget.monthlyBudget!.length) ||
            (old.myBudget.monthlyBudget == null &&
                myBudget.monthlyBudget! != null))) {
      return (old.myBudget != null && myBudget != null) &&
          ((old.myBudget.salary != myBudget.salary) ||
              (old.myBudget.id != myBudget.id) ||
              (old.myBudget.monthlyBudget!.length !=
                  myBudget.monthlyBudget!.length) ||
              (old.myBudget.monthlyBudget == null &&
                  myBudget.monthlyBudget! != null));
    }

    if (old.myBudget != null &&
        myBudget != null &&
        old.myBudget.monthlyBudget != null &&
        myBudget.monthlyBudget != null) {
      var oldMonthlyBudgets = old.myBudget.monthlyBudget ?? [];
      var monthlyBudgets = myBudget.monthlyBudget ?? [];
      for (MonthlyBudget oldMonthlyBudget in oldMonthlyBudgets) {
        for (MonthlyBudget monthlyBudget in monthlyBudgets) {
          if(oldMonthlyBudget.id != monthlyBudget.id)  return true;
          if(oldMonthlyBudget.year != monthlyBudget.year)  return true;
          if(oldMonthlyBudget.month != monthlyBudget.month)  return true;
          var oldBankSilps = oldMonthlyBudget.bankSilps ?? [];
          var bankSilps = monthlyBudget.bankSilps ?? [];
          for(BankSlip oldBankSlip in oldBankSilps){
            for(BankSlip bankSlip in bankSilps){
              if(oldBankSlip.id != bankSlip.id)  return true;
              if(oldBankSlip.name != bankSlip.name)  return true;
              if(oldBankSlip.value != bankSlip.value)  return true;
              if(oldBankSlip.date != bankSlip.date)  return true;
            }
          }
        }
      }
    }

    return false;
  }

  static BudgetInherited of(BuildContext context) {
    final BudgetInherited? result =
        context.dependOnInheritedWidgetOfExactType<BudgetInherited>();
    assert(result != null, 'No BudgetInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(BudgetInherited old) {
    return compare(old);
  }
}
