import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/card_total.dart';
import 'package:zet_gestor_orcamento/components/expansion_list_wiget.dart';
import 'package:zet_gestor_orcamento/components/menu_drawer.dart';

class DashBoard extends StatelessWidget {
  final BuildContext appContext;

  const DashBoard({Key? key, required this.appContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: const MenuDrawer(),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          CardTotal(appContext: appContext),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 70),
            child: ExpansionListWiget(),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}


