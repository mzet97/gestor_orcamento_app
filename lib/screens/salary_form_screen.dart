import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/menu_drawer.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';

import '../data/budget_Inherited.dart';
import '../database/my_database.dart';

class SalaryFormScreen extends StatefulWidget {
  const SalaryFormScreen({Key? key, required this.appContext})
      : super(key: key);

  final BuildContext appContext;
  @override
  State<SalaryFormScreen> createState() => _SalaryFormScreenState();
}

class _SalaryFormScreenState extends State<SalaryFormScreen> {
  TextEditingController salaryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool salaryValidator(String? value) {
    if (value != null && value.isEmpty) {
      if (double.parse(value) > 0) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Dados'),
        ),
        drawer: const MenuDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              height: 200,
              width: 375,
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (String? value) {
                        if (salaryValidator(value)) {
                          return 'Deve inseir um número maior que 0';
                        }
                        return null;
                      },
                      controller: salaryController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.monetization_on_rounded),
                        border: OutlineInputBorder(),
                        hintText: 'Digite o salário',
                        labelText: "Salario",
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {

                            //MyDatabase().saveBudget(Budget(salary: double.parse(salaryController.text)));
                            BudgetInherited.of(widget.appContext)
                                .addSalary(double.parse(salaryController.text));

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Atualizado seu salario')));
                            Navigator.popAndPushNamed(context, '/');
                          }
                        },
                        child: const Text('Adicionar!')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
