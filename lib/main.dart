import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/data/budget_Inherited.dart';
import 'package:zet_gestor_orcamento/screens/bank_slip_form_screen.dart';
import 'package:zet_gestor_orcamento/screens/dashboard_screen.dart';
import 'package:zet_gestor_orcamento/screens/monthly_budget_form_Screen.dart';
import 'package:zet_gestor_orcamento/screens/salary_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BudgetInherited(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (contextNew) => DashBoard(
            appContext: contextNew,
          ),
          '/salary': (contextNew) => SalaryFormScreen(
            appContext: contextNew,
          ),
          '/monthly': (contextNew) => MonthlyBudgetFormScreen(
            appContext: contextNew,
          ),
          '/bank': (contextNew) => BankSlipFormScreen(
            appContext: contextNew,
          )
        },
      ),
    );
  }
}