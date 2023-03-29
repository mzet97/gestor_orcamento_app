import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/data/budget_Inherited.dart';

class CardTotal extends StatelessWidget {
  final BuildContext appContext;

  const CardTotal({
    super.key, required this.appContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(4),
      ),
      height: 140,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Text(
                  'Saldo: ${BudgetInherited.of(appContext).getSalary()}',
                  style: TextStyle(
                      fontSize: 30, overflow: TextOverflow.ellipsis),
                )),
            Container(
                child: Text(
                  'Gasto: 5000',
                  style: TextStyle(
                      fontSize: 30, overflow: TextOverflow.ellipsis),
                )),
            Container(
                child: Text(
                  'Poupado: 1000',
                  style: TextStyle(
                      fontSize: 30, overflow: TextOverflow.ellipsis),
                ))
          ],
        ),
      ),
    );
  }
}
