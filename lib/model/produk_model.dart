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

  Produk({
    required this.id,
    required this.nama,
    required this.hargaPokok,
    required this.hargaJual,
    required this.image,
    required this.idKategori,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      nama: json['nama'],
      hargaPokok: json['hargaPokok'],
      hargaJual: json['hargaJual'],
      image: json['image'],
      idKategori: json['idKategori'],
    );
  }

  static Future<List<Produk>> getData() async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.getData(ProdukQueri.tableName);
    List<Produk> listProduk =
        resultObject.map((item) => Produk.fromJson(item)).toList();
    return listProduk;
  }

  static Future<List<Produk>> getDataByKategori(int id) async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.getByKategori(ProdukQueri.tableName, id);
    List<Produk> listProduk =
        resultObject.map((item) => Produk.fromJson(item)).toList();
    return listProduk;
  }

  static Future<List<Produk>> searchData(String nama) async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.searchLike(ProdukQueri.tableName, nama);
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
