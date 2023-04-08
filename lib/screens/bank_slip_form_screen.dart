import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/menu_drawer.dart';
import 'package:intl/intl.dart';

import '../data/budget_Inherited.dart';
import '../models/bank_slip.dart';

class BankSlipFormScreen extends StatefulWidget {
  const BankSlipFormScreen({Key? key, required this.appContext})
      : super(key: key);

  final BuildContext appContext;

  @override
  State<BankSlipFormScreen> createState() => _BankSlipFormScreenState();
}

class _BankSlipFormScreenState extends State<BankSlipFormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String dropdownValue = '2023-Janeiro';

  List<String> monthlyBudgetStringList = ['2023-Janeiro'];

  bool nameValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }

    return false;
  }

  bool dateValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }

    return false;
  }

  bool valueValidator(String? value) {
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
          title: const Text('Cadastro nova conta'),
        ),
        drawer: const MenuDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              height: 400,
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
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (String? value) {
                        if (nameValidator(value)) {
                          return 'Deve insrir um texto';
                        }
                        return null;
                      },
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.drive_file_rename_outline_outlined),
                        border: OutlineInputBorder(),
                        hintText: 'Digite o nome',
                        labelText: "Nome",
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (String? value) {
                        if (valueValidator(value)) {
                          return 'Deve insrir um número';
                        }
                        return null;
                      },
                      controller: valueController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.monetization_on),
                        border: OutlineInputBorder(),
                        hintText: 'Digite o valor',
                        labelText: "Valor",
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                        hintText: "Digite a data",
                        labelText: "Data",
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(formattedDate);

                          setState(() {
                            dateController.text = formattedDate;
                          });
                        } else {
                          print("Não selecionou uma data");
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                        future:
                            BudgetInherited.of(widget.appContext).getBudget(),
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
                              if (budget != null &&
                                  budget.monthlyBudget != null) {
                                var monthlyBudget = budget.monthlyBudget ?? [];
                                monthlyBudgetStringList.clear();
                                for(var item in monthlyBudget){
                                  monthlyBudgetStringList.add('${item.year}-${item.month}');
                                }
                                return Container(
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
                                      icon: const Icon(
                                          Icons.arrow_circle_down_sharp),
                                      elevation: 10,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.underline),
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropdownValue = value!;
                                        });
                                      },
                                      items: monthlyBudgetStringList
                                          .map((String item) =>
                                              DropdownMenuItem<String>(
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
                                );
                              }
                              return const Text('Não há dados cadastrados');
                              break;
                          }
                          return Text('Erro');
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var bankSlip = BankSlip(
                              value: double.parse(valueController.text),
                              name: nameController.text,
                              date: dateController.text,
                            );

                            BudgetInherited.of(widget.appContext)
                                .addBankSlip(bankSlip, dropdownValue);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Conta cadastrada')));
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
