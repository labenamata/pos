part of 'cart_bloc.dart';

Future<void> _getCart(GetCart event, Emitter<CartState> emit) async {
  Cart cart;
  emit(CartLoading(''));
  cart = await Cart.getData(
      join: event.join, idKategori: event.idKategori, nama: event.nama);
  emit(CartLoaded(cart));
}

FutureOr<void> _tambahCart(
    TambahCart event, Emitter<CartState> emit, CartState state) async {
  CartLoaded stateCart = state as CartLoaded;
  Cart cart = stateCart.data.copyWith();

  if (event.status == 'plus') {
    cart.totalTransaksi = cart.totalTransaksi + event.harga;
  } else {
    if (cart.cart[event.idx].jumlah > 0) {
      cart.totalTransaksi = cart.totalTransaksi - event.harga;
    }
  }

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

  // var total = cart.cart.fold(0, (p, c) => p + c.total);
  // cart.totalTransaksi = total;
  // if (event.status == 'plus') {
  //   cart.totalTransaksi = cart.totalTransaksi + event.harga;
  // } else {
  //   cart.totalTransaksi = event.jumlah >= 0
  //       ? cart.totalTransaksi - event.harga
  //       : cart.totalTransaksi;
  // }

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
