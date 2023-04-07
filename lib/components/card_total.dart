import 'package:flutter/material.dart';

import '../data/budget_Inherited.dart';
import '../database/my_database.dart';

class CardTotal extends StatefulWidget {
  final BuildContext appContext;

  CardTotal({
    super.key,
    required this.appContext,
  });

  @override
  State<CardTotal> createState() => _CardTotalState();
}

class _CardTotalState extends State<CardTotal> {

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
        child: FutureBuilder(
            future: BudgetInherited.of(widget.appContext).getBudget(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.done:
                  var budget = snapshot.data;
                  print('budget: $budget');
                  if (budget != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo: ${budget?.salary}',
                          style: const TextStyle(
                              fontSize: 30, overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          'Gasto: ${budget?.getGasto()}',
                          style: const TextStyle(
                              fontSize: 30, overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          'Poupado: ${budget?.getPoupado()}',
                          style: const TextStyle(
                              fontSize: 30, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    );
                  }
                  return const Text('Não há dados cadastrados');
                  break;
              }
              return Text('Erro');
            }),
      ),
    );
  }
}
