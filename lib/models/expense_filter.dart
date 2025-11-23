import 'package:flutter/material.dart';

enum FilterType {
  period,
  category,
  amountRange,
  tags,
  monthlyBudget,
}

enum PeriodType {
  today,
  thisWeek,
  thisMonth,
  lastMonth,
  thisYear,
  custom,
}

class ExpenseFilter {
  final String id;
  final String name;
  final Map<FilterType, dynamic> filters;
  final DateTime createdAt;
  bool isActive;

  ExpenseFilter({
    required this.id,
    required this.name,
    required this.filters,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  // Filtros ativos
  bool get hasPeriodFilter => filters.containsKey(FilterType.period);
  bool get hasCategoryFilter => filters.containsKey(FilterType.category);
  bool get hasAmountFilter => filters.containsKey(FilterType.amountRange);
  bool get hasTagsFilter => filters.containsKey(FilterType.tags);
  bool get hasMonthlyBudgetFilter => filters.containsKey(FilterType.monthlyBudget);

  // Obter valores dos filtros
  PeriodType? get periodType {
    if (!hasPeriodFilter) return null;
    final periodData = filters[FilterType.period] as Map<String, dynamic>;
    return periodData['type'] as PeriodType;
  }

  DateTimeRange? get customDateRange {
    if (!hasPeriodFilter) return null;
    final periodData = filters[FilterType.period] as Map<String, dynamic>;
    if (periodData['type'] != PeriodType.custom) return null;
    return DateTimeRange(
      start: periodData['startDate'],
      end: periodData['endDate'],
    );
  }

  List<int>? get categoryIds {
    if (!hasCategoryFilter) return null;
    return filters[FilterType.category] as List<int>;
  }

  RangeValues? get amountRange {
    if (!hasAmountFilter) return null;
    final rangeData = filters[FilterType.amountRange] as Map<String, dynamic>;
    return RangeValues(
      rangeData['min'].toDouble(),
      rangeData['max'].toDouble(),
    );
  }

  List<String>? get tags {
    if (!hasTagsFilter) return null;
    return filters[FilterType.tags] as List<String>;
  }

  int? get monthlyBudgetId {
    if (!hasMonthlyBudgetFilter) return null;
    return filters[FilterType.monthlyBudget] as int;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filters': _filtersToMap(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  Map<String, dynamic> _filtersToMap() {
    final mapFilters = <String, dynamic>{};
    
    filters.forEach((key, value) {
      switch (key) {
        case FilterType.period:
          final periodData = value as Map<String, dynamic>;
          mapFilters['period'] = {
            'type': periodData['type'].toString().split('.').last,
            if (periodData['type'] == PeriodType.custom) ...{
              'startDate': periodData['startDate'].toIso8601String(),
              'endDate': periodData['endDate'].toIso8601String(),
            },
          };
          break;
        case FilterType.category:
          mapFilters['category'] = value as List<int>;
          break;
        case FilterType.amountRange:
          final rangeData = value as Map<String, dynamic>;
          mapFilters['amountRange'] = {
            'min': rangeData['min'],
            'max': rangeData['max'],
          };
          break;
        case FilterType.tags:
          mapFilters['tags'] = value as List<String>;
          break;
        case FilterType.monthlyBudget:
          mapFilters['monthlyBudget'] = value as int;
          break;
      }
    });
    
    return mapFilters;
  }

  factory ExpenseFilter.fromMap(Map<String, dynamic> map) {
    final filters = <FilterType, dynamic>{};
    final mapFilters = map['filters'] as Map<String, dynamic>;
    
    mapFilters.forEach((key, value) {
      switch (key) {
        case 'period':
          final periodData = value as Map<String, dynamic>;
          final periodType = PeriodType.values.firstWhere(
            (e) => e.toString().split('.').last == periodData['type'],
          );
          filters[FilterType.period] = {
            'type': periodType,
            if (periodType == PeriodType.custom) ...{
              'startDate': DateTime.parse(periodData['startDate']),
              'endDate': DateTime.parse(periodData['endDate']),
            },
          };
          break;
        case 'category':
          filters[FilterType.category] = List<int>.from(value);
          break;
        case 'amountRange':
          final rangeData = value as Map<String, dynamic>;
          filters[FilterType.amountRange] = {
            'min': rangeData['min'].toDouble(),
            'max': rangeData['max'].toDouble(),
          };
          break;
        case 'tags':
          filters[FilterType.tags] = List<String>.from(value);
          break;
        case 'monthlyBudget':
          filters[FilterType.monthlyBudget] = value as int;
          break;
      }
    });
    
    return ExpenseFilter(
      id: map['id'],
      name: map['name'],
      filters: filters,
      createdAt: DateTime.parse(map['createdAt']),
      isActive: map['isActive'] == 1,
    );
  }

  // Filtros pré-definidos úteis
  static ExpenseFilter get thisMonth {
    return ExpenseFilter(
      id: 'this_month',
      name: 'Este Mês',
      filters: {
        FilterType.period: {
          'type': PeriodType.thisMonth,
        },
      },
    );
  }

  static ExpenseFilter get highExpenses {
    return ExpenseFilter(
      id: 'high_expenses',
      name: 'Altos Gastos',
      filters: {
        FilterType.amountRange: {
          'min': 100.0,
          'max': double.infinity,
        },
      },
    );
  }

  static ExpenseFilter get essentialCategories {
    return ExpenseFilter(
      id: 'essential_categories',
      name: 'Categorias Essenciais',
      filters: {
        FilterType.category: [1, 2, 3, 5], // Alimentação, Transporte, Moradia, Saúde
      },
    );
  }
}