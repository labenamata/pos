part of 'cart_bloc.dart';

class CartEvent {}

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
