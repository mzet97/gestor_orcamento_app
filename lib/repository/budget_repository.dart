import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:zet_gestor_orcamento/database/isar_database.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';
import 'package:zet_gestor_orcamento/repository/monthly_budget_repository.dart';
import 'package:zet_gestor_orcamento/repository/bank_slip_repository.dart';

class BudgetRepository {
  final IsarDatabase _database = IsarDatabase();
  final MonthlyBudgetRepository _monthlyRepo = MonthlyBudgetRepository();
  static const String _prefsKeySalary = 'salary';

  Future<Budget> getBudget() async {
    if (kIsWeb) {
      // No web, reconstruímos o orçamento anexando as despesas
      // ao respectivo mês/ano com base na data.
      final monthly = await _monthlyRepo.getMonthlyBudgets();
      final slips = await BankSlipRepository().getAll();

      const months = [
        'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
        'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
      ];

      // Agrupar despesas por chave "yyyy-Mês"
      final Map<String, List<BankSlip>> grouped = {};
      for (final s in slips) {
        try {
          final date = DateTime.tryParse(s.date ?? '');
          if (date == null) continue;
          final key = '${DateFormat('yyyy').format(date)}-${months[date.month - 1]}';
          grouped.putIfAbsent(key, () => []).add(s);
        } catch (_) {}
      }

      // Mapear orçamentos existentes por chave
      final Map<String, MonthlyBudget> byKey = {
        for (final mb in monthly)
          '${mb.year}-${mb.month}': MonthlyBudget(
            id: mb.id,
            month: mb.month,
            year: mb.year,
            bankSilps: [],
          )
      };

      // Anexar slips aos orçamentos e criar orçamentos efêmeros quando necessário
      final List<MonthlyBudget> result = [];
      grouped.forEach((key, list) {
        final parts = key.split('-');
        final year = parts.first;
        final month = parts.length > 1 ? parts[1] : '';
        final existing = byKey[key] ?? MonthlyBudget(month: month, year: year);
        existing.bankSilps = list;
        result.add(existing);
        // Marcar como processado
        byKey.remove(key);
      });

      // Incluir orçamentos sem despesas
      result.addAll(byKey.values);

      double savedSalary = 0.0;
      try {
        final prefs = await SharedPreferences.getInstance();
        savedSalary = prefs.getDouble(_prefsKeySalary) ?? 0.0;
      } catch (_) {}
      return Budget(salary: savedSalary, monthlyBudget: result);
    }
    return await _database.getBudget();
  }

  Future<Budget> addSalary(double salary) async {
    if (kIsWeb) {
      // Em web, persistimos o salário via SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(_prefsKeySalary, salary);
      } catch (_) {}
      final monthly = await _monthlyRepo.getMonthlyBudgets();
      return Budget(salary: salary, monthlyBudget: monthly);
    }
    Budget budget = await _database.getBudget();
    budget.salary = salary;
    
    if ((budget.id ?? 0) != 0) {
      budget = await _database.updateBudget(budget);
    } else {
      budget = await _database.saveBudget(budget);
    }
    
    return budget;
  }

  Future<double> getSalary() async {
    final budget = await getBudget();
    return budget.salary ?? 0.0;
  }

  Future<Budget> addMonthlyBudget(MonthlyBudget monthlyBudget) async {
    if (kIsWeb) {
      await _monthlyRepo.addMonthlyBudget(monthlyBudget);
      final monthly = await _monthlyRepo.getMonthlyBudgets();
      return Budget(salary: 0.0, monthlyBudget: monthly);
    }
    final canInsert = await _database.canInsertMonthlyBudget(monthlyBudget);
    if (!canInsert) {
      return await _database.getBudget();
    }
    
    await _database.saveMonthlyBudget(monthlyBudget);
    return await _database.getBudget();
  }

  Future<Budget> removeMonthlyBudget(MonthlyBudget monthlyBudget) async {
    if (kIsWeb) {
      await _monthlyRepo.deleteMonthlyBudget(monthlyBudget.id ?? 0);
      final monthly = await _monthlyRepo.getMonthlyBudgets();
      return Budget(salary: 0.0, monthlyBudget: monthly);
    }
    await _database.deleteMonthlyBudget(monthlyBudget);
    return await _database.getBudget();
  }

  Future<Budget> addBankSlip(BankSlip bankSlip, String monthYear) async {
    if (kIsWeb) {
      // No web, o fluxo de adicionar conta é feito diretamente pelo BankSlipRepository.
      // Mantemos o orçamento atual apenas para consistência de UI.
      final monthly = await _monthlyRepo.getMonthlyBudgets();
      return Budget(salary: 0.0, monthlyBudget: monthly);
    }
    // Derivar mês/ano diretamente da data da despesa e criar orçamento se necessário
    try {
      final date = DateTime.tryParse(bankSlip.date ?? '');
      if (date == null) {
        return await _database.getBudget();
      }
      const months = [
        'Janeiro','Fevereiro','Março','Abril','Maio','Junho',
        'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'
      ];
      final month = months[date.month - 1];
      final year = DateFormat('yyyy').format(date);

      var monthlyBudget = await _database.getByMonthAndYearMonthlyBudget(month, year);
      var id = monthlyBudget.id ?? 0;

      if (id == 0) {
        final created = await _database.saveMonthlyBudget(MonthlyBudget(month: month, year: year));
        id = created?.id ?? 0;
      }

      if (id != 0) {
        await _database.saveBankSlip(bankSlip, id);
      }
    } catch (_) {}
    return await _database.getBudget();
  }

  Future<Budget> removeBankSlip(BankSlip bankSlip) async {
    if (kIsWeb) {
      // Em web, persistimos a exclusão via repositório de BankSlip e refletimos orçamento
      try {
        // Uso pontual para evitar dependência fixa; mantém fluxo atual
        final repo = BankSlipRepository();
        await repo.delete(bankSlip.id ?? 0);
      } catch (_) {}
      final monthly = await _monthlyRepo.getMonthlyBudgets();
      return Budget(salary: 0.0, monthlyBudget: monthly);
    }
    await _database.deleteBankSlipt(bankSlip);
    return await _database.getBudget();
  }

  Future<List<MonthlyBudget>> getMonthlyBudgets() async {
    if (kIsWeb) {
      return await _monthlyRepo.getMonthlyBudgets();
    }
    final budget = await _database.getBudget();
    return budget.monthlyBudget ?? [];
  }
}