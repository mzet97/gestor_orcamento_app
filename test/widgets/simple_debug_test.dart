import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zet_gestor_orcamento/screens/modern_dashboard.dart';

void main() {
  testWidgets('Simple debug', (WidgetTester tester) async {
    print('Iniciando teste...');

    try {
      await tester.pumpWidget(const MaterialApp(home: ModernDashboard()));
      print('Widget criado');

      await tester.pump(const Duration(milliseconds: 1000));
      print('Pump executado');

      final allWidgets = tester.allWidgets.toList();
      print('Total de widgets: ${allWidgets.length}');
    } catch (e)