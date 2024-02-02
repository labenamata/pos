import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/recipe_model.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';
part 'recipe_repo.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc(RecipeState initialState) : super(initialState) {
    on<GetRecipe>(_getRecipe);
    on<TambahRecipe>(_tambahRecipe);
    on<HapusRecipe>(_hapusRecipe);
  }
}
