import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/produk_model.dart';

part 'produk_event.dart';
part 'produk_repo.dart';
part 'produk_state.dart';

class ProdukBloc extends Bloc<ProdukEvent, ProdukState> {
  ProdukBloc(ProdukState initialState) : super(initialState) {
    on<GetProduk>(_getProduk);
    on<SearchProduk>(_searchProduk);
    on<TambahProduk>(_tambahProduk);
    on<HapusProduk>(_hapusProduk);
    on<UpdateProduk>(_updateProduk);
    on<ProdukByKategori>(_produkByKategori);
  }
}
