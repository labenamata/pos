part of 'produk_bloc.dart';

Future<void> _getProduk(GetProduk event, Emitter<ProdukState> emit) async {
  List<Produk> produk;
  emit(ProdukLoading(''));
  produk = await Produk.getData();
  emit(ProdukLoaded(produk));
}

Future<FutureOr<void>> _searchProduk(
    SearchProduk event, Emitter<ProdukState> emit) async {
  List<Produk> produk;
  emit(ProdukLoading(''));
  produk = await Produk.searchData(event.nama);
  emit(ProdukLoaded(produk));
}

FutureOr<void> _tambahProduk(
    TambahProduk event, Emitter<ProdukState> emit) async {
  List<Produk> produk;
  emit(ProdukLoading(''));
  Map<String, dynamic> data = {
    'nama': event.nama,
    'idKategori': event.idKategori,
    'hargaPokok': event.hargaPokok,
    'hargaJual': event.hargaJual,
    'image': event.img,
  };
  Produk.addProduk(data);
  produk = await Produk.getData();
  emit(ProdukLoaded(produk));
}

FutureOr<void> _hapusProduk(
    HapusProduk event, Emitter<ProdukState> emit) async {
  List<Produk> produk;
  emit(ProdukLoading(''));
  await Produk.deleteProduk(event.id);
  produk = await Produk.getData();
  emit(ProdukLoaded(produk));
}

FutureOr<void> _updateProduk(
    UpdateProduk event, Emitter<ProdukState> emit) async {
  List<Produk> produk;
  emit(ProdukLoading(''));
  Map<String, dynamic> data = {
    'nama': event.nama,
    'idKategori': event.idKategori,
    'hargaPokok': event.hargaPokok,
    'hargaJual': event.hargaJual,
    'image': event.img,
  };
  await Produk.updateProduk(data, event.id);
  produk = await Produk.getData();
  emit(ProdukLoaded(produk));
}

Future<FutureOr<void>> _produkByKategori(
    ProdukByKategori event, Emitter<ProdukState> emit) async {
  List<Produk> produk;
  emit(ProdukLoading(''));
  produk = await Produk.getDataByKategori(event.idKategori);
  emit(ProdukLoaded(produk));
}
