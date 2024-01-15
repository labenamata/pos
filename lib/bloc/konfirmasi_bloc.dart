import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/cart_model.dart';

class KonfirmasiEvent {}

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

class GetKonfirmasi extends KonfirmasiEvent {
  String? join;
  int? idKategori;
  String? nama;
  GetKonfirmasi({this.join, this.idKategori, this.nama});
}

class EmptyKonfirmasi extends KonfirmasiEvent {}

class HapusKonfirmasi extends KonfirmasiEvent {
  int id;
  HapusKonfirmasi({required this.id});
}

class TambahKonfirmasi extends KonfirmasiEvent {
  int idProduk;
  int harga;
  String nama;
  int jumlah;
  int total;
  int idx;
  String status;

  TambahKonfirmasi({
    required this.idProduk,
    required this.harga,
    required this.nama,
    required this.jumlah,
    required this.total,
    required this.idx,
    required this.status,
  });
}

class UpdateKonfirmasi extends KonfirmasiEvent {
  int id;
  Map<String, dynamic> data;
  UpdateKonfirmasi({
    required this.id,
    required this.data,
  });
}

class KonfirmasiBloc extends Bloc<KonfirmasiEvent, KonfirmasiState> {
  KonfirmasiBloc(KonfirmasiState initialState) : super(initialState) {
    on<GetKonfirmasi>(_getKonfirmasi);
    on<TambahKonfirmasi>(_tambahKonfirmasi);
    on<HapusKonfirmasi>(_hapusKonfirmasi);
  }

  Future<void> _getKonfirmasi(
      GetKonfirmasi event, Emitter<KonfirmasiState> emit) async {
    Cart cart;
    emit(KonfirmasiLoading(''));
    cart = await Cart.getData(
        join: event.join, idKategori: event.idKategori, nama: event.nama);
    emit(KonfirmasiLoaded(cart));
  }

  FutureOr<void> _tambahKonfirmasi(
      TambahKonfirmasi event, Emitter<KonfirmasiState> emit) async {
    KonfirmasiLoaded stateKonfirmasi = state as KonfirmasiLoaded;
    Cart cart = stateKonfirmasi.data.copyWith();

    cart.cart[event.idx] = ListCart(
        id: event.idProduk,
        nama: event.nama,
        image: stateKonfirmasi.data.cart[event.idx].image,
        harga: event.harga,
        jumlah: event.jumlah >= 0 ? event.jumlah : 0,
        total: event.total);

    Map<String, dynamic> data = {
      'idProduk': event.idProduk,
      'nama': event.nama,
      'harga': event.harga,
      'jumlah': event.jumlah,
      'total': event.total,
    };

    if (event.status == 'plus') {
      cart.totalTransaksi = cart.totalTransaksi + event.harga;
    } else {
      //cart.totalTransaksi = cart.totalTransaksi - event.harga;
      cart.totalTransaksi = event.jumlah >= 0
          ? cart.totalTransaksi - event.harga
          : cart.totalTransaksi;
    }

    if (event.jumlah == 0) {
      await Cart.deleteCart(event.idProduk);
      cart.cart.removeAt(event.idx);
    } else {
      await Cart.addCart(data);
    }

    emit(KonfirmasiLoaded(cart));
  }

  FutureOr<void> _hapusKonfirmasi(
      HapusKonfirmasi event, Emitter<KonfirmasiState> emit) async {
    // Konfirmasi cart;
    //emit(KonfirmasiLoading(''));
    await Cart.deleteCart(event.id);
    // cart = await Konfirmasi.getData();
    // emit(KonfirmasiLoaded(cart));
  }
}
