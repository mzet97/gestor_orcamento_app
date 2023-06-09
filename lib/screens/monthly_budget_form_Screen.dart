import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/menu_drawer.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

import '../data/budget_Inherited.dart';
import '../database/my_database.dart';

class MonthlyBudgetFormScreen extends StatefulWidget {
  const MonthlyBudgetFormScreen({Key? key, required this.appContext})
      : super(key: key);

  final BuildContext appContext;

  @override
  State<MonthlyBudgetFormScreen> createState() =>
      _MonthlyBudgetFormScreenState();
}

class _MonthlyBudgetFormScreenState extends State<MonthlyBudgetFormScreen> {
  TextEditingController yearController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> months = <String>[
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  String dropdownValue = 'Janeiro';

  bool yearValidator(String? value) {
    if (value != null && value.isEmpty) {
      if (int.parse(value) > 2000 && int.parse(value) < 3000) {
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
          title: const Text('Cadastro gasto mensal'),
        ),
        drawer: const MenuDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 250,
              width: 375,
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (String? value) {
                        if (yearValidator(value)) {
                          return 'Deve insrir um ano valido';
                        }
                        return null;
                      },
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_month_outlined),
                        border: OutlineInputBorder(),
                        hintText: 'Digite o ano',
                        labelText: 'Ano',
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white70,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.greenAccent[200],
                        value: dropdownValue,
                        underline: Container(),
                        borderRadius: BorderRadius.circular(12),
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        elevation: 10,
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: months
                            .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                )))
                            .toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var monthlyBudget = MonthlyBudget(
                                month: dropdownValue,
                                year: yearController.text);

                            BudgetInherited.of(widget.appContext)
                                .addMonthlyBudget(monthlyBudget);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Gasto do mes cadastrado')));
                            Navigator.popAndPushNamed(context, '/');
                          }
                        },
                        child: const Text(
                          'Adicionar',
                          style: TextStyle(fontSize: 22),
                        )),
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
