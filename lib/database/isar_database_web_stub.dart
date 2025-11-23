// Web stub for IsarDatabase to satisfy conditional imports in web builds.
// On web, repositories use SharedPreferences, so these methods are rarely called.

import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/category.dart' as app;
import 'package:zet_gestor_orcamento/models/budget.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

class IsarDatabase {
  // -------- Budget --------
  Future<Budget> saveBudget(Budget budget) async => budget;
  Future<Budget> getBudget() async => Budget.empty();
  Future<Budget> updateBudget(Budget budget) async => budget;

  // -------- MonthlyBudget --------
  Future<MonthlyBudget?> saveMonthlyBudget(MonthlyBudget monthlyBudget) async => monthlyBudget;
  Future<MonthlyBudget> getByIdMonthlyBudget(int id) async => MonthlyBudget.empty();
  Future<MonthlyBudget> getByMonthAndYearMonthlyBudget(String month, String year) async => MonthlyBudget.empty();
  Future<List<MonthlyBudget>> getAllMonthlyBudget() async => [];
  Future<List<MonthlyBudget>> getAllByBudgetMonthlyBudget(int id) async => [];
  Future<bool> canInsertMonthlyBudget(MonthlyBudget monthlyBudget) async => true;
  Future<MonthlyBudget> updateMonthlyBudget(MonthlyBudget monthlyBudget) async => monthlyBudget;
  Future<void> deleteMonthlyBudget(MonthlyBudget monthlyBudget) async {}

  // -------- BankSlip --------
  Future<BankSlip?> saveBankSlip(BankSlip bankSlip, int idMonthlyBudget) async => bankSlip;
  Future<BankSlip> getByIdBankSlip(int id) async => BankSlip.empty();
  Future<List<BankSlip>> getAllBankSlip() async => [];
  Future<List<BankSlip>> getAllByMonthlyBudgetBankSlip(int idMonthlyBudget) async => [];
  Future<BankSlip?> updateBankSlipt(BankSlip bankSlip, int idMonthlyBudget) async => bankSlip;
  Future<void> deleteBankSlipt(BankSlip bankSlip) async {}

  // -------- Category --------
  Future<List<app.Category>> getCategories() async => [];
  Future<app.Category?> saveCategory(app.Category category) async => category.copyWith(id: category.id);
  Future<app.Category?> updateCategory(app.Category category) async => category;
  Future<void> deleteCategory(int id) async {}

  // -------- Settings --------
  Future<String?> getSetting(String key) async => null;
  Future<void> setSetting(String key, String value) async {}
}