part of 'bahan_bloc.dart';

class BahanEvent {}

class GetBahan extends BahanEvent {}

class SearchBahan extends BahanEvent {
  String nama;
  SearchBahan({required this.nama});
}

class HapusBahan extends BahanEvent {
  int id;
  HapusBahan({required this.id});
}

class TambahBahan extends BahanEvent {
  String name;
  String satuan;
  TambahBahan({
    required this.name,
    required this.satuan,
  });
}
