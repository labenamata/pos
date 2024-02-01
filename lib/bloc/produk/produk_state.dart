part of 'produk_bloc.dart';

abstract class ProdukState extends Equatable {}

class ProdukLoaded extends ProdukState {
  final List<Produk> data;
  ProdukLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ProdukLoading extends ProdukState {
  final String message;
  ProdukLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class ProdukError extends ProdukState {
  final String message;
  ProdukError({required this.message});

  @override
  List<Object?> get props => [message];
}
