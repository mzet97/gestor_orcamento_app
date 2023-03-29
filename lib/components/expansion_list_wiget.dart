import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

List<MonthlyBudget> generateItems(int numberOfItems) {
  return List<MonthlyBudget>.generate(numberOfItems, (int index) {
    List<BankSlip> bSlip = <BankSlip>[];
    bSlip.add(BankSlip(
        id: index,
        date: DateTime.now().toString(),
        name: 'Luz $index',
        value: index * 10));
    return MonthlyBudget(month: '$index', year: '2023', bankSilps: bSlip);
  });
}

class ExpansionListWiget extends StatefulWidget {
  const ExpansionListWiget({super.key});

  @override
  State<ExpansionListWiget> createState() => _ExpansionListWigetState();
}

class _ExpansionListWigetState extends State<ExpansionListWiget> {
  final List<MonthlyBudget> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  List<Widget> getList() {
    List<Widget> childs = [];
    for (var i = 0; i < _data.length; i++) {
      var item = _data[i].bankSilps![0];
      childs.add(Container(
        color: Colors.amber[100],
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        child: ListTile(
            title: Text(item.name!),
            subtitle: Text('${item.value}'),
            trailing: const Icon(Icons.delete),
            onTap: () {
              setState(() {
                // _data.removeWhere((Item currentItem) => item == currentItem);
              });
            }),
      ));
    }
    return childs;
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((MonthlyBudget item) {
        return ExpansionPanel(
          backgroundColor: Colors.green[200],
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('Mês: ${item.month}'),
            );
          },
          body: Column(
            children: getList(),
          ),
          isExpanded: item.isExpanded!,
        );
      }).toList(),
    );
  }
}
