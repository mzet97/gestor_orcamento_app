import 'package:equatable/equatable.dart';
import 'package:zeitune_gestor/models/category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

class AddCategory extends CategoryEvent {
  final Category category;
  const AddCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class UpdateCategory extends CategoryEvent {
  final Category category;
  const UpdateCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final int id;
  const DeleteCategory(this.id);
  @override
  List<Object?> get props => [id];
}