part of 'produk_bloc.dart';

class ProdukEvent {}

class GetProduk extends ProdukEvent {}

class SearchProduk extends ProdukEvent {
  String nama;
  SearchProduk({required this.nama});
}

class ProdukByKategori extends ProdukEvent {
  int idKategori;
  ProdukByKategori({required this.idKategori});
}

class HapusProduk extends ProdukEvent {
  int id;
  HapusProduk({required this.id});
}

class TambahProduk extends ProdukEvent {
  String nama;
  int hargaPokok;
  int hargaJual;
  int idKategori;
  Uint8List img;
  TambahProduk({
    required this.nama,
    required this.hargaPokok,
    required this.hargaJual,
    required this.idKategori,
    required this.img,
  });
}

class UpdateProduk extends ProdukEvent {
  int id;
  String nama;
  int hargaPokok;
  int hargaJual;
  int idKategori;
  Uint8List img;
  UpdateProduk({
    required this.id,
    required this.nama,
    required this.hargaPokok,
    required this.hargaJual,
    required this.idKategori,
    required this.img,
  });
}
