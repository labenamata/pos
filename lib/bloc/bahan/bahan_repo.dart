part of 'bahan_bloc.dart';

Future<void> _getBahan(GetBahan event, Emitter<BahanState> emit) async {
  List<Bahan> bahan;
  emit(BahanLoading(''));
  bahan = await Bahan.getData();
  emit(BahanLoaded(bahan));
}

Future<FutureOr<void>> _searchBahan(
    SearchBahan event, Emitter<BahanState> emit) async {
  List<Bahan> bahan;
  emit(BahanLoading(''));
  bahan = await Bahan.searchBahan(event.nama);
  emit(BahanLoaded(bahan));
}

Future<FutureOr<void>> _tambahBahan(
    TambahBahan event, Emitter<BahanState> emit) async {
  List<Bahan> bahan;
  emit(BahanLoading(''));
  Map<String, dynamic> data = {'nama': event.name, 'satuan': event.satuan};
  Bahan.addBahan(data);
  bahan = await Bahan.getData();
  emit(BahanLoaded(bahan));
}

Future<FutureOr<void>> _hapusBahan(
    HapusBahan event, Emitter<BahanState> emit) async {
  List<Bahan> bahan;
  emit(BahanLoading(''));
  await Bahan.deleteBahan(event.id);
  bahan = await Bahan.getData();
  emit(BahanLoaded(bahan));
}
