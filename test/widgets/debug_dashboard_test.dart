import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zet_gestor_orcamento/screens/modern_dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_bloc.dart';
import 'package:zet_gestor_orcamento/repository/budget_repository.dart';

Widget createTestableWidget(Widget child) {
  return MaterialApp(
    home: BlocProvider(
      create: (context) => BudgetBloc(budgetRepository: BudgetRepository()),
      child: child,
    ),
  );
}

void main() {
  testWidgets('Debug: Verificar o que é renderizado', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const ModernDashboard()));
    await tester.pump(const Duration(milliseconds: 1000));

    // Debug: imprimir todos os textos encontrados
    final textWidgets = tester.widgetList<Text>(find.byType(Text));
    print('Textos encontrados:');
    for (final textWidget in textWidgets) {
      print('  - "${textWidget.data}"');
    }

    // Verificar se existe algum texto
    expect(find.byType(Text), findsWidgets);
  });
}