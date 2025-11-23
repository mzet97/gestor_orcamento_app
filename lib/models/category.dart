import 'package:flutter/material.dart';

class Category {
  final int? id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final double budgetLimit;
  final DateTime createdAt;

  Category({
    this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    this.budgetLimit = 0.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color.value,
      'icon': icon.codePoint,
      'budgetLimit': budgetLimit,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    final dynamic rawColor = map['color'];
    final int colorValue = rawColor is int
        ? rawColor
        : int.tryParse(rawColor?.toString() ?? '') ?? Colors.grey.value;

    final dynamic budgetRaw = map.containsKey('budgetLimit')
        ? map['budgetLimit']
        : map['budget_limit'];
    final double budgetLimit = budgetRaw is num
        ? budgetRaw.toDouble()
        : double.tryParse(budgetRaw?.toString() ?? '') ?? 0.0;

    final String createdStr = (map['createdAt'] ?? map['created_at'] ?? DateTime.now().toIso8601String()).toString();

    return Category(
      id: map['id'],
      name: map['name'],
      description: (map['description'] ?? '').toString(),
      color: Color(colorValue),
      icon: _resolveIcon(map),
      budgetLimit: budgetLimit,
      createdAt: DateTime.tryParse(createdStr) ?? DateTime.now(),
    );
  }

  static IconData _resolveIcon(Map<String, dynamic> map) {
    final String? name = map['iconName'] as String?;
    if (name != null) {
      switch (name) {
        case 'restaurant':
          return Icons.restaurant;
        case 'directions_car':
          return Icons.directions_car;
        case 'home':
          return Icons.home;
        case 'movie':
          return Icons.movie;
        case 'medical_services':
          return Icons.medical_services;
        case 'school':
          return Icons.school;
        case 'shopping_bag':
          return Icons.shopping_bag;
        case 'more_horiz':
          return Icons.more_horiz;
        default:
          return Icons.more_horiz;
      }
    }

    final dynamic raw = map['icon'];
    final int? codePoint = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
    switch (codePoint) {
      case 0xe56c:
        return Icons.restaurant;
      case 0xe531:
        return Icons.directions_car;
      case 0xe88a:
        return Icons.home;
      case 0xe02c:
        return Icons.movie;
      case 0xe7f0:
        return Icons.medical_services;
      case 0xe80c:
        return Icons.school;
      case 0xe8cb:
        return Icons.shopping_bag;
      case 0xe5d3:
        return Icons.more_horiz;
      default:
        return Icons.more_horiz;
    }
  }

  Category copyWith({
    int? id,
    String? name,
    String? description,
    Color? color,
    IconData? icon,
    double? budgetLimit,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Categorias pré-definidas
class DefaultCategories {
  static final List<Category> categories = [
    Category(
      name: 'Alimentação',
      description: 'Restaurantes, mercados, delivery',
      color: Colors.green,
      icon: Icons.restaurant,
      budgetLimit: 500.0,
    ),
    Category(
      name: 'Transporte',
      description: 'Gasolina, ônibus, Uber',
      color: Colors.blue,
      icon: Icons.directions_car,
      budgetLimit: 300.0,
    ),
    Category(
      name: 'Moradia',
      description: 'Aluguel, condomínio, contas',
      color: Colors.purple,
      icon: Icons.home,
      budgetLimit: 1500.0,
    ),
    Category(
      name: 'Entretenimento',
      description: 'Cinema, jogos, assinaturas',
      color: Colors.orange,
      icon: Icons.movie,
      budgetLimit: 200.0,
    ),
    Category(
      name: 'Saúde',
      description: 'Medicamentos, consultas',
      color: Colors.red,
      icon: Icons.medical_services,
      budgetLimit: 400.0,
    ),
    Category(
      name: 'Educação',
      description: 'Cursos, livros, material',
      color: Colors.indigo,
      icon: Icons.school,
      budgetLimit: 300.0,
    ),
    Category(
      name: 'Compras',
      description: 'Roupas, eletrônicos, presentes',
      color: Colors.pink,
      icon: Icons.shopping_bag,
      budgetLimit: 400.0,
    ),
    Category(
      name: 'Outros',
      description: 'Despesas diversas',
      color: Colors.grey,
      icon: Icons.more_horiz,
      budgetLimit: 200.0,
    ),
  ];
}