part of 'kategori_bloc.dart';

class KategoriEvent {}

class GetKategori extends KategoriEvent {}

class SearchKategori extends KategoriEvent {
  int id;
  SearchKategori({required this.id});
}

class HapusKategori extends KategoriEvent {
  int id;
  HapusKategori({required this.id});
}

class TambahKategori extends KategoriEvent {
  String name;
  TambahKategori({required this.name});
}
