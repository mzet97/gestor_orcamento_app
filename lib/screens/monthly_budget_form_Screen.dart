import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/menu_drawer.dart';
import 'package:zet_gestor_orcamento/data/budget_Inherited.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

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

  bool monthValidator(String? value) {
    // if (value != null && value.isEmpty) {
    //   if (int.parse(value) > 2000 && int.parse(value) < 3000) {
    //     return true;
    //   }
    // }

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
                        if (monthValidator(value)) {
                          return 'Deve insrir um ano valido';
                        }
                        return null;
                      },
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Ano',
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    dropdownColor: Colors.blue[200],
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 10,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 1,
                      color: Colors.blue,
                    ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
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
                          'Adicionar!',
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
