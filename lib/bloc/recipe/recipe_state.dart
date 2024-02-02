part of 'recipe_bloc.dart';

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
