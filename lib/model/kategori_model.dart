import 'package:pos_app/database/kategori_base.dart';
import 'package:pos_app/db_helper.dart';

class Kategori {
  int id;
  String nama;
  Kategori({
    required this.id,
    required this.nama,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'],
    );
  }

  static Future<List<Kategori>> getData() async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.getData(KategoriQueri.tableName);
    List<Kategori> listKategori =
        resultObject.map((item) => Kategori.fromJson(item)).toList();
    return listKategori;
  }

  static Future<List<Kategori>> searchData(int id) async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.search(KategoriQueri.tableName, id);
    return resultObject
        .map((item) => Kategori(
              id: item['id'],
              nama: item['nama'],
            ))
        .toList();
  }

  static addKategori(Map<String, dynamic> data) async {
    DBHelper helper = DBHelper();
    await helper.insert(KategoriQueri.tableName, data);
  }

  static deleteKategori(int id) async {
    DBHelper helper = DBHelper();

    await helper.remove(KategoriQueri.tableName, 'id', id);
  }
}
