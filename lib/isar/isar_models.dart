import 'package:isar_community/isar.dart';
part 'isar_models.g.dart';

@collection
class BudgetIsar {
  Id id = Isar.autoIncrement;
  double salary = 0.0;
  final monthlyBudgets = IsarLinks<MonthlyBudgetIsar>();
}

@collection
class MonthlyBudgetIsar {
  Id id = Isar.autoIncrement;
  late String month;
  late String year;
  final bankSlips = IsarLinks<BankSlipIsar>();
  final budget = IsarLink<BudgetIsar>();
}

@collection
class BankSlipIsar {
  Id id = Isar.autoIncrement;
  late String name;
  late String date;
  double value = 0.0;
  int? categoryId;
  String? description;
  String? tags;
  bool isPaid = false;
  final monthlyBudget = IsarLink<MonthlyBudgetIsar>();
}

@collection
class CategoryIsar {
  Id id = Isar.autoIncrement;
  late String name;
  String description = '';
  // Armazenar valores primitivos compatíveis com Isar
  int colorValue = 0xFF9E9E9E; // cinza por padrão
  int iconCodePoint = 0xe5d3;  // Icons.more_horiz
  double budgetLimit = 0.0;
  DateTime createdAt = DateTime.now();
}

@collection
class AppSettingIsar {
  Id id = Isar.autoIncrement;
  late String key;
  String? value;
}