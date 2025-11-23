import 'package:flutter_test/flutter_test.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';

void main() {
  group('Budget Model Tests', () {
    test('should create Budget with default values', () {
      final budget = Budget.empty();
      
      expect(budget.salary, 0);
      expect(budget.monthlyBudget, isEmpty);
    });

    test('should create Budget with custom salary', () {
      final budget = Budget(
        salary: 5000.0,
      );
      
      expect(budget.salary, 5000.0);
    });

    test('should calculate savings correctly with no expenses', () {
      final budget = Budget(
        salary: 5000.0,
      );
      
      expect(budget.getPoupado(), 5000.0); // Sem despesas
    });

    test('should convert to Map correctly', () {
      final budget = Budget(
        salary: 5000.0,
      );
      
      final map = budget.toMap();
      
      expect(map['salary'], 5000.0);
      expect(map['id'], 0);
    });

    test('should create from Map correctly', () {
      final map = {
        'id': 1,
        'salary': 5000.0,
      };
      
      final budget = Budget.formMap(map);
      
      expect(budget.salary, 5000.0);
      expect(budget.id, 1);
    });

    test('should create empty Budget correctly', () {
      final budget = Budget.empty();
      
      expect(budget.salary, 0);
      expect(budget.monthlyBudget, isEmpty);
    });
  });
}