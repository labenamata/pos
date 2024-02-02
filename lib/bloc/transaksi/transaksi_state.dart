part of 'transaksi_bloc.dart';

abstract class TransaksiState extends Equatable {}

class TransaksiLoaded extends TransaksiState {
  final Transaksi data;
  TransaksiLoaded(
    this.data,
  );

  @override
  List<Object?> get props => [data];
}

class TransaksiLoading extends TransaksiState {
  @override
  List<Object?> get props => [];
}
