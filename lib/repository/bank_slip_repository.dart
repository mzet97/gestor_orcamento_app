import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zet_gestor_orcamento/database/isar_database.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/category.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';
import 'package:zet_gestor_orcamento/repository/monthly_budget_repository.dart';

class BankSlipRepository {
  static const String _prefsKeySlips = 'bank_slips';
  static const String _prefsKeyCategories = 'categories';

  Future<List<BankSlip>> getAll() async {
    if (!kIsWeb) {
      return await IsarDatabase().getAllBankSlip();
    }
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKeySlips);
    if (jsonStr == null) return [];
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((e) => BankSlip.formMap(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> add(BankSlip slip) async {
    if (!kIsWeb) {
      // Sem monthlyBudgetId aqui; use telas existentes para adicionar
      // Este método é apenas para web fallback
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final current = await getAll();
    // Gerar ID incremental simples
    final nextId = (current.map((e) => e.id ?? 0).fold<int>(0, (max, id) => id > max ? id : max)) + 1;
    slip.id = nextId;
    final updated = [...current, slip];
    await prefs.setString(_prefsKeySlips, jsonEncode(updated.map((e) => e.toMap()).toList()));

    // Garantir orçamento mensal com base na data
    try {
      final date = DateTime.tryParse(slip.date ?? '');
      if (date != null) {
        const months = [
          'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
          'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
        ];
        final monthStr = months[date.month - 1];
        final yearStr = DateFormat('yyyy').format(date);
        final mRepo = MonthlyBudgetRepository();
        final list = await mRepo.getMonthlyBudgets();
        final exists = list.any((mb) => mb.month == monthStr && mb.year == yearStr);
        if (!exists) {
          await mRepo.addMonthlyBudget(MonthlyBudget(month: monthStr, year: yearStr));
        }
      }
    } catch (_) {}
  }

  Future<void> update(BankSlip slip) async {
    if (!kIsWeb) return; // atualizações via MyDatabase nas telas existentes
    final prefs = await SharedPreferences.getInstance();
    final current = await getAll();
    final updated = current.map((e) => e.id == slip.id ? slip : e).toList();
    await prefs.setString(_prefsKeySlips, jsonEncode(updated.map((e) => e.toMap()).toList()));

    // Se a data mudar para outro mês/ano, garantir criação do orçamento correspondente
    try {
      final date = DateTime.tryParse(slip.date ?? '');
      if (date != null) {
        const months = [
          'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
          'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
        ];
        final monthStr = months[date.month - 1];
        final yearStr = DateFormat('yyyy').format(date);
        final mRepo = MonthlyBudgetRepository();
        final list = await mRepo.getMonthlyBudgets();
        final exists = list.any((mb) => mb.month == monthStr && mb.year == yearStr);
        if (!exists) {
          await mRepo.addMonthlyBudget(MonthlyBudget(month: monthStr, year: yearStr));
        }
      }
    } catch (_) {}
  }

  Future<void> delete(int id) async {
    if (!kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    final current = await getAll();
    final updated = current.where((e) => e.id != id).toList();
    await prefs.setString(_prefsKeySlips, jsonEncode(updated.map((e) => e.toMap()).toList()));
  }

  Future<List<Category>> getCategories() async {
    if (!kIsWeb) {
      return await IsarDatabase().getCategories();
    }
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKeyCategories);
    if (jsonStr != null) {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => Category.fromMap(Map<String, dynamic>.from(e))).toList();
    }
    // Sem categorias salvas: inicializar com lista padrão mínima
    final defaults = [
      Category(id: 1, name: 'Alimentação', description: '', color: const Color(0xFFFF6B6B), icon: Icons.restaurant, budgetLimit: 500),
      Category(id: 2, name: 'Transporte', description: '', color: const Color(0xFF4ECDC4), icon: Icons.directions_car, budgetLimit: 300),
      Category(id: 3, name: 'Outros', description: '', color: const Color(0xFFF8C471), icon: Icons.more_horiz, budgetLimit: 100),
    ];
    await prefs.setString(_prefsKeyCategories, jsonEncode(defaults.map((e) => e.toMap()).toList()));
    return defaults;
  }

  Future<Category?> addCategory(Category category) async {
    if (!kIsWeb) {
      return await IsarDatabase().saveCategory(category);
    }
    final prefs = await SharedPreferences.getInstance();
    final current = await getCategories();
    final nextId = (current.map((e) => e.id ?? 0).fold<int>(0, (max, id) => id > max ? id : max)) + 1;
    final newCategory = category.copyWith(id: nextId);
    final updated = [...current, newCategory];
    await prefs.setString(_prefsKeyCategories, jsonEncode(updated.map((e) => e.toMap()).toList()));
    return newCategory;
  }

  Future<Category?> updateCategory(Category category) async {
    if (!kIsWeb) {
      return await IsarDatabase().updateCategory(category);
    }
    final prefs = await SharedPreferences.getInstance();
    final current = await getCategories();
    final updated = current.map((c) => c.id == category.id ? category : c).toList();
    await prefs.setString(_prefsKeyCategories, jsonEncode(updated.map((e) => e.toMap()).toList()));
    return category;
  }

  Future<void> deleteCategory(int id) async {
    if (!kIsWeb) {
      return await IsarDatabase().deleteCategory(id);
    }
    final prefs = await SharedPreferences.getInstance();
    final current = await getCategories();
    final updated = current.where((c) => c.id != id).toList();
    await prefs.setString(_prefsKeyCategories, jsonEncode(updated.map((e) => e.toMap()).toList()));
  }
}