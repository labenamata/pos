part of 'transaksi_bloc.dart';

class TransaksiEvent {}

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
