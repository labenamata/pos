import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/recipe_model.dart';

class RecipeEvent {}

abstract class RecipeState extends Equatable {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> data;
  RecipeLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class RecipeLoading extends RecipeState {
  final String message;
  RecipeLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetRecipe extends RecipeEvent {
  int id;
  GetRecipe({required this.id});
}

class HapusRecipe extends RecipeEvent {
  int id;
  int idProduk;
  HapusRecipe({
    required this.id,
    required this.idProduk,
  });
}

class TambahRecipe extends RecipeEvent {
  int idProduk;
  int idBahan;
  double usage;

  TambahRecipe({
    required this.idProduk,
    required this.idBahan,
    required this.usage,
  });
}

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc(RecipeState initialState) : super(initialState) {
    on<GetRecipe>(_getRecipe);
    on<TambahRecipe>(_tambahRecipe);
    on<HapusRecipe>(_hapusRecipe);
  }

  Future<void> _getRecipe(GetRecipe event, Emitter<RecipeState> emit) async {
    List<Recipe> recipe;
    emit(RecipeLoading(''));
    recipe = await Recipe.getData(event.id);
    emit(RecipeLoaded(recipe));
  }

  Future<FutureOr<void>> _tambahRecipe(
      TambahRecipe event, Emitter<RecipeState> emit) async {
    List<Recipe> recipe;
    emit(RecipeLoading(''));
    Map<String, dynamic> data = {
      'idProduk': event.idProduk,
      'idBahan': event.idBahan,
      'usage': event.usage
    };
    await Recipe.addRecipe(data);
    recipe = await Recipe.getData(event.idProduk);
    emit(RecipeLoaded(recipe));
  }

  Future<FutureOr<void>> _hapusRecipe(
      HapusRecipe event, Emitter<RecipeState> emit) async {
    List<Recipe> recipe;
    emit(RecipeLoading(''));
    await Recipe.deleteRecipe(event.id);
    recipe = await Recipe.getData(event.idProduk);
    emit(RecipeLoaded(recipe));
  }
}
