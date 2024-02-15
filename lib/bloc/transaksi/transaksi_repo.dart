part of 'transaksi_bloc.dart';

Future<FutureOr<void>> _getTransaksi(
    GetTransaksi event, Emitter<TransaksiState> emit) async {
  Transaksi transaksi;
  emit(TransaksiLoading());
  transaksi = await Transaksi.getData(
      status: event.status,
      tahun: event.tahun,
      bulan: event.bulan,
      tanggal: event.tanggal);
  emit(TransaksiLoaded(transaksi));
}

Future<FutureOr<void>> _simpanTransaksi(
    SimpanTransaksi event, Emitter<TransaksiState> emit) async {
  Transaksi transaksi;
  emit(TransaksiLoading());
  await Transaksi.addTransaksi(event.dataTransaksi);
  transaksi = await Transaksi.getData(status: 'pending');
  emit(TransaksiLoaded(transaksi));
}
