part of 'konfirmasi_bloc.dart';

abstract class KonfirmasiState extends Equatable {}

class KonfirmasiLoaded extends KonfirmasiState {
  final Cart data;
  KonfirmasiLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class KonfirmasiLoading extends KonfirmasiState {
  final String message;
  KonfirmasiLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class KonfirmasiError extends KonfirmasiState {
  final String message;
  KonfirmasiError({required this.message});

  @override
  List<Object?> get props => [message];
}
