import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/model/kategori_model.dart';

part 'kategori_event.dart';
part 'kategori_state.dart';

part 'kategori_repo.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  KategoriBloc(KategoriState initialState) : super(initialState) {
    on<GetKategori>(_getKategori);
    on<SearchKategori>(_searchKategori);
    on<TambahKategori>(_tambahKategori);
    on<HapusKategori>(_hapusKategori);
  }
}
