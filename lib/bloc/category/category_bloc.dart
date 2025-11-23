import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zet_gestor_orcamento/bloc/category/category_event.dart';
import 'package:zet_gestor_orcamento/bloc/category/category_state.dart';
import 'package:zet_gestor_orcamento/repository/bank_slip_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final BankSlipRepository repo;
  CategoryBloc({required this.repo}) : super(CategoryState.initial()) {
    on<LoadCategories>(_onLoad);
    on<AddCategory>(_onAdd);
    on<UpdateCategory>(_onUpdate);
    on<DeleteCategory>(_onDelete);
  }

  Future<void> _onLoad(LoadCategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(loading: true));
    final list = await repo.getCategories();
    emit(state.copyWith(categories: list, loading: false));
  }

  Future<void> _onAdd(AddCategory event, Emitter<CategoryState> emit) async {
    await repo.addCategory(event.category);
    add(const LoadCategories());
  }

  Future<void> _onUpdate(UpdateCategory event, Emitter<CategoryState> emit) async {
    await repo.updateCategory(event.category);
    add(const LoadCategories());
  }

  Future<void> _onDelete(DeleteCategory event, Emitter<CategoryState> emit) async {
    await repo.deleteCategory(event.id);
    add(const LoadCategories());
  }
}