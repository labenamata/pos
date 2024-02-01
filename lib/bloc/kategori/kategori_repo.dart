part of 'kategori_bloc.dart';

Future<void> _getKategori(
    GetKategori event, Emitter<KategoriState> emit) async {
  List<Kategori> kategori;
  emit(KategoriLoading(''));
  kategori = await Kategori.getData();
  emit(KategoriLoaded(kategori));
}

Future<FutureOr<void>> _searchKategori(
    SearchKategori event, Emitter<KategoriState> emit) async {
  List<Kategori> kategori;
  emit(KategoriLoading(''));
  kategori = await Kategori.searchData(event.id);
  emit(KategoriLoaded(kategori));
}

Future<FutureOr<void>> _tambahKategori(
    TambahKategori event, Emitter<KategoriState> emit) async {
  List<Kategori> kategori;
  emit(KategoriLoading(''));
  Map<String, dynamic> data = {'nama': event.name};
  Kategori.addKategori(data);
  kategori = await Kategori.getData();
  emit(KategoriLoaded(kategori));
}

Future<FutureOr<void>> _hapusKategori(
    HapusKategori event, Emitter<KategoriState> emit) async {
  List<Kategori> kategori;
  emit(KategoriLoading(''));
  await Kategori.deleteKategori(event.id);
  kategori = await Kategori.getData();
  emit(KategoriLoaded(kategori));
}
