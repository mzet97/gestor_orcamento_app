import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zeitune_gestor/isar/isar_models.dart';
import 'package:zeitune_gestor/models/budget.dart';
import 'package:zeitune_gestor/models/monthly_budget.dart';
import 'package:zeitune_gestor/models/bank_slip.dart';
import 'package:zeitune_gestor/models/category.dart' as app;

class IsarDatabase {
  static final IsarDatabase _instance = IsarDatabase._internal();
  factory IsarDatabase() => _instance;
  IsarDatabase._internal();

  Isar? _isar;

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    // No web, Isar não usa diretório; em mobile/desktop, usamos app docs dir
    String? dirPath;
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      dirPath = dir.path;
    }
    if (kIsWeb) {
      _isar = await Isar.open(
        [
          BudgetIsarSchema,
          MonthlyBudgetIsarSchema,
          BankSlipIsarSchema,
          CategoryIsarSchema,
          AppSettingIsarSchema,
        ],
        directory: dirPath ?? "",
      );
    } else {
      _isar = await Isar.open(
        [
          BudgetIsarSchema,
          MonthlyBudgetIsarSchema,
          BankSlipIsarSchema,
          CategoryIsarSchema,
          AppSettingIsarSchema,
        ],
        directory: dirPath!,
      );
    }
    return _isar!;
  }

  // -------- Budget --------
  Future<Budget> saveBudget(Budget budget) async {
    final isar = await this.isar;
    final entity = BudgetIsar()..salary = budget.salary ?? 0.0;
    await isar.writeTxn(() async {
      await isar.budgetIsars.put(entity);
    });
    budget.id = entity.id;
    return budget;
  }

  Future<Budget> getBudget() async {
    final isar = await this.isar;
    final found = await isar.budgetIsars.where().findFirst();
    if (found == null) return Budget.empty();
    final budget = Budget(salary: found.salary, id: found.id);
    final monthly = await found.monthlyBudgets.filter().findAll();
    budget.monthlyBudget = await Future.wait(monthly.map((m) async {
      final slips = await m.bankSlips.filter().findAll();
      return MonthlyBudget(
        month: m.month,
        year: m.year,
        id: m.id,
        bankSilps: slips.map((s) => BankSlip(
          id: s.id,
          name: s.name,
          date: s.date,
          value: s.value,
          categoryId: s.categoryId ?? 0,
          description: s.description ?? '',
          tags: s.tags ?? '',
          isPaid: s.isPaid,
        )).toList(),
      );
    }));
    return budget;
  }

  Future<Budget> updateBudget(Budget budget) async {
    final isar = await this.isar;
    final entity = await isar.budgetIsars.get(budget.id ?? 0);
    if (entity == null) return budget;
    entity.salary = budget.salary ?? entity.salary;
    await isar.writeTxn(() async {
      await isar.budgetIsars.put(entity);
    });
    return budget;
  }

  // -------- MonthlyBudget --------
  Future<MonthlyBudget?> saveMonthlyBudget(MonthlyBudget monthlyBudget) async {
    final isar = await this.isar;
    final entity = MonthlyBudgetIsar()
      ..month = monthlyBudget.month ?? ''
      ..year = monthlyBudget.year ?? '';
    var budget = await isar.budgetIsars.where().findFirst();
    await isar.writeTxn(() async {
      // Se não existir Budget, cria um automaticamente
      if (budget == null) {
        final newBudget = BudgetIsar()..salary = 0.0;
        await isar.budgetIsars.put(newBudget);
        budget = newBudget;
      }
      await isar.monthlyBudgetIsars.put(entity);
      entity.budget.value = budget;
      await entity.budget.save();
      budget!.monthlyBudgets.add(entity);
      await budget!.monthlyBudgets.save();
    });
    monthlyBudget.id = entity.id;
    return monthlyBudget;
  }

  Future<MonthlyBudget> getByIdMonthlyBudget(int id) async {
    final isar = await this.isar;
    final m = await isar.monthlyBudgetIsars.get(id);
    if (m == null) return MonthlyBudget.empty();
    final slips = await m.bankSlips.filter().findAll();
    return MonthlyBudget(
      id: m.id,
      month: m.month,
      year: m.year,
      bankSilps: slips.map((s) => BankSlip(
        id: s.id,
        name: s.name,
        date: s.date,
        value: s.value,
        categoryId: s.categoryId ?? 0,
        description: s.description ?? '',
        tags: s.tags ?? '',
        isPaid: s.isPaid,
      )).toList(),
    );
  }

  Future<MonthlyBudget> getByMonthAndYearMonthlyBudget(String month, String year) async {
    final isar = await this.isar;
    final m = await isar.monthlyBudgetIsars.filter().monthEqualTo(month).and().yearEqualTo(year).findFirst();
    if (m == null) return MonthlyBudget.empty();
    final slips = await m.bankSlips.filter().findAll();
    return MonthlyBudget(
      id: m.id,
      month: m.month,
      year: m.year,
      bankSilps: slips.map((s) => BankSlip(
        id: s.id,
        name: s.name,
        date: s.date,
        value: s.value,
        categoryId: s.categoryId ?? 0,
        description: s.description ?? '',
        tags: s.tags ?? '',
        isPaid: s.isPaid,
      )).toList(),
    );
  }

  Future<List<MonthlyBudget>> getAllMonthlyBudget() async {
    final isar = await this.isar;
    final list = await isar.monthlyBudgetIsars.where().findAll();
    return Future.wait(list.map((m) async {
      final slips = await m.bankSlips.filter().findAll();
      return MonthlyBudget(
        id: m.id,
        month: m.month,
        year: m.year,
        bankSilps: slips.map((s) => BankSlip(
          id: s.id,
          name: s.name,
          date: s.date,
          value: s.value,
          categoryId: s.categoryId ?? 0,
          description: s.description ?? '',
          tags: s.tags ?? '',
          isPaid: s.isPaid,
        )).toList(),
      );
    }));
  }

  Future<List<MonthlyBudget>> getAllByBudgetMonthlyBudget(int id) async {
    // Isar: recuperar todos os monthly budgets do primeiro budget
    final isar = await this.isar;
    final budget = await isar.budgetIsars.where().findFirst();
    if (budget == null) return [];
    final list = await budget.monthlyBudgets.filter().findAll();
    return Future.wait(list.map((m) async {
      final slips = await m.bankSlips.filter().findAll();
      return MonthlyBudget(
        id: m.id,
        month: m.month,
        year: m.year,
        bankSilps: slips.map((s) => BankSlip(
          id: s.id,
          name: s.name,
          date: s.date,
          value: s.value,
          categoryId: s.categoryId ?? 0,
          description: s.description ?? '',
          tags: s.tags ?? '',
          isPaid: s.isPaid,
        )).toList(),
      );
    }));
  }

  Future<bool> canInsertMonthlyBudget(MonthlyBudget monthlyBudget) async {
    final isar = await this.isar;
    final m = await isar.monthlyBudgetIsars.filter()
      .monthEqualTo(monthlyBudget.month ?? '')
      .and()
      .yearEqualTo(monthlyBudget.year ?? '')
      .findFirst();
    return m == null;
  }

  Future<MonthlyBudget> updateMonthlyBudget(MonthlyBudget monthlyBudget) async {
    final isar = await this.isar;
    final m = await isar.monthlyBudgetIsars.get(monthlyBudget.id ?? 0);
    if (m == null) return monthlyBudget;
    m.month = monthlyBudget.month ?? m.month;
    m.year = monthlyBudget.year ?? m.year;
    await isar.writeTxn(() async {
      await isar.monthlyBudgetIsars.put(m);
    });
    return monthlyBudget;
  }

  Future<void> deleteMonthlyBudget(MonthlyBudget monthlyBudget) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.monthlyBudgetIsars.delete(monthlyBudget.id ?? 0);
    });
  }

  // -------- BankSlip --------
  Future<BankSlip?> saveBankSlip(BankSlip bankSlip, int idMonthlyBudget) async {
    final isar = await this.isar;
    final m = await isar.monthlyBudgetIsars.get(idMonthlyBudget);
    if (m == null) return null;
    final s = BankSlipIsar()
      ..name = bankSlip.name ?? ''
      ..date = bankSlip.date ?? ''
      ..value = bankSlip.value ?? 0.0
      ..categoryId = bankSlip.categoryId
      ..description = bankSlip.description
      ..tags = bankSlip.tags
      ..isPaid = bankSlip.isPaid ?? false;
    await isar.writeTxn(() async {
      await isar.bankSlipIsars.put(s);
      s.monthlyBudget.value = m;
      await s.monthlyBudget.save();
      m.bankSlips.add(s);
      await m.bankSlips.save();
    });
    bankSlip.id = s.id;
    return bankSlip;
  }

  Future<BankSlip> getByIdBankSlip(int id) async {
    final isar = await this.isar;
    final s = await isar.bankSlipIsars.get(id);
    if (s == null) return BankSlip.empty();
    return BankSlip(
      id: s.id,
      name: s.name,
      date: s.date,
      value: s.value,
      categoryId: s.categoryId ?? 0,
      description: s.description ?? '',
      tags: s.tags ?? '',
      isPaid: s.isPaid,
    );
  }

  Future<List<BankSlip>> getAllBankSlip() async {
    final isar = await this.isar;
    final list = await isar.bankSlipIsars.where().findAll();
    return list.map((s) => BankSlip(
      id: s.id,
      name: s.name,
      date: s.date,
      value: s.value,
      categoryId: s.categoryId ?? 0,
      description: s.description ?? '',
      tags: s.tags ?? '',
      isPaid: s.isPaid,
    )).toList();
  }

  Future<List<BankSlip>> getAllByMonthlyBudgetBankSlip(int idMonthlyBudget) async {
    final isar = await this.isar;
    final m = await isar.monthlyBudgetIsars.get(idMonthlyBudget);
    if (m == null) return [];
    final list = await m.bankSlips.filter().findAll();
    return list.map((s) => BankSlip(
      id: s.id,
      name: s.name,
      date: s.date,
      value: s.value,
      categoryId: s.categoryId ?? 0,
      description: s.description ?? '',
      tags: s.tags ?? '',
      isPaid: s.isPaid,
    )).toList();
  }

  Future<BankSlip?> updateBankSlipt(BankSlip bankSlip, int idMonthlyBudget) async {
    final isar = await this.isar;
    final s = await isar.bankSlipIsars.get(bankSlip.id ?? 0);
    if (s == null) return null;

    // Atualiza campos básicos
    s.name = bankSlip.name ?? s.name;
    s.date = bankSlip.date ?? s.date;
    s.value = bankSlip.value ?? s.value;
    s.categoryId = bankSlip.categoryId ?? s.categoryId;
    s.description = bankSlip.description ?? s.description;
    s.tags = bankSlip.tags ?? s.tags;
    s.isPaid = bankSlip.isPaid ?? s.isPaid;

    // Captura vínculo antigo antes de atualizar
    final oldMonthly = await s.monthlyBudget.value;

    // Novo orçamento mensal
    final m = await isar.monthlyBudgetIsars.get(idMonthlyBudget);
    if (m == null) return null;

    await isar.writeTxn(() async {
      // Persistir alterações do slip
      await isar.bankSlipIsars.put(s);

      // Se mudou de orçamento, remover do antigo
      if (oldMonthly != null && oldMonthly.id != m.id) {
        oldMonthly.bankSlips.remove(s);
        await oldMonthly.bankSlips.save();
      }

      // Atualizar link para novo orçamento
      s.monthlyBudget.value = m;
      await s.monthlyBudget.save();

      // Garantir que o novo orçamento tenha o slip
      m.bankSlips.add(s);
      await m.bankSlips.save();
    });

    return bankSlip;
  }

  Future<void> deleteBankSlipt(BankSlip bankSlip) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.bankSlipIsars.delete(bankSlip.id ?? 0);
    });
  }

  // -------- Category --------
  Future<List<app.Category>> getCategories() async {
    final isar = await this.isar;
    final list = await isar.categoryIsars.where().findAll();
    // Evita instanciar IconData dinamicamente (quebra tree-shake de ícones).
    // Usa o resolvedor do modelo para mapear codePoint -> ícone constante de Icons.
    return list.map((c) => app.Category.fromMap({
      'id': c.id,
      'name': c.name,
      'description': c.description,
      'color': c.colorValue,
      'icon': c.iconCodePoint,
      'budgetLimit': c.budgetLimit,
      'createdAt': c.createdAt.toIso8601String(),
    })).toList();
  }

  Future<app.Category?> saveCategory(app.Category category) async {
    final isar = await this.isar;
    final c = CategoryIsar()
      ..name = category.name
      ..description = category.description
      ..colorValue = category.color.value
      ..iconCodePoint = category.icon.codePoint
      ..budgetLimit = category.budgetLimit
      ..createdAt = category.createdAt;
    await isar.writeTxn(() async {
      await isar.categoryIsars.put(c);
    });
    return category.copyWith(id: c.id);
  }

  Future<app.Category?> updateCategory(app.Category category) async {
    final isar = await this.isar;
    final c = await isar.categoryIsars.get(category.id ?? 0);
    if (c == null) return null;
    c
      ..name = category.name
      ..description = category.description
      ..colorValue = category.color.value
      ..iconCodePoint = category.icon.codePoint
      ..budgetLimit = category.budgetLimit
      ..createdAt = category.createdAt;
    await isar.writeTxn(() async {
      await isar.categoryIsars.put(c);
    });
    return category;
  }

  Future<void> deleteCategory(int id) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.categoryIsars.delete(id);
    });
  }

  // -------- Settings (AppSetting) --------
  Future<String?> getSetting(String key) async {
    final isar = await this.isar;
    final s = await isar.appSettingIsars.filter().keyEqualTo(key).findFirst();
    return s?.value;
  }

  Future<void> setSetting(String key, String value) async {
    final isar = await this.isar;
    final s = await isar.appSettingIsars.filter().keyEqualTo(key).findFirst();
    await isar.writeTxn(() async {
      if (s == null) {
        final n = AppSettingIsar()
          ..key = key
          ..value = value;
        await isar.appSettingIsars.put(n);
      } else {
        s.value = value;
        await isar.appSettingIsars.put(s);
      }
    });
  }
}