part of 'bahan_bloc.dart';

abstract class BahanState extends Equatable {}

class BahanLoaded extends BahanState {
  final List<Bahan> data;
  BahanLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class BahanLoading extends BahanState {
  final String message;
  BahanLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class BahanError extends BahanState {
  final String message;
  BahanError({required this.message});

  @override
  List<Object?> get props => [message];
}
