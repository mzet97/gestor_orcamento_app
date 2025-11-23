import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bank_slip.dart';
import '../models/category.dart';
import '../models/budget.dart';
import '../models/financial_insight.dart';

class InsightsService {
  static List<FinancialInsight> generateInsights(
    List<BankSlip> expenses,
    List<Category> categories,
    Budget? budget,
  ) {
    List<FinancialInsight> insights = [];
    
    // Análise de gastos por categoria
    insights.addAll(_analyzeCategorySpending(expenses, categories));
    
    // Análise de tendências
    insights.addAll(_analyzeSpendingTrends(expenses));
    
    // Alertas de orçamento
    if (budget != null) {
      insights.addAll(_analyzeBudgetAlerts(expenses, budget));
    }
    
    // Gastos incomuns
    insights.addAll(_detectUnusualExpenses(expenses));
    
    // Ordenar por prioridade (High = 3, Medium = 2, Low = 1)
    insights.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    
    return insights.take(10).toList(); // Limitar a 10 insights
  }
  
  static List<FinancialInsight> _analyzeCategorySpending(
    List<BankSlip> expenses,
    List<Category> categories,
  ) {
    List<FinancialInsight> insights = [];
    
    // Agrupar gastos por categoria
    Map<int?, double> categorySpending = {};
    for (var expense in expenses) {
      categorySpending[expense.categoryId] = 
        (categorySpending[expense.categoryId] ?? 0) + (expense.value ?? 0);
    }
    
    // Verificar categorias com limite de orçamento
    for (var category in categories) {
      if (category.budgetLimit > 0) {
        double spent = categorySpending[category.id] ?? 0;
        double percentage = (spent / category.budgetLimit) * 100;
        
        if (percentage >= 90) {
          insights.add(FinancialInsight.budgetWarning(
            category: category.name,
            spent: spent,
            limit: category.budgetLimit,
            percentage: percentage,
          ));
        }
      }
    }
    
    // Identificar categoria com maior gasto
    if (categorySpending.isNotEmpty) {
      var maxCategory = categorySpending.entries.reduce((a, b) => 
        a.value > b.value ? a : b);
      
      var categoryName = categories
        .firstWhere((c) => c.id == maxCategory.key, orElse: () => 
          Category(id: maxCategory.key ?? 0, name: 'Sem categoria', 
            description: '', color: Colors.black, icon: Icons.help_outline, 
            budgetLimit: 0, createdAt: DateTime.now()))
        .name;
      
      insights.add(FinancialInsight(
        id: 'spending_analysis_${Random().nextInt(1000)}',
        type: InsightType.categoryAnalysis,
        priority: InsightPriority.medium,
        title: 'Maior gasto por categoria',
        description: '$categoryName representa ${maxCategory.value.toStringAsFixed(2)} do total de gastos',
        actionText: 'Ver detalhes',
        relatedAmount: maxCategory.value,
        relatedCategory: categoryName,
        relatedDate: DateTime.now(),
        createdAt: DateTime.now(),
      ));
    }
    
    return insights;
  }
  
  static List<FinancialInsight> _analyzeSpendingTrends(List<BankSlip> expenses) {
    List<FinancialInsight> insights = [];
    
    // Agrupar por mês
    Map<String, double> monthlySpending = {};
    for (var expense in expenses) {
      if (expense.date != null) {
        String monthKey = DateFormat('yyyy-MM').format(DateTime.parse(expense.date!));
        monthlySpending[monthKey] = (monthlySpending[monthKey] ?? 0) + (expense.value ?? 0);
      }
    }
    
    // Analisar tendência dos últimos 3 meses
    if (monthlySpending.length >= 2) {
      var sortedMonths = monthlySpending.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      
      var recentMonths = sortedMonths.sublist(sortedMonths.length > 3 ? sortedMonths.length - 3 : 0);
      
      if (recentMonths.length >= 2) {
        double firstMonth = recentMonths.first.value;
        double lastMonth = recentMonths.last.value;
        double variation = ((lastMonth - firstMonth) / firstMonth) * 100;
        
        if (variation.abs() > 20) {
          String trend = variation > 0 ? 'aumento' : 'redução';
          insights.add(FinancialInsight.monthlyTrend(
            currentMonth: lastMonth,
            previousMonth: firstMonth,
            trend: trend,
          ));
        }
      }
    }
    
    return insights;
  }
  
  static List<FinancialInsight> _analyzeBudgetAlerts(
    List<BankSlip> expenses,
    Budget budget,
  ) {
    List<FinancialInsight> insights = [];
    
    double totalSpent = expenses.fold(0, (sum, expense) => sum + (expense.value ?? 0));
    double budgetLimit = budget.salary ?? 0;
    double percentage = (totalSpent / budgetLimit) * 100;
    
    if (percentage >= 80) {
      insights.add(FinancialInsight.budgetWarning(
        category: 'Orçamento Geral',
        spent: totalSpent,
        limit: budgetLimit,
        percentage: percentage,
      ));
    }
    
    return insights;
  }
  
  static List<FinancialInsight> _detectUnusualExpenses(List<BankSlip> expenses) {
    List<FinancialInsight> insights = [];
    
    if (expenses.isEmpty) return insights;
    
    // Calcular média e desvio padrão
    double average = expenses.map((e) => e.value ?? 0).reduce((a, b) => a + b) / expenses.length;
    double variance = expenses.map((e) => pow((e.value ?? 0) - average, 2)).reduce((a, b) => a + b) / expenses.length;
    double standardDeviation = sqrt(variance);
    
    // Identificar gastos acima de 2 desvios padrão
    double threshold = average + (2 * standardDeviation);
    
    var unusualExpenses = expenses.where((expense) => (expense.value ?? 0) > threshold).toList();
    
    for (var expense in unusualExpenses.take(3)) {
      insights.add(FinancialInsight.unusualExpense(
        amount: expense.value ?? 0,
        category: expense.name ?? 'Gasto desconhecido',
        average: average,
      ));
    }
    
    return insights;
  }
  
  // Gerar sugestões de economia
  static List<FinancialInsight> generateSavingOpportunities(
    List<BankSlip> expenses,
    List<Category> categories,
  ) {
    List<FinancialInsight> insights = [];
    
    // Identificar categorias com gastos recorrentes altos
    Map<String, List<BankSlip>> categoryExpenses = {};
    for (var expense in expenses) {
      var categoryName = categories
        .firstWhere((c) => c.id == expense.categoryId, orElse: () => 
          Category(id: expense.categoryId ?? 0, name: 'Sem categoria', 
            description: '', color: Colors.black, icon: Icons.help_outline, 
            budgetLimit: 0, createdAt: DateTime.now()))
        .name;
      
      categoryExpenses.putIfAbsent(categoryName, () => []).add(expense);
    }
    
    for (var entry in categoryExpenses.entries) {
      double total = entry.value.fold(0.0, (sum, e) => sum + (e.value ?? 0));
      if (total > 500) { // Gasto alto na categoria
      insights.add(FinancialInsight.savingOpportunity(
        potentialSaving: total - 500,
        category: entry.key,
        suggestion: 'Reduza gastos desnecessários nesta categoria',
      ));
      }
    }
    
    return insights;
  }
}