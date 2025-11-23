import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zet_gestor_orcamento/screens/modern_dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_bloc.dart';
import 'package:zet_gestor_orcamento/repository/budget_repository.dart';

Widget createTestableWidget(Widget child) {
  return MaterialApp(
    home: BlocProvider<BudgetBloc>(
      create: (context) => BudgetBloc(budgetRepository: BudgetRepository()),
      child: child,
    ),
  );
}

void main() {
  testWidgets('Debug BLoC: Verificar renderização com dados',
      (WidgetTester tester) async {
    print('Iniciando teste com BLoC...');

    await tester.pumpWidget(createTestableWidget(const ModernDashboard()));
    print('Widget criado');

    // Esperar o BLoC carregar
    await tester.pump(const Duration(milliseconds: 500));
    print('Primeiro pump');

    // Verificar se existe algum widget
    final allWidgets = tester.allWidgets.toList();
    print('Total de widgets encontrados: ${allWidgets.length}');

    // Procurar por textos específicos
    final textWidgets = tester.widgetList<Text>(find.byType(Text));
    print('Textos encontrados:');
    for (final textWidget in textWidgets) {
      print(
          '  - "${textWidget.data ?? textWidget.textSpan?.toPlainText() ?? "sem texto"}"');
    }

    // Procurar por AppBar
    final appBars = find.byType(AppBar);
    print('AppBars encontradas: ${appBars.evaluate().length}');

    // Procurar por Scaffold
    final scaffolds = find.byType(Scaffold);
    print('Scaffolds encontrados: ${scaffolds.evaluate().length}');

    // Se não encontrar nada, verificar se existe algum widget não-nulo
    if (allWidgets.isEmpty) {
      print('Nenhum widget encontrado!');
    } else {
      print('Primeiros 5 widgets:');
      for (int i = 0; i < 5 && i < allWidgets.length; i++) {
        print('  ${i + 1}. ${allWidgets[i].runtimeType}');
      }
    }
  }