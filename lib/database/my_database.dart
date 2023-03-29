import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:zet_gestor_orcamento/models/budget.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';


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

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db
              .execute('CREATE TABLE IF NOT EXISTS budget (id INTEGER PRIMARY KEY AUTOINCREMENT, salary REAL NOT NULL);');
          await db
              .execute('CREATE TABLE IF NOT EXISTS monthly_budget (id INTEGER PRIMARY KEY AUTOINCREMENT, month TEXT NOT NULL, year TEXT NOT NULL, id_budget INT NOT NULL, FOREIGN KEY(id_budget) REFERENCES budget(id));');
          await db
              .execute('CREATE TABLE IF NOT EXISTS bank_slip (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, date TEXT NOT NULL, value REAL NOT NULL, id_monthly_budget INT NOT NULL, FOREIGN KEY(id_monthly_budget) REFERENCES monthly_budget(id));');
        });
  }

  Future<Budget> saveBudget(Budget budget) async {
    Database dbBudget = await db;
    await dbBudget.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO budget(salary) VALUES(?);',
      [budget.salary]);
      print('idBudget: $id');
      budget.id = id;
    });

    return budget;
  }

  Future<Budget> getBudget() async {
    var budget = Budget.empty();

    Database dbBudget = await db;
    await dbBudget.transaction((txn) async {
      var listBudget = await txn.rawQuery(
          'SELECT * FROM budget;');
      var budgetMap = listBudget.first;
      budget.id = int.parse(budgetMap['id'].toString());
      budget.salary =  double.parse(budgetMap['salary'].toString());
      print('${budget}');
    });

    return budget;
  }

  Future<Budget> updateBudget(Budget budget) async {
    Database dbBudget = await db;
    await dbBudget.transaction((txn) async {
      int count = await txn.rawUpdate(
          'UPDATE budget SET salary = ? WHERE id = ?',
        [budget.salary, budget.id]
      );
      print('update:$count');
    });

    return budget;
  }

  Future<MonthlyBudget?> saveMonthlyBudget(MonthlyBudget monthlyBudget) async {
    var budget = await getBudget();
    var canInsert = await canInsertMonthlyBudget(monthlyBudget);
    if(!canInsert) return null;
    Database dbBudget = await db;
    await dbBudget.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO monthly_budget(month, year, id_budget) VALUES(?,?,?);',
          [monthlyBudget.month, monthlyBudget.year, budget.id]);
      print('idBudget: $id');
      monthlyBudget.id = id;
    });

    return monthlyBudget;
  }

  Future<MonthlyBudget> getByIdMonthlyBudget(int id) async {
    var monthlyBudget = MonthlyBudget.empty();

    Database dbBudget = await db;
    await dbBudget.transaction((txn) async {
      var listBudget = await txn.rawQuery(
          'SELECT * FROM budget WHERE id = $id;');
      var budgetMap = listBudget.first;
      monthlyBudget.id = int.parse(budgetMap['id'].toString());
      monthlyBudget.month =  budgetMap['month'].toString();
      monthlyBudget.year =  budgetMap['year'].toString();

      // TODO monthlyBudget.bankSilps

      print('${monthlyBudget}');
    });

    return monthlyBudget;
  }

  Future<MonthlyBudget> getByMonthAndYearMonthlyBudget(String month, String year) async {
    var monthlyBudget = MonthlyBudget.empty();
    Database dbBudget = await db;

    await dbBudget.transaction((txn) async {
      var listBudget = await txn.rawQuery(
          "SELECT * FROM budget WHERE month like '$month' and year like '$year';");
      var budgetMap = listBudget.first;
      monthlyBudget.id = int.parse(budgetMap['id'].toString());
      monthlyBudget.month =  budgetMap['month'].toString();
      monthlyBudget.year =  budgetMap['year'].toString();

      // TODO monthlyBudget.bankSilps

      print('${monthlyBudget}');
    });

    return monthlyBudget;
  }

  Future<List<MonthlyBudget>> getAllMonthlyBudget() async {
    List<MonthlyBudget> listMonthlyBudget = <MonthlyBudget>[];

    Database dbBudget = await db;
    await dbBudget.transaction((txn) async {
      var listBudget = await txn.rawQuery(
          'SELECT * FROM budget;');

      for(var budgetMap in listBudget){
        var monthlyBudget = MonthlyBudget.empty();
        monthlyBudget.id = int.parse(budgetMap['id'].toString());
        monthlyBudget.month =  budgetMap['month'].toString();
        monthlyBudget.year =  budgetMap['year'].toString();
        listMonthlyBudget.add(monthlyBudget);

        print('${monthlyBudget}');
      }


      // TODO monthlyBudget.bankSilps

    });

    return listMonthlyBudget;
  }

  Future<bool> canInsertMonthlyBudget(MonthlyBudget monthlyBudget) async{
    if(monthlyBudget == null) return false;

    var monthlyBudgetDB = await getByMonthAndYearMonthlyBudget(monthlyBudget.month!, monthlyBudget.year!);
    if(monthlyBudgetDB == null) return false;

    return true;
  }

  Future close() async{
    Database dbContact = await db;
    dbContact.close();
  }
}