import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/cart_model.dart';

class CartEvent {}

abstract class CartState extends Equatable {}

class CartLoaded extends CartState {
  final Cart data;
  CartLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CartLoading extends CartState {
  final String message;
  CartLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class CartError extends CartState {
  final String message;
  CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetCart extends CartEvent {
  String? join;
  int? idKategori;
  String? nama;
  GetCart({this.join, this.idKategori, this.nama});
}

class EmptyCart extends CartEvent {}

class HapusCart extends CartEvent {
  int id;
  HapusCart({required this.id});
}

class TambahCart extends CartEvent {
  int idProduk;
  int harga;
  String nama;
  int jumlah;
  int total;
  int idx;
  String status;

  TambahCart({
    required this.idProduk,
    required this.harga,
    required this.nama,
    required this.jumlah,
    required this.total,
    required this.idx,
    required this.status,
  });
}

class UpdateCart extends CartEvent {
  int id;
  Map<String, dynamic> data;
  UpdateCart({
    required this.id,
    required this.data,
  });
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(CartState initialState) : super(initialState) {
    on<GetCart>(_getCart);
    on<TambahCart>(_tambahCart);
    on<HapusCart>(_hapusCart);
    on<UpdateCart>(_updateCart);
    on<EmptyCart>(_emptyCart);
  }

  Future<void> _getCart(GetCart event, Emitter<CartState> emit) async {
    Cart cart;
    emit(CartLoading(''));
    cart = await Cart.getData(
        join: event.join, idKategori: event.idKategori, nama: event.nama);
    emit(CartLoaded(cart));
  }

  FutureOr<void> _tambahCart(TambahCart event, Emitter<CartState> emit) async {
    CartLoaded stateCart = state as CartLoaded;
    Cart cart = stateCart.data.copyWith();

    cart.cart[event.idx] = ListCart(
        id: event.idProduk,
        nama: event.nama,
        image: stateCart.data.cart[event.idx].image,
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

    //emit(CartLoading(''));
    await Cart.addCart(data);

    emit(CartLoaded(cart));
  }

  FutureOr<void> _hapusCart(HapusCart event, Emitter<CartState> emit) async {
    // Cart cart;
    //emit(CartLoading(''));
    await Cart.deleteCart(event.id);
    // cart = await Cart.getData();
    // emit(CartLoaded(cart));
  }

  FutureOr<void> _updateCart(UpdateCart event, Emitter<CartState> emit) async {
    Cart cart;
    emit(CartLoading(''));
    await Cart.addCart(event.data);
    cart = await Cart.getData();
    emit(CartLoaded(cart));
  }

  Future<FutureOr<void>> _emptyCart(
      EmptyCart event, Emitter<CartState> emit) async {
    Cart cart;
    emit(CartLoading(''));
    await Cart.emptyCart();
    cart = await Cart.getData();
    emit(CartLoaded(cart));
  }
}
