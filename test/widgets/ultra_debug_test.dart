import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zet_gestor_orcamento/screens/modern_dashboard.dart';

void main() {
  testWidgets('Ultra debug: Verificar se widget existe', (WidgetTester tester) async {
    print('Iniciando teste...');
    
    // Criar widget mais simples possível
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Text('Teste básico'),
        ),
      ),
    );
    
    print('Widget básico criado');
    await tester.pump();
    
    // Verificar se o texto existe
    expect(find.text('Teste básico'), findsOneWidget);
    print('Texto encontrado!');
    
    // Agora testar o ModernDashboard
    await tester.pumpWidget(
      MaterialApp(
        home: const ModernDashboard(),
      ),
    );
    
    print('ModernDashboard criado');
    await tester.pump(const Duration(milliseconds: 1000));
    
    // Verificar se existe algum widget
    final allWidgets = tester.allWidgets;
    print('Total de widgets encontrados: ${allWidgets.length}');
    
    for (final widget in allWidgets.take(10)) {
      print('Widget: ${widget.runtimeType}');
    }
  });
}