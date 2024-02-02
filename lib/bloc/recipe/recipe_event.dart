part of 'recipe_bloc.dart';

class RecipeEvent {}

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
