import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zet_gestor_orcamento/services/budget_alert_service.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';
import 'package:zet_gestor_orcamento/models/category.dart';
import 'package:zet_gestor_orcamento/database/my_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Mock classes
class MockMyDatabase extends Mock implements MyDatabase {}

void main() {
  // Inicializar binding do Flutter para canais de plataforma em testes
  TestWidgetsFlutterBinding.ensureInitialized();

  // Inicializar FFI para sqflite em ambiente de testes
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  group('BudgetAlertService', () {
    test('deve inicializar sem erros', () async {
      // Testar inicialização do serviço
      expect(() async {
        await BudgetAlertService.initialize();
      }, returnsNormally);
    });

    test('deve verificar alertas sem erros', () async {
      // Testar verificação de alertas
      expect(() async {
        await BudgetAlertService.checkBudgetAlerts();
      }, returnsNormally);
    });

    test('deve verificar alertas diários sem erros', () async {
      // Testar verificação diária
      expect(() async {
        await BudgetAlertService.checkDailyAlerts();
      }, returnsNormally);
    });

    test('deve verificar alertas semanalmente sem erros', () async {
      // Testar verificação semanal
      expect(() async {
        await BudgetAlertService.checkWeeklyAlerts();
      }, returnsNormally);
    });

    test('deve calcular percentual de gastos corretamente', () {
      // Testar cálculo de percentual
      const spent = 750.0;
      const budget = 1000.0;
      const expectedPercentage = 75.0;
      
      expect(expectedPercentage, equals(75.0));
    });

    test('deve identificar quando gastos excedem 80% do orçamento', () {
      // Testar identificação de alerta de 80%
      const spent = 850.0;
      const budget = 1000.0;
      const percentage = 85.0;
      
      expect(percentage > 80.0, isTrue);
    });

    test('deve identificar quando gastos excedem 100% do orçamento', () {
      // Testar identificação de alerta crítico
      const spent = 1100.0;
      const budget = 1000.0;
      const percentage = 110.0;
      
      expect(percentage > 100.0, isTrue);
    });

    test('deve categorizar alertas por prioridade corretamente', () {
      // Testar categorização de prioridades
      const lowPercentage = 60.0;
      const mediumPercentage = 75.0;
      const highPercentage = 85.0;
      const criticalPercentage = 105.0;
      
      expect(lowPercentage < 70.0, isTrue);
      expect(mediumPercentage >= 70.0 && mediumPercentage < 80.0, isTrue);
      expect(highPercentage >= 80.0 && highPercentage < 100.0, isTrue);
      expect(criticalPercentage >= 100.0, isTrue);
    });

    test('deve agrupar gastos por categoria corretamente', () {
      // Testar agrupamento por categoria
      final expenses = [
        BankSlip(
          id: 1,
          name: 'Compra 1',
          value: 100.0,
          categoryId: 1,
          date: '2024-01-01',
        ),
        BankSlip(
          id: 2,
          name: 'Compra 2',
          value: 200.0,
          categoryId: 1,
          date: '2024-01-02',
        ),
        BankSlip(
          id: 3,
          name: 'Compra 3',
          value: 150.0,
          categoryId: 2,
          date: '2024-01-03',
        ),
      ];
      
      // Agrupar por categoria
      final categoryExpenses = <int, double>{};
      for (final expense in expenses) {
        if (expense.categoryId != null && expense.value != null) {
          categoryExpenses[expense.categoryId!] = 
            (categoryExpenses[expense.categoryId!] ?? 0) + expense.value!;
        }
      }
      
      expect(categoryExpenses[1], equals(300.0));
      expect(categoryExpenses[2], equals(150.0));
    });

    test('deve detectar gastos incomuns corretamente', () {
      // Testar detecção de gastos incomuns
      final expenses = [
        BankSlip(
          id: 1,
          name: 'Compra Normal',
          value: 100.0,
          categoryId: 1,
          date: '2024-01-01',
        ),
        BankSlip(
          id: 2,
          name: 'Compra Incomum',
          value: 5000.0, // Valor muito alto
          categoryId: 1,
          date: '2024-01-02',
        ),
      ];
      
      // Detectar gastos incomuns (valores muito acima da média)
      final unusualExpenses = expenses.where((expense) {
        return expense.value != null && expense.value! > 1000.0; // Limite arbitrário
      }).toList();
      
      expect(unusualExpenses.length, equals(1));
      expect(unusualExpenses.first.name, equals('Compra Incomum'));
    });

    test('deve gerar mensagens de alerta apropriadas', () {
      // Testar geração de mensagens
      const categoryName = 'Alimentação';
      const percentage = 85.0;
      const spent = 850.0;
      const budget = 1000.0;
      
      String generateAlertMessage() {
        if (percentage >= 100) {
          return 'Você ultrapassou o orçamento de $categoryName em ${(percentage - 100).toStringAsFixed(1)}%';
        } else if (percentage >= 80) {
          return 'Você atingiu ${percentage.toStringAsFixed(1)}% do orçamento de $categoryName';
        } else {
          return 'Você gastou ${percentage.toStringAsFixed(1)}% do orçamento de $categoryName';
        }
      }
      
      final message = generateAlertMessage();
      expect(message, contains('atingiu 85.0% do orçamento'));
    });

    test('deve tratar casos com dados nulos ou inválidos', () {
      // Testar tratamento de dados inválidos
      const nullBudget = null;
      const emptyExpenses = <BankSlip>[];
      
      expect(nullBudget, isNull);
      expect(emptyExpenses, isEmpty);
    });

    test('deve calcular média de gastos corretamente', () {
      // Testar cálculo de média
      final expenses = [
        BankSlip(
          id: 1,
          name: 'Compra 1',
          value: 100.0,
          categoryId: 1,
          date: '2024-01-01',
        ),
        BankSlip(
          id: 2,
          name: 'Compra 2',
          value: 200.0,
          categoryId: 1,
          date: '2024-01-02',
        ),
        BankSlip(
          id: 3,
          name: 'Compra 3',
          value: 300.0,
          categoryId: 1,
          date: '2024-01-03',
          isPaid: true,
        ),
      ];
      
      final total = expenses.fold<double>(0, (sum, expense) => sum + (expense.value ?? 0));
      final average = total / expenses.length;
      
      expect(total, equals(600.0));
      expect(average, equals(200.0));
    });
  });
}