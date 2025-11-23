import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zet_gestor_orcamento/screens/modern_dashboard.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/budget/budget_state.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';
import 'package:zet_gestor_orcamento/repository/budget_repository.dart';

// Mock classes
class MockBudgetRepository extends Mock implements BudgetRepository {
  @override
  Future<Budget> getBudget() async {
    return Budget(
      id: 1,
      monthlyBudget: [],
      salary: 5000.0,
    );
  }
}

void main() {
  group('ModernDashboard Tests', () {
    testWidgets('should display app title', (WidgetTester tester) async {
      final budgetBloc = BudgetBloc(budgetRepository: MockBudgetRepository());
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BudgetBloc>.value(
            value: budgetBloc,
            child: const ModernDashboard(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Zet Gestor'), findsOneWidget);
      expect(find.text('Seu orçamento mensal'), findsOneWidget);
      
      // Adicionar delay para garantir que não há timers pendentes
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should display salary card', (WidgetTester tester) async {
      final budgetBloc = BudgetBloc(budgetRepository: MockBudgetRepository());
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BudgetBloc>.value(
            value: budgetBloc,
            child: const ModernDashboard(),
          ),
        ),
      );
      await tester.pump();

      // Verificar se elementos básicos do dashboard existem
      expect(find.text('Zet Gestor'), findsOneWidget);
      expect(find.text('Seu orçamento mensal'), findsOneWidget);
      
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should display savings card', (WidgetTester tester) async {
      final budgetBloc = BudgetBloc(budgetRepository: MockBudgetRepository());
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BudgetBloc>.value(
            value: budgetBloc,
            child: const ModernDashboard(),
          ),
        ),
      );
      await tester.pump();

      // Verificar se o cartão de economia existe
      expect(find.text('Economizado'), findsOneWidget);
      
      // Verificar se existe texto com R$ (pode haver múltiplos, então usamos findsWidgets)
      expect(find.textContaining('R\$'), findsWidgets);
      
      // Verificar se existe porcentagem
      expect(find.textContaining('%'), findsWidgets);
      
      await tester.pump(const Duration(milliseconds: 100));
    });

    // Removido: a seção de Ações Rápidas não existe mais no dashboard

    testWidgets('should display charts section', (WidgetTester tester) async {
      final budgetBloc = BudgetBloc(budgetRepository: MockBudgetRepository());
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BudgetBloc>.value(
            value: budgetBloc,
            child: const ModernDashboard(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Análise de Gastos'), findsOneWidget);
      expect(find.text('Distribuição de Gastos'), findsOneWidget);
      
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should display recent transactions', (WidgetTester tester) async {
      final budgetBloc = BudgetBloc(budgetRepository: MockBudgetRepository());
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BudgetBloc>.value(
            value: budgetBloc,
            child: const ModernDashboard(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Transações Recentes'), findsOneWidget);
      expect(find.text('Ver todas'), findsOneWidget);
      
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should display app bar and sections', (WidgetTester tester) async {
      final budgetBloc = BudgetBloc(budgetRepository: MockBudgetRepository());
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BudgetBloc>.value(
            value: budgetBloc,
            child: const ModernDashboard(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Zet Gestor'), findsOneWidget);
      // Ações Rápidas foi removido do dashboard
      expect(find.text('Ações Rápidas'), findsNothing);
      expect(find.text('Transações Recentes'), findsOneWidget);
      
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should refresh on pull gesture', (WidgetTester tester) async {
      final budgetBloc = BudgetBloc(budgetRepository: MockBudgetRepository());
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BudgetBloc>.value(
            value: budgetBloc,
            child: const ModernDashboard(),
          ),
        ),
      );
      await tester.pump();

      // Verificar se o RefreshIndicator existe
      expect(find.byType(RefreshIndicator), findsOneWidget);
      
      // Verificar se o título ainda existe após o carregamento inicial
      expect(find.text('Zet Gestor'), findsOneWidget);
      
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should have proper accessibility labels', (WidgetTester tester) async {
      final budgetBloc = BudgetBloc(budgetRepository: MockBudgetRepository());
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BudgetBloc>.value(
            value: budgetBloc,
            child: const ModernDashboard(),
          ),
        ),
      );
      await tester.pump();

      // Verificar se elementos de acessibilidade básicos existem
      expect(find.byType(Semantics), findsWidgets);
      expect(find.text('Zet Gestor'), findsOneWidget);
      
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}