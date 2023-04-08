import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/card_total.dart';
import 'package:zet_gestor_orcamento/components/expansion_list_wiget.dart';
import 'package:zet_gestor_orcamento/components/menu_drawer.dart';

class DashBoard extends StatefulWidget {
  final BuildContext appContext;

  const DashBoard({Key? key, required this.appContext}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {
          setState(() {

          });
        }, icon: Icon(Icons.refresh))],
        title: Text('Home'),
      ),
      drawer: const MenuDrawer(),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          CardTotal(appContext: widget.appContext),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 70),
            child: ExpansionListWiget(appContext: widget.appContext),
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
