part of 'konfirmasi_bloc.dart';

Future<void> _getKonfirmasi(
    GetKonfirmasi event, Emitter<KonfirmasiState> emit) async {
  Cart cart;
  emit(KonfirmasiLoading(''));
  cart = await Cart.getData(
      join: event.join, idKategori: event.idKategori, nama: event.nama);
  emit(KonfirmasiLoaded(cart));
}

FutureOr<void> _tambahKonfirmasi(TambahKonfirmasi event,
    Emitter<KonfirmasiState> emit, KonfirmasiState state) async {
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
