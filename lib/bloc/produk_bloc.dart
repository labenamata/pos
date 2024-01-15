import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/produk_model.dart';

class ProdukEvent {}

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

class GetProduk extends ProdukEvent {}

class SearchProduk extends ProdukEvent {
  String nama;
  SearchProduk({required this.nama});
}

class ProdukByKategori extends ProdukEvent {
  int idKategori;
  ProdukByKategori({required this.idKategori});
}

class HapusProduk extends ProdukEvent {
  int id;
  HapusProduk({required this.id});
}

class TambahProduk extends ProdukEvent {
  String nama;
  int hargaPokok;
  int hargaJual;
  int idKategori;
  Uint8List img;
  TambahProduk({
    required this.nama,
    required this.hargaPokok,
    required this.hargaJual,
    required this.idKategori,
    required this.img,
  });
}

class UpdateProduk extends ProdukEvent {
  int id;
  String nama;
  int hargaPokok;
  int hargaJual;
  int idKategori;
  Uint8List img;
  UpdateProduk({
    required this.id,
    required this.nama,
    required this.hargaPokok,
    required this.hargaJual,
    required this.idKategori,
    required this.img,
  });
}

class ProdukBloc extends Bloc<ProdukEvent, ProdukState> {
  ProdukBloc(ProdukState initialState) : super(initialState) {
    on<GetProduk>(_getProduk);
    on<SearchProduk>(_searchProduk);
    on<TambahProduk>(_tambahProduk);
    on<HapusProduk>(_hapusProduk);
    on<UpdateProduk>(_updateProduk);
    on<ProdukByKategori>(_produkByKategori);
  }

  Future<void> _getProduk(GetProduk event, Emitter<ProdukState> emit) async {
    List<Produk> produk;
    emit(ProdukLoading(''));
    produk = await Produk.getData();
    emit(ProdukLoaded(produk));
  }

  Future<FutureOr<void>> _searchProduk(
      SearchProduk event, Emitter<ProdukState> emit) async {
    List<Produk> produk;
    emit(ProdukLoading(''));
    produk = await Produk.searchData(event.nama);
    emit(ProdukLoaded(produk));
  }

  FutureOr<void> _tambahProduk(
      TambahProduk event, Emitter<ProdukState> emit) async {
    List<Produk> produk;
    emit(ProdukLoading(''));
    Map<String, dynamic> data = {
      'nama': event.nama,
      'idKategori': event.idKategori,
      'hargaPokok': event.hargaPokok,
      'hargaJual': event.hargaJual,
      'image': event.img,
    };
    Produk.addProduk(data);
    produk = await Produk.getData();
    emit(ProdukLoaded(produk));
  }

  FutureOr<void> _hapusProduk(
      HapusProduk event, Emitter<ProdukState> emit) async {
    List<Produk> produk;
    emit(ProdukLoading(''));
    await Produk.deleteProduk(event.id);
    produk = await Produk.getData();
    emit(ProdukLoaded(produk));
  }

  FutureOr<void> _updateProduk(
      UpdateProduk event, Emitter<ProdukState> emit) async {
    List<Produk> produk;
    emit(ProdukLoading(''));
    Map<String, dynamic> data = {
      'nama': event.nama,
      'idKategori': event.idKategori,
      'hargaPokok': event.hargaPokok,
      'hargaJual': event.hargaJual,
      'image': event.img,
    };
    await Produk.updateProduk(data, event.id);
    produk = await Produk.getData();
    emit(ProdukLoaded(produk));
  }

  Future<FutureOr<void>> _produkByKategori(
      ProdukByKategori event, Emitter<ProdukState> emit) async {
    List<Produk> produk;
    emit(ProdukLoading(''));
    produk = await Produk.getDataByKategori(event.idKategori);
    emit(ProdukLoaded(produk));
  }
}
