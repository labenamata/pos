import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/cart_model.dart';

part 'cart_event.dart';
part 'cart_repo.dart';
part 'cart_state.dart';

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
    on<TambahCart>((event, emit) async {
      await _tambahCart(event, emit, state);
    });

    on<HapusCart>(_hapusCart);
    on<UpdateCart>(_updateCart);
    on<EmptyCart>(_emptyCart);
  }
}
