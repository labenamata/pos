part of 'konfirmasi_bloc.dart';

class KonfirmasiEvent {}

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
