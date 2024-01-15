import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/bahan_model.dart';

class BahanEvent {}

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

class GetBahan extends BahanEvent {}

class SearchBahan extends BahanEvent {
  String nama;
  SearchBahan({required this.nama});
}

class HapusBahan extends BahanEvent {
  int id;
  HapusBahan({required this.id});
}

class TambahBahan extends BahanEvent {
  String name;
  String satuan;
  TambahBahan({
    required this.name,
    required this.satuan,
  });
}

class BahanBloc extends Bloc<BahanEvent, BahanState> {
  BahanBloc(BahanState initialState) : super(initialState) {
    on<GetBahan>(_getBahan);
    on<SearchBahan>(_searchBahan);
    on<TambahBahan>(_tambahBahan);
    on<HapusBahan>(_hapusBahan);
  }

  Future<void> _getBahan(GetBahan event, Emitter<BahanState> emit) async {
    List<Bahan> bahan;
    emit(BahanLoading(''));
    bahan = await Bahan.getData();
    emit(BahanLoaded(bahan));
  }

  Future<FutureOr<void>> _searchBahan(
      SearchBahan event, Emitter<BahanState> emit) async {
    List<Bahan> bahan;
    emit(BahanLoading(''));
    bahan = await Bahan.searchBahan(event.nama);
    emit(BahanLoaded(bahan));
  }

  Future<FutureOr<void>> _tambahBahan(
      TambahBahan event, Emitter<BahanState> emit) async {
    List<Bahan> bahan;
    emit(BahanLoading(''));
    Map<String, dynamic> data = {'nama': event.name, 'satuan': event.satuan};
    Bahan.addBahan(data);
    bahan = await Bahan.getData();
    emit(BahanLoaded(bahan));
  }

  Future<FutureOr<void>> _hapusBahan(
      HapusBahan event, Emitter<BahanState> emit) async {
    List<Bahan> bahan;
    emit(BahanLoading(''));
    await Bahan.deleteBahan(event.id);
    bahan = await Bahan.getData();
    emit(BahanLoaded(bahan));
  }
}
