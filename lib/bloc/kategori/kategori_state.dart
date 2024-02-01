part of 'kategori_bloc.dart';

abstract class KategoriState extends Equatable {}

class KategoriLoaded extends KategoriState {
  final List<Kategori> data;
  KategoriLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class KategoriLoading extends KategoriState {
  final String message;
  KategoriLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class KategoriError extends KategoriState {
  final String message;
  KategoriError({required this.message});

  @override
  List<Object?> get props => [message];
}
