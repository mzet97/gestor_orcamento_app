import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/menu_drawer.dart';

class BankSlipFormScreen extends StatefulWidget {
  const BankSlipFormScreen({Key? key, required this.appContext}) : super(key: key);

  final BuildContext appContext;

  @override
  State<BankSlipFormScreen> createState() => _BankSlipFormScreenState();
}

class _BankSlipFormScreenState extends State<BankSlipFormScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro nova conta'),
        ),
        drawer: const MenuDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              height: 650,
              width: 375,
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3)),
            ),
          ),
        ),
      ),
    );
  }
}
