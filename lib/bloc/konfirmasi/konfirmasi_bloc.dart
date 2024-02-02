import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/cart_model.dart';

part 'konfirmasi_event.dart';
part 'konfirmasi_state.dart';
part 'konfirmasi_repo.dart';

class KonfirmasiBloc extends Bloc<KonfirmasiEvent, KonfirmasiState> {
  KonfirmasiBloc(KonfirmasiState initialState) : super(initialState) {
    on<GetKonfirmasi>(_getKonfirmasi);
    on<TambahKonfirmasi>((event, emit) async {
      await _tambahKonfirmasi(event, emit, state);
    });

    on<HapusKonfirmasi>(_hapusKonfirmasi);
  }
}
