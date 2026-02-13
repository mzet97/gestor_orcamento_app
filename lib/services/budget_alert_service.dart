import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/bank_slip.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../database/my_database.dart';

class BudgetAlertService {
  static final FlutterLocalNotificationsPlugin _notifications = 
    FlutterLocalNotificationsPlugin();
  
  static Future<void> initialize() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      
      await _notifications.initialize(initializationSettings);
    } catch (e) {
      debugPrint('Falha ao inicializar notificações: $e');
    }
  }
  
  static Future<void> checkBudgetAlerts() async {
    try {
      // Carregar dados
      final expenses = await MyDatabase().getAllBankSlip();
      final budget = await MyDatabase().getBudget();
      final categories = await MyDatabase().getCategories();
      
      if (budget == null) return;
      
      // Verificar alertas de orçamento geral
      await _checkGeneralBudgetAlert(expenses, budget);
      
      // Verificar alertas por categoria
      await _checkCategoryBudgetAlerts(expenses, categories);
      
    } catch (e) {
      // Silently handle errors in production
    }
  }
  
  static Future<void> _checkGeneralBudgetAlert(
    List<BankSlip> expenses,
    Budget budget,
  ) async {
    final now = DateTime.now();
    final currentMonthExpenses = expenses.where((expense) {
      if (expense.date == null) return false;
      
      // Converter string de data para DateTime
      DateTime? expenseDate;
      try {
        expenseDate = DateTime.parse(expense.date!);
      } catch (e) {
        return false;
      }
      
      return expenseDate.year == now.year && expenseDate.month == now.month;
    }).toList();
    
    final totalSpent = currentMonthExpenses.fold(0.0, (sum, expense) => sum + (expense.value ?? 0));
    final budgetLimit = budget.salary ?? 0;
    
    if (budgetLimit <= 0) return;

    final percentage = (totalSpent / budgetLimit) * 100;
    
    // Alerta de 80% do orçamento
    if (percentage >= 80 && percentage < 95) {
      await _showNotification(
        'Alerta de Orçamento',
        'Você já gastou ${percentage.toStringAsFixed(1)}% do seu orçamento mensal (R\$ ${totalSpent.toStringAsFixed(2)} de R\$ ${budgetLimit.toStringAsFixed(2)})',
        importance: Importance.high,
      );
    }
    
    // Alerta de 95% do orçamento
    if (percentage >= 95 && percentage < 100) {
      await _showNotification(
        'Alerta Crítico de Orçamento',
        'Você já gastou ${percentage.toStringAsFixed(1)}% do seu orçamento mensal! Restam apenas R\$ ${(budgetLimit - totalSpent).toStringAsFixed(2)}',
        importance: Importance.high,
      );
    }
    
    // Alerta de orçamento ultrapassado
    if (percentage >= 100) {
      await _showNotification(
        'Orçamento Ultrapassado',
        'Você ultrapassou seu orçamento mensal em R\$ ${(totalSpent - budgetLimit).toStringAsFixed(2)}',
        importance: Importance.max,
      );
    }
  }
  
  static Future<void> _checkCategoryBudgetAlerts(
    List<BankSlip> expenses,
    List<Category> categories,
  ) async {
    final now = DateTime.now();
    final currentMonthExpenses = expenses.where((expense) {
      if (expense.date == null) return false;
      
      // Converter string de data para DateTime
      DateTime? expenseDate;
      try {
        expenseDate = DateTime.parse(expense.date!);
      } catch (e) {
        return false;
      }
      
      return expenseDate.year == now.year && expenseDate.month == now.month;
    }).toList();
    
    // Agrupar gastos por categoria
    Map<int?, double> categorySpending = {};
    for (var expense in currentMonthExpenses) {
      categorySpending[expense.categoryId] = 
        (categorySpending[expense.categoryId] ?? 0) + (expense.value ?? 0);
    }
    
    // Verificar cada categoria com limite
    for (var category in categories) {
      if (category.budgetLimit > 0) {
        double spent = categorySpending[category.id] ?? 0;
        double percentage = (spent / category.budgetLimit) * 100;
        
        if (percentage >= 90 && percentage < 100) {
          await _showNotification(
            'Alerta de Categoria: ${category.name}',
            'Você já gastou ${percentage.toStringAsFixed(1)}% do limite da categoria ${category.name}',
            importance: Importance.high,
          );
        }
        
        if (percentage >= 100) {
          await _showNotification(
            'Limite de Categoria Ultrapassado',
            'Você ultrapassou o limite da categoria ${category.name} em R\$ ${(spent - category.budgetLimit).toStringAsFixed(2)}',
            importance: Importance.max,
          );
        }
      }
    }
  }
  
  static Future<void> _showNotification(
    String title,
    String body, {
    Importance importance = Importance.high,
  }) async {
    try {
      // Configurar detalhes da notificação
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'budget_alerts_channel',
        'Alertas de Orçamento',
        channelDescription: 'Notificações sobre limites de orçamento',
        importance: importance,
        priority: Priority.high,
        ticker: 'ticker',
      );
      
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        platformChannelSpecifics,
      );
    } catch (e) {
      // Silently handle errors in production
    }
  }
  
  // Método para verificar alertas diariamente (pode ser chamado por um agendador)
  static Future<void> checkDailyAlerts() async {
    await checkBudgetAlerts();
  }
  
  // Método para verificar alertas semanalmente
  static Future<void> checkWeeklyAlerts() async {
    await checkBudgetAlerts();
  }
}