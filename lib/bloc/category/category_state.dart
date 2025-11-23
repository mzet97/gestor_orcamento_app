import 'package:equatable/equatable.dart';
import 'package:zet_gestor_orcamento/models/category.dart';

class CategoryState extends Equatable {
  final List<Category> categories;
  final bool loading;
  final String? error;

  const CategoryState({
    required this.categories,
    this.loading = false,
    this.error,
  });

  factory CategoryState.initial() => const CategoryState(categories: [], loading: true);

  CategoryState copyWith({
    List<Category>? categories,
    bool? loading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [categories, loading, error];
}