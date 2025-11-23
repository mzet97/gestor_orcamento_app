import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/components/menu_header.dart';
import 'package:zet_gestor_orcamento/screens/monthly_budget_form_Screen.dart';
import 'package:zet_gestor_orcamento/screens/expense_form_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const MenuHeader(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Novo gasto mensal'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MonthlyBudgetFormScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Nova conta'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExpenseFormScreen(appContext: context)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text('Meus dados'),
            onTap: () {
              Navigator.pushNamed(context, '/salary');
            },
          ),
          const AboutListTile(
            // <-- SEE HERE
            icon: Icon(
              Icons.info,
            ),
            child: Text('Sobre'),
            applicationIcon: Icon(
              Icons.local_play,
            ),
            applicationName: 'Gestor Orcamento',
            applicationVersion: '0.0.1',
            applicationLegalese: 'mzet1997© 2023 Company',
            aboutBoxChildren: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Desevolvidor por Matheus Zeitune',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'E-mail para contato: matheus.zeitune.developer@gmai.com',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
