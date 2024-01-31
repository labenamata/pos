import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/transaksi_model.dart';

class TransaksiEvent {}

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

class GetTransaksi extends TransaksiEvent {
  String status;
  int? tanggal;
  int? bulan;
  int? tahun;
  GetTransaksi({
    required this.status,
    this.tanggal,
    this.bulan,
    this.tahun,
  });
}

class SimpanTransaksi extends TransaksiEvent {
  Map<String, dynamic> dataTransaksi;
  SimpanTransaksi({
    required this.dataTransaksi,
  });
}

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  TransaksiBloc(super.initialState) {
    on<GetTransaksi>(_getTransaksi);
    on<SimpanTransaksi>(_simpanTransaksi);
  }

  Future<FutureOr<void>> _getTransaksi(
      GetTransaksi event, Emitter<TransaksiState> emit) async {
    Transaksi transaksi;
    emit(TransaksiLoading());
    transaksi = await Transaksi.getData(
        status: event.status,
        tahun: event.tahun,
        bulan: event.bulan,
        tanggal: event.tanggal);
    emit(TransaksiLoaded(transaksi));
  }

  Future<FutureOr<void>> _simpanTransaksi(
      SimpanTransaksi event, Emitter<TransaksiState> emit) async {
    Transaksi transaksi;
    emit(TransaksiLoading());
    await Transaksi.addTransaksi(event.dataTransaksi);
    transaksi = await Transaksi.getData(status: 'finish');
    emit(TransaksiLoaded(transaksi));
  }
}
