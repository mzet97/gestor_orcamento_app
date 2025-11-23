import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';
import 'package:zet_gestor_orcamento/models/category.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'task.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(
        'CREATE TABLE IF NOT EXISTS budget (id INTEGER PRIMARY KEY AUTOINCREMENT, salary REAL NOT NULL);');
    db.execute(
        'CREATE TABLE IF NOT EXISTS monthly_budget (id INTEGER PRIMARY KEY AUTOINCREMENT, month TEXT NOT NULL, year TEXT NOT NULL, id_budget INT NOT NULL, FOREIGN KEY(id_budget) REFERENCES budget(id));');
    db.execute(
        'CREATE TABLE IF NOT EXISTS bank_slip (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, date TEXT NOT NULL, value REAL NOT NULL, id_monthly_budget INT NOT NULL, FOREIGN KEY(id_monthly_budget) REFERENCES monthly_budget(id));');
  }, version: 1);
}

class MyDatabase {
  static final MyDatabase _instance = MyDatabase.internal();

  factory MyDatabase() => _instance;

  MyDatabase.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "zet_gestor_o.db");

    return await openDatabase(path, version: 7,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS budget (id INTEGER PRIMARY KEY AUTOINCREMENT, salary REAL NOT NULL);');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS monthly_budget (id INTEGER PRIMARY KEY AUTOINCREMENT, month TEXT NOT NULL, year TEXT NOT NULL, id_budget INT NOT NULL, FOREIGN KEY(id_budget) REFERENCES budget(id));');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS bank_slip (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, date TEXT NOT NULL, value REAL NOT NULL, id_monthly_budget INT NOT NULL, category_id INTEGER, description TEXT, tags TEXT, FOREIGN KEY(id_monthly_budget) REFERENCES monthly_budget(id));');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS category (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT, color TEXT, icon TEXT, budget_limit REAL, created_at TEXT);');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS app_settings (key TEXT PRIMARY KEY, value TEXT);');
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 6) {
        await db.execute(
            'ALTER TABLE bank_slip ADD COLUMN category_id INTEGER;');
        await db.execute(
            'ALTER TABLE bank_slip ADD COLUMN description TEXT;');
        await db.execute(
            'ALTER TABLE bank_slip ADD COLUMN tags TEXT;');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS category (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT, color TEXT, icon TEXT, budget_limit REAL, created_at TEXT);');
        
        // Criar categorias padrão
        await _insertDefaultCategories(db);
      }
      if (oldVersion < 7) {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS app_settings (key TEXT PRIMARY KEY, value TEXT);');
      }
    });
  }

  Future<Budget> saveBudget(Budget budget) async {
    Database dbBudget = await db;
    int id = await dbBudget
        .rawInsert('INSERT INTO budget(salary) VALUES(?);', [budget.salary]);
    print('idBudget: $id');
    budget.id = id;

    return budget;
  }

  Future<Budget> getBudget() async {
    var budget = Budget.empty();

    Database dbBudget = await db;
    var listBudget = await dbBudget.rawQuery('SELECT * FROM budget;');

    if (listBudget != null && listBudget.isNotEmpty) {
      var map = listBudget.first;
      if (map != null && map.isNotEmpty) {
        budget = Budget.formMap(map);

        try {
          var monthlyBudges = await getAllByBudgetMonthlyBudget(budget.id!);
          budget.monthlyBudget = monthlyBudges;
        } catch (e) {
          print("faied to save to commit BRECASE ==> ${e.toString()}");
        }

        print('budget: $budget');
      }
    }

    return budget;
  }

  Future<Budget> updateBudget(Budget budget) async {
    Database dbBudget = await db;
    int count = await dbBudget.rawUpdate(
        'UPDATE budget SET salary = ? WHERE id = ?',
        [budget.salary, budget.id]);
    print('update:$count');
    return budget;
  }

  Future<MonthlyBudget?> saveMonthlyBudget(MonthlyBudget monthlyBudget) async {
    var budget = await getBudget();
    var canInsert = await canInsertMonthlyBudget(monthlyBudget);
    if (!canInsert) return null;
    Database dbBudget = await db;
    int id = await dbBudget.rawInsert(
        'INSERT INTO monthly_budget(month, year, id_budget) VALUES(?,?,?);',
        [monthlyBudget.month, monthlyBudget.year, budget.id]);
    print('idBudget: $id');
    monthlyBudget.id = id;

    return monthlyBudget;
  }

  Future<MonthlyBudget> getByIdMonthlyBudget(int id) async {
    var monthlyBudget = MonthlyBudget.empty();

    Database dbBudget = await db;

    var listBudget =
        await dbBudget.rawQuery('SELECT * FROM monthly_budget WHERE id = $id;');

    if (listBudget != null && listBudget.isNotEmpty) {
      var map = listBudget.first;
      if (map != null && map.isNotEmpty) {
        monthlyBudget = MonthlyBudget.formMap(map);

        try {
          var bankSlip = await getAllByMonthlyBudgetBankSlip(monthlyBudget.id!);
          monthlyBudget.bankSilps = bankSlip;
        } catch (e) {
          print("faied to save to commit BRECASE ==> ${e.toString()}");
        }

        print('$monthlyBudget');
      }
    }

    return monthlyBudget;
  }

  Future<MonthlyBudget> getByMonthAndYearMonthlyBudget(
      String month, String year) async {
    var monthlyBudget = MonthlyBudget.empty();
    Database dbBudget = await db;

    var listBudget = await dbBudget.rawQuery(
        "SELECT * FROM monthly_budget WHERE month like '$month' and year like '$year';");

    if (listBudget != null && listBudget.isNotEmpty) {
      var map = listBudget.first;
      if (map != null && map.isNotEmpty) {
        monthlyBudget = MonthlyBudget.formMap(map);

        try {
          var bankSlip = await getAllByMonthlyBudgetBankSlip(monthlyBudget.id!);
          monthlyBudget.bankSilps = bankSlip;
        } catch (e) {
          print("faied to save to commit BRECASE ==> ${e.toString()}");
        }
        print('$monthlyBudget');
      }
    }

    return monthlyBudget;
  }

  Future<List<MonthlyBudget>> getAllMonthlyBudget() async {
    List<MonthlyBudget> listMonthlyBudget = <MonthlyBudget>[];

    Database dbBudget = await db;
    var listBudget = await dbBudget.rawQuery('SELECT * FROM monthly_budget;');

    if (listBudget != null && listBudget.isNotEmpty) {
      for (var map in listBudget) {
        var monthlyBudget = MonthlyBudget.formMap(map);

        try {
          var bankSlip = await getAllByMonthlyBudgetBankSlip(monthlyBudget.id!);
          monthlyBudget.bankSilps = bankSlip;
        } catch (e) {
          print("faied to save to commit BRECASE ==> ${e.toString()}");
        }

        listMonthlyBudget.add(monthlyBudget);

        print('$monthlyBudget');
      }
    }

    return listMonthlyBudget;
  }

  Future<List<MonthlyBudget>> getAllByBudgetMonthlyBudget(int id) async {
    List<MonthlyBudget> listMonthlyBudget = <MonthlyBudget>[];

    Database dbBudget = await db;
    var listBudget =
        await dbBudget.rawQuery('SELECT * FROM monthly_budget WHERE id = $id;');

    if (listBudget != null && listBudget.isNotEmpty) {
      for (var map in listBudget) {
        var monthlyBudget = MonthlyBudget.formMap(map);

        try {
          var bankSlip = await getAllByMonthlyBudgetBankSlip(monthlyBudget.id!);
          monthlyBudget.bankSilps = bankSlip;
        } catch (e) {
          print("faied to save to commit BRECASE ==> ${e.toString()}");
        }

        listMonthlyBudget.add(monthlyBudget);

        print('$monthlyBudget');
      }
    }

    return listMonthlyBudget;
  }

  Future<bool> canInsertMonthlyBudget(MonthlyBudget monthlyBudget) async {
    if (monthlyBudget == null) return false;

    try {
      var monthlyBudgetDB = await getByMonthAndYearMonthlyBudget(
          monthlyBudget.month!, monthlyBudget.year!);
      if (monthlyBudgetDB == null) return false;
    } catch (e) {
      print("faied to save to commit BRECASE ==> ${e.toString()}");
    }

    return true;
  }

  Future<MonthlyBudget> updateMonthlyBudget(MonthlyBudget monthlyBudget) async {
    Database dbBudget = await db;
    int count = await dbBudget.rawUpdate(
        'UPDATE monthly_budget SET month = ?, year = ? WHERE id = ?',
        [monthlyBudget.month, monthlyBudget.year, monthlyBudget.id]);
    print('update:$count');

    return monthlyBudget;
  }

  Future<void> deleteMonthlyBudget(MonthlyBudget monthlyBudget) async {
    Database dbBudget = await db;

    var bankSlips = await getAllByMonthlyBudgetBankSlip(monthlyBudget.id!);

    for (var bankSlip in bankSlips) {
      await deleteBankSlipt(bankSlip);
    }

    int count = await dbBudget.rawDelete(
        'DELETE FROM monthly_budget WHERE id = ?', [monthlyBudget.id]);
    print('update:$count');
  }

  Future<BankSlip?> saveBankSlip(BankSlip bankSlip, int idMonthlyBudget) async {
    var monthlyBudget = await getByIdMonthlyBudget(idMonthlyBudget);
    if (monthlyBudget == null) return null;

    Database dbBudget = await db;
    dbBudget.rawInsert(
        'INSERT INTO bank_slip(name, date, value, id_monthly_budget) VALUES(?,?,?,?);',
        [bankSlip.name, bankSlip.date, bankSlip.value, idMonthlyBudget]);

    return bankSlip;
  }

  Future<BankSlip> getByIdBankSlip(int id) async {
    var bankSlip = BankSlip.empty();

    Database dbBudget = await db;
    var listBudget =
        await dbBudget.rawQuery('SELECT * FROM bank_slip WHERE id = $id;');

    if (listBudget != null && listBudget.isNotEmpty) {
      var map = listBudget.first;
      if (map != null && map.isNotEmpty) {
        bankSlip = BankSlip.formMap(map);

        print('$bankSlip');
      }
    }

    return bankSlip;
  }

  Future<List<BankSlip>> getAllBankSlip() async {
    List<BankSlip> listBankSlip = <BankSlip>[];

    Database dbBudget = await db;
    var listBudget = await dbBudget.rawQuery('SELECT * FROM bank_slip;');

    if (listBudget != null && listBudget.isNotEmpty) {
      for (var map in listBudget) {
        var bankSlip = BankSlip.formMap(map);

        listBankSlip.add(bankSlip);

        print('$bankSlip');
      }
    }

    return listBankSlip;
  }

  Future<List<BankSlip>> getAllByMonthlyBudgetBankSlip(
      int idMonthlyBudget) async {
    List<BankSlip> listBankSlip = <BankSlip>[];

    Database dbBudget = await db;
    var listBudget = await dbBudget.rawQuery(
        'SELECT * FROM bank_slip WHERE id_monthly_budget = $idMonthlyBudget;');
    if (listBudget != null && listBudget.isNotEmpty) {
      for (var map in listBudget) {
        var bankSlip = BankSlip.formMap(map);
        listBankSlip.add(bankSlip);

        print('_db:$bankSlip');
      }
    }

    return listBankSlip;
  }

  Future<BankSlip?> updateBankSlipt(
      BankSlip bankSlip, int idMonthlyBudget) async {
    var monthlyBudget = await getByIdMonthlyBudget(idMonthlyBudget);
    if (monthlyBudget == null) return null;

    Database dbBudget = await db;
    dbBudget.rawUpdate(
        'UPDATE bank_slip SET name = ?, date = ?, value = ?,  id_monthly_budget = ? WHERE id = ?',
        [
          bankSlip.name,
          bankSlip.date,
          bankSlip.value,
          idMonthlyBudget,
          bankSlip.id
        ]);

    return bankSlip;
  }

  Future<void> deleteBankSlipt(BankSlip bankSlip) async {
    Database dbBudget = await db;
    dbBudget
        .rawDelete('DELETE FROM bank_slip WHERE id = ?', [bankSlip.id]);
  }

  // Funções de Categoria
  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      Category(name: 'Alimentação', description: 'Gastos com supermercado e restaurantes', color: const Color(0xFFFF6B6B), icon: Icons.restaurant, budgetLimit: 500),
      Category(name: 'Transporte', description: 'Combustível, transporte público, etc.', color: const Color(0xFF4ECDC4), icon: Icons.directions_car, budgetLimit: 300),
      Category(name: 'Moradia', description: 'Aluguel, condomínio, contas', color: const Color(0xFF45B7D1), icon: Icons.home, budgetLimit: 1200),
      Category(name: 'Lazer', description: 'Cinema, viagens, hobbies', color: const Color(0xFFF7DC6F), icon: Icons.movie, budgetLimit: 200),
      Category(name: 'Saúde', description: 'Consultas, medicamentos', color: const Color(0xFFBB8FCE), icon: Icons.medical_services, budgetLimit: 150),
      Category(name: 'Educação', description: 'Cursos, livros, material escolar', color: const Color(0xFF85C1E2), icon: Icons.school, budgetLimit: 100),
      Category(name: 'Outros', description: 'Gastos diversos', color: const Color(0xFFF8C471), icon: Icons.more_horiz, budgetLimit: 100),
    ];

    for (final category in defaultCategories) {
      await db.rawInsert(
        'INSERT INTO category(name, description, color, icon, budget_limit, created_at) VALUES(?,?,?,?,?,?);',
        [
          category.name,
          category.description,
          category.color,
          category.icon,
          category.budgetLimit,
          DateTime.now().toIso8601String(),
        ],
      );
    }
  }

  Future<List<Category>> getCategories() async {
    List<Category> categories = [];
    Database dbBudget = await db;
    
    var result = await dbBudget.rawQuery('SELECT * FROM category ORDER BY name;');
    
    if (result.isNotEmpty) {
      categories = result.map((map) => Category.fromMap(map)).toList();
    }
    
    return categories;
  }

  Future<Category?> saveCategory(Category category) async {
    Database dbBudget = await db;
    
    try {
      int id = await dbBudget.rawInsert(
        'INSERT INTO category(name, description, color, icon, budget_limit, created_at) VALUES(?,?,?,?,?,?);',
        [
          category.name,
          category.description,
          category.color,
          category.icon,
          category.budgetLimit,
          DateTime.now().toIso8601String(),
        ],
      );
      
      return category.copyWith(id: id);
    } catch (e) {
      print('Erro ao salvar categoria: $e');
      return null;
    }
  }

  Future<Category?> updateCategory(Category category) async {
    Database dbBudget = await db;
    
    try {
      await dbBudget.rawUpdate(
        'UPDATE category SET name = ?, description = ?, color = ?, icon = ?, budget_limit = ? WHERE id = ?',
        [
          category.name,
          category.description,
          category.color,
          category.icon,
          category.budgetLimit,
          category.id,
        ],
      );
      
      return category;
    } catch (e) {
      print('Erro ao atualizar categoria: $e');
      return null;
    }
  }

  Future<void> deleteCategory(int id) async {
    Database dbBudget = await db;
    await dbBudget.rawDelete('DELETE FROM category WHERE id = ?', [id]);
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}
