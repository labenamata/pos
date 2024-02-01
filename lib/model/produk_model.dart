import 'package:flutter/services.dart';

import 'package:pos_app/database/produk_base.dart';
import 'package:pos_app/db_helper.dart';

class Produk {
  int id;
  String nama;
  int hargaPokok;
  int hargaJual;
  Uint8List image;
  int idKategori;
  String namaKategori;

  Produk({
    required this.id,
    required this.nama,
    required this.hargaPokok,
    required this.hargaJual,
    required this.image,
    required this.idKategori,
    required this.namaKategori,
  });

  Produk copyWith({
    int? id,
    String? nama,
    int? hargaPokok,
    int? hargaJual,
    Uint8List? image,
    int? idKategori,
    String? namaKategori,
  }) {
    return Produk(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      hargaPokok: hargaPokok ?? this.hargaPokok,
      hargaJual: hargaJual ?? this.hargaJual,
      image: image ?? this.image,
      idKategori: idKategori ?? this.idKategori,
      namaKategori: namaKategori ?? this.namaKategori,
    );
  }

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
        id: json['id'],
        nama: json['nama'],
        hargaPokok: json['hargaPokok'],
        hargaJual: json['hargaJual'],
        image: json['image'],
        idKategori: json['idKategori'],
        namaKategori: json['namaKategori']);
  }

  static Future<List<Produk>> getData() async {
    DBHelper helper = DBHelper();
    String sql =
        'select produk.id, produk.nama, produk.hargaPokok, produk.idKategori, '
        'produk.hargaJual, produk.image, kategori.nama as namaKategori from produk inner join kategori '
        'on produk.idKategori = kategori.id';

    var resultObject = await helper.rawData(sql);
    List<Produk> listProduk =
        resultObject.map((item) => Produk.fromJson(item).copyWith()).toList();
    return listProduk;
  }

  static Future<List<Produk>> getDataByKategori(int id) async {
    DBHelper helper = DBHelper();
    String sql =
        'select produk.id, produk.nama, produk.hargaPokok, produk.idKategori, '
        'produk.hargaJual, produk.image, kategori.nama as namaKategori from produk inner join kategori '
        'on produk.idKategori = kategori.id where produk.idKategori =$id';

    var resultObject = await helper.rawData(sql);
    List<Produk> listProduk =
        resultObject.map((item) => Produk.fromJson(item).copyWith()).toList();
    return listProduk;
  }

  static Future<List<Produk>> searchData(String nama) async {
    DBHelper helper = DBHelper();
    String sql =
        'select produk.id, produk.nama, produk.hargaPokok, produk.idKategori, '
        'produk.hargaJual, produk.image, kategori.nama as namaKategori from produk inner join kategori '
        'on produk.idKategori = kategori.id where produk.nama like \'%$nama%\'';
    var resultObject = await helper.rawData(sql);
    List<Produk> listProduk =
        resultObject.map((item) => Produk.fromJson(item)).toList();
    return listProduk;
  }

  static addProduk(Map<String, dynamic> data) async {
    DBHelper helper = DBHelper();
    await helper.insert(ProdukQueri.tableName, data);
  }

  static updateProduk(Map<String, dynamic> data, int id) async {
    DBHelper helper = DBHelper();
    await helper.update(ProdukQueri.tableName, data, id);
  }

  static deleteProduk(int id) async {
    DBHelper helper = DBHelper();

    await helper.remove(ProdukQueri.tableName, 'id', id);
  }
}
