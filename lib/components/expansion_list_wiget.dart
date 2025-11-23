import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_event.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_state.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

class ExpansionListWiget extends StatefulWidget {
  final BuildContext appContext;

  ExpansionListWiget({super.key, required this.appContext});

  @override
  State<ExpansionListWiget> createState() => _ExpansionListWigetState();
}

class _ExpansionListWigetState extends State<ExpansionListWiget> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, budgetState) {
        if (budgetState is BudgetInitial) {
          context.read<BudgetBloc>().add(const LoadBudget());
          return const Center(child: CircularProgressIndicator());
        }
        
        if (budgetState is BudgetLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (budgetState is BudgetError) {
          return Center(child: Text('Erro: ${budgetState.message}'));
        }
        
        if (budgetState is BudgetLoaded) {
          final budget = budgetState.budget;
          return ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                // budget?.monthlyBudget?[index].isExpanded = !isExpanded;
                // print(isExpanded);
              });
            },
            children: getMonthlyBudgetWidget(budget?.monthlyBudget),
          );
        }
        
        return const Text('Estado desconhecido');
      },
    );
  }

  List<ExpansionPanel> getMonthlyBudgetWidget(List<MonthlyBudget>? list) {
    List<ExpansionPanel> exp = [];

    if (list != null && list.isNotEmpty) {
      for (MonthlyBudget monthlyBudget in list) {
        print('monthlyBudget: $monthlyBudget');
        exp.add(ExpansionPanel(
          backgroundColor: Colors.green[200],
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              onLongPress: (){
                setState(() {
                  context.read<BudgetBloc>().add(RemoveMonthlyBudget(monthlyBudget));
                });
              },
              title: Text('Ano: ${monthlyBudget.year} | Mês: ${monthlyBudget.month} | Total:${monthlyBudget.obterTotal()}'),
            );
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: getBankSlipWidget(monthlyBudget.bankSilps),
          ),
          isExpanded: true,
        ));
      }
    }

    return exp;
  }

  List<Widget> getBankSlipWidget(List<BankSlip>? bankSilps) {
    List<Widget> childs = [];

    if(bankSilps != null && bankSilps.isNotEmpty){
      for(BankSlip bankSlip in bankSilps){
        print('bankSlip: $bankSlip');
        childs.add(Container(
          color: Colors.amber[100],
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
          child: ListTile(
              title: Text(bankSlip.name!),
              subtitle: Text('${bankSlip.value}'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  context.read<BudgetBloc>().add(RemoveBankSlip(bankSlip));
                });
              }),
        ));
      }
    }

    return childs;
  }
}
