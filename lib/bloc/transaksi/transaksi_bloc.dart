import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/transaksi_model.dart';

part 'transaksi_event.dart';
part 'transaksi_state.dart';
part 'transaksi_repo.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  TransaksiBloc(super.initialState) {
    on<GetTransaksi>(_getTransaksi);
    on<SimpanTransaksi>(_simpanTransaksi);
  }
}
