import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/model/kategori_model.dart';

class KategoriEvent {}

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

class GetKategori extends KategoriEvent {}

class SearchKategori extends KategoriEvent {
  int id;
  SearchKategori({required this.id});
}

class HapusKategori extends KategoriEvent {
  int id;
  HapusKategori({required this.id});
}

class TambahKategori extends KategoriEvent {
  String name;
  TambahKategori({required this.name});
}

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  KategoriBloc(KategoriState initialState) : super(initialState) {
    on<GetKategori>(_getKategori);
    on<SearchKategori>(_searchKategori);
    on<TambahKategori>(_tambahKategori);
    on<HapusKategori>(_hapusKategori);
  }

  Future<void> _getKategori(
      GetKategori event, Emitter<KategoriState> emit) async {
    List<Kategori> kategori;
    emit(KategoriLoading(''));
    kategori = await Kategori.getData();
    emit(KategoriLoaded(kategori));
  }

  Future<FutureOr<void>> _searchKategori(
      SearchKategori event, Emitter<KategoriState> emit) async {
    List<Kategori> kategori;
    emit(KategoriLoading(''));
    kategori = await Kategori.searchData(event.id);
    emit(KategoriLoaded(kategori));
  }

  Future<FutureOr<void>> _tambahKategori(
      TambahKategori event, Emitter<KategoriState> emit) async {
    List<Kategori> kategori;
    emit(KategoriLoading(''));
    Map<String, dynamic> data = {'nama': event.name};
    Kategori.addKategori(data);
    kategori = await Kategori.getData();
    emit(KategoriLoaded(kategori));
  }

  Future<FutureOr<void>> _hapusKategori(
      HapusKategori event, Emitter<KategoriState> emit) async {
    List<Kategori> kategori;
    emit(KategoriLoading(''));
    await Kategori.deleteKategori(event.id);
    kategori = await Kategori.getData();
    emit(KategoriLoaded(kategori));
  }
}
