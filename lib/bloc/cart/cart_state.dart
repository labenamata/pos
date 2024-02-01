part of 'cart_bloc.dart';

abstract class CartState extends Equatable {}

class CartLoaded extends CartState {
  final Cart data;
  CartLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CartLoading extends CartState {
  final String message;
  CartLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class CartError extends CartState {
  final String message;
  CartError({required this.message});

  @override
  List<Object?> get props => [message];
}
