part of 'recipe_bloc.dart';

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
