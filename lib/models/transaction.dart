import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/models/category.dart';

enum TransactionType { income, expense }

class Transaction {
  final int? id;
  final String description;
  final double amount;
  final TransactionType type;
  final Category category;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;

  Transaction({
    this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    DateTime? date,
    this.notes,
    DateTime? createdAt,
  })  : date = date ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type.name,
      'category': category.toMap(),
      'date': date.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      description: map['description'],
      amount: map['amount']?.toDouble() ?? 0.0,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      category: Category.fromMap(map['category']),
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Transaction copyWith({
    int? id,
    String? description,
    double? amount,
    TransactionType? type,
    Category? category,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Color get color => type == TransactionType.income ? Colors.green : Colors.red;
  IconData get icon => type == TransactionType.income ? Icons.add : Icons.remove;
  String get formattedAmount => type == TransactionType.income ? '+\$${amount.toStringAsFixed(2)}' : '-\$${amount.toStringAsFixed(2)}';
}

// Transações de exemplo
class MockTransactions {
  static final List<Transaction> transactions = [
    Transaction(
      description: 'Salário Mensal',
      amount: 3500.0,
      type: TransactionType.income,
      category: DefaultCategories.categories.firstWhere((c) => c.name == 'Outros'),
      date: DateTime.now().subtract(const Duration(days: 5)),
      notes: 'Salário do mês',
    ),
    Transaction(
      description: 'Supermercado',
      amount: 150.50,
      type: TransactionType.expense,
      category: DefaultCategories.categories.firstWhere((c) => c.name == 'Alimentação'),
      date: DateTime.now().subtract(const Duration(days: 3)),
      notes: 'Compras do mês',
    ),
    Transaction(
      description: 'Gasolina',
      amount: 80.0,
      type: TransactionType.expense,
      category: DefaultCategories.categories.firstWhere((c) => c.name == 'Transporte'),
      date: DateTime.now().subtract(const Duration(days: 2)),
      notes: 'Abastecimento',
    ),
    Transaction(
      description: 'Netflix',
      amount: 45.90,
      type: TransactionType.expense,
      category: DefaultCategories.categories.firstWhere((c) => c.name == 'Entretenimento'),
      date: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Assinatura mensal',
    ),
    Transaction(
      description: 'Freelance',
      amount: 500.0,
      type: TransactionType.income,
      category: DefaultCategories.categories.firstWhere((c) => c.name == 'Outros'),
      date: DateTime.now(),
      notes: 'Projeto extra',
    ),
  ];
}