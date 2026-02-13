import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeitune_gestor/database/isar_database.dart';
import 'package:zeitune_gestor/models/monthly_budget.dart';

class MonthlyBudgetRepository {
  static const String _prefsKeyMonthlyBudgets = 'monthly_budgets';

  Future<List<MonthlyBudget>> getMonthlyBudgets() async {
    if (!kIsWeb) {
      return await IsarDatabase().getAllMonthlyBudget();
    }
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKeyMonthlyBudgets);
    if (jsonStr == null) return [];
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((e) => MonthlyBudget.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  Future<MonthlyBudget?> addMonthlyBudget(MonthlyBudget monthlyBudget) async {
    if (!kIsWeb) {
      return await IsarDatabase().saveMonthlyBudget(monthlyBudget);
    }
    final prefs = await SharedPreferences.getInstance();
    final current = await getMonthlyBudgets();
    
    // Verificar se já existe orçamento para o mesmo mês/ano
    final exists = current.any((mb) => 
      mb.month == monthlyBudget.month && mb.year == monthlyBudget.year);
    if (exists) return null;
    
    // Gerar ID incremental simples
    final nextId = (current.map((e) => e.id ?? 0).fold<int>(0, (max, id) => id > max ? id : max)) + 1;
    final newMonthlyBudget = monthlyBudget.copyWith(id: nextId);
    final updated = [...current, newMonthlyBudget];
    await prefs.setString(_prefsKeyMonthlyBudgets, jsonEncode(updated.map((e) => e.toMap()).toList()));
    return newMonthlyBudget;
  }

  Future<MonthlyBudget?> updateMonthlyBudget(MonthlyBudget monthlyBudget) async {
    if (!kIsWeb) {
      return await IsarDatabase().updateMonthlyBudget(monthlyBudget);
    }
    final prefs = await SharedPreferences.getInstance();
    final current = await getMonthlyBudgets();
    
    // Verificar se já existe outro orçamento para o mesmo mês/ano (excluindo o atual)
    final exists = current.any((mb) => 
      mb.id != monthlyBudget.id && 
      mb.month == monthlyBudget.month && 
      mb.year == monthlyBudget.year);
    if (exists) return null;
    
    final updated = current.map((mb) => mb.id == monthlyBudget.id ? monthlyBudget : mb).toList();
    await prefs.setString(_prefsKeyMonthlyBudgets, jsonEncode(updated.map((e) => e.toMap()).toList()));
    return monthlyBudget;
  }

  Future<void> deleteMonthlyBudget(int id) async {
    if (!kIsWeb) {
      final monthlyBudget = MonthlyBudget.withId(id: id);
      return await IsarDatabase().deleteMonthlyBudget(monthlyBudget);
    }
    final prefs = await SharedPreferences.getInstance();
    final current = await getMonthlyBudgets();
    final updated = current.where((mb) => mb.id != id).toList();
    await prefs.setString(_prefsKeyMonthlyBudgets, jsonEncode(updated.map((e) => e.toMap()).toList()));
  }

  Future<bool> canInsertMonthlyBudget(MonthlyBudget monthlyBudget) async {
    if (!kIsWeb) {
      return await IsarDatabase().canInsertMonthlyBudget(monthlyBudget);
    }
    final current = await getMonthlyBudgets();
    return !current.any((mb) => 
      mb.month == monthlyBudget.month && mb.year == monthlyBudget.year);
  }
}