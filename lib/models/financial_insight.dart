import 'package:flutter/material.dart';

enum InsightType {
  spendingPattern,
  budgetAlert,
  savingOpportunity,
  unusualExpense,
  categoryAnalysis,
  monthlyTrend,
  recommendation,
}

enum InsightPriority {
  low,
  medium,
  high,
  critical,
}

class FinancialInsight {
  final String id;
  final InsightType type;
  final InsightPriority priority;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onAction;
  final double? relatedAmount;
  final String? relatedCategory;
  final DateTime? relatedDate;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  bool isRead;
  bool isDismissed;

  FinancialInsight({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
    this.relatedAmount,
    this.relatedCategory,
    this.relatedDate,
    this.metadata,
    DateTime? createdAt,
    this.isRead = false,
    this.isDismissed = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'title': title,
      'description': description,
      'actionText': actionText,
      'relatedAmount': relatedAmount,
      'relatedCategory': relatedCategory,
      'relatedDate': relatedDate?.toIso8601String(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead ? 1 : 0,
      'isDismissed': isDismissed ? 1 : 0,
    };
  }

  factory FinancialInsight.fromMap(Map<String, dynamic> map) {
    return FinancialInsight(
      id: map['id'],
      type: InsightType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
      ),
      priority: InsightPriority.values.firstWhere(
        (e) => e.toString().split('.').last == map['priority'],
      ),
      title: map['title'],
      description: map['description'],
      actionText: map['actionText'],
      relatedAmount: map['relatedAmount']?.toDouble(),
      relatedCategory: map['relatedCategory'],
      relatedDate: map['relatedDate'] != null 
          ? DateTime.parse(map['relatedDate']) 
          : null,
      metadata: map['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(map['createdAt']),
      isRead: map['isRead'] == 1,
      isDismissed: map['isDismissed'] == 1,
    );
  }

  // Cores baseadas na prioridade
  Color get color {
    switch (priority) {
      case InsightPriority.critical:
        return Colors.red;
      case InsightPriority.high:
        return Colors.orange;
      case InsightPriority.medium:
        return Colors.amber;
      case InsightPriority.low:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (type) {
      case InsightType.spendingPattern:
        return Icons.trending_up;
      case InsightType.budgetAlert:
        return Icons.warning;
      case InsightType.savingOpportunity:
        return Icons.savings;
      case InsightType.unusualExpense:
        return Icons.error_outline;
      case InsightType.categoryAnalysis:
        return Icons.category;
      case InsightType.monthlyTrend:
        return Icons.calendar_today;
      case InsightType.recommendation:
        return Icons.lightbulb_outline;
    }
  }

  // Geradores de insights baseados em análises
  static FinancialInsight budgetWarning({
    required String category,
    required double spent,
    required double limit,
    required double percentage,
  }) {
    return FinancialInsight(
      id: 'budget_warning_${category}_${DateTime.now().millisecondsSinceEpoch}',
      type: InsightType.budgetAlert,
      priority: percentage >= 100 ? InsightPriority.critical : 
                percentage >= 90 ? InsightPriority.high :
                percentage >= 75 ? InsightPriority.medium : InsightPriority.low,
      title: percentage >= 100 ? 'Orçamento Estourado!' : 
             percentage >= 90 ? 'Quase no Limite' : 'Atenção ao Orçamento',
      description: 'Você já gastou ${spent.toStringAsFixed(2)} em $category (limite: ${limit.toStringAsFixed(2)}). '
                  'Isso representa ${percentage.toStringAsFixed(1)}% do orçamento.',
      relatedAmount: spent,
      relatedCategory: category,
      relatedDate: DateTime.now(),
      metadata: {
        'spent': spent,
        'limit': limit,
        'percentage': percentage,
      },
    );
  }

  static FinancialInsight unusualExpense({
    required double amount,
    required String category,
    required double average,
  }) {
    final difference = ((amount - average) / average) * 100;
    
    return FinancialInsight(
      id: 'unusual_expense_${category}_${DateTime.now().millisecondsSinceEpoch}',
      type: InsightType.unusualExpense,
      priority: difference > 200 ? InsightPriority.high : InsightPriority.medium,
      title: 'Gasto Incomum Detectado',
      description: 'Gasto de ${amount.toStringAsFixed(2)} em $category está ${difference > 0 ? '${difference.toStringAsFixed(0)}% acima' : '${difference.abs().toStringAsFixed(0)}% abaixo'} '
                  'da média habitual (${average.toStringAsFixed(2)}).',
      relatedAmount: amount,
      relatedCategory: category,
      relatedDate: DateTime.now(),
      metadata: {
        'amount': amount,
        'average': average,
        'difference': difference,
      },
    );
  }

  static FinancialInsight savingOpportunity({
    required double potentialSaving,
    required String category,
    required String suggestion,
  }) {
    return FinancialInsight(
      id: 'saving_opportunity_${category}_${DateTime.now().millisecondsSinceEpoch}',
      type: InsightType.savingOpportunity,
      priority: potentialSaving > 100 ? InsightPriority.high : InsightPriority.medium,
      title: 'Oportunidade de Economia',
      description: 'Você pode economizar até ${potentialSaving.toStringAsFixed(2)} em $category. $suggestion',
      relatedAmount: potentialSaving,
      relatedCategory: category,
      relatedDate: DateTime.now(),
      actionText: 'Ver Dicas',
      metadata: {
        'potentialSaving': potentialSaving,
        'suggestion': suggestion,
      },
    );
  }

  static FinancialInsight monthlyTrend({
    required double currentMonth,
    required double previousMonth,
    required String trend,
  }) {
    final difference = ((currentMonth - previousMonth) / previousMonth) * 100;
    
    return FinancialInsight(
      id: 'monthly_trend_${DateTime.now().millisecondsSinceEpoch}',
      type: InsightType.monthlyTrend,
      priority: difference.abs() > 50 ? InsightPriority.high :
                difference.abs() > 25 ? InsightPriority.medium : InsightPriority.low,
      title: 'Tendência Mensal',
      description: 'Seus gastos este mês (${currentMonth.toStringAsFixed(2)}) estão '
                  '${difference > 0 ? '${difference.toStringAsFixed(1)}% maiores' : '${difference.abs().toStringAsFixed(1)}% menores'} '
                  'que o mês passado (${previousMonth.toStringAsFixed(2)}).',
      relatedAmount: currentMonth,
      relatedDate: DateTime.now(),
      metadata: {
        'currentMonth': currentMonth,
        'previousMonth': previousMonth,
        'difference': difference,
      },
    );
  }
}