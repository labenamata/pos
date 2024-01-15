import 'package:pos_app/database/bahan_base.dart';
import 'package:pos_app/db_helper.dart';

class Bahan {
  int id;
  String nama;
  String satuan;

  Bahan({
    required this.id,
    required this.nama,
    required this.satuan,
  });

  factory Bahan.fromJson(Map<String, dynamic> json) {
    return Bahan(
      id: json['id'],
      nama: json['nama'],
      satuan: json['satuan'],
    );
  }

  static Future<List<Bahan>> getData() async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.getData(BahanQueri.tableName);

    return resultObject
        .map((item) => Bahan(
              id: item['id'],
              nama: item['nama'],
              satuan: item['satuan'],
            ))
        .toList();
  }

  static Future<List<Bahan>> searchBahan(String nama) async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.searchLike(BahanQueri.tableName, nama);

    return resultObject
        .map((item) => Bahan(
              id: item['id'],
              nama: item['nama'],
              satuan: item['satuan'],
            ))
        .toList();
  }

  static addBahan(Map<String, dynamic> data) async {
    DBHelper helper = DBHelper();
    await helper.insert(BahanQueri.tableName, data);
  }

  static deleteBahan(int id) async {
    DBHelper helper = DBHelper();

    await helper.remove(BahanQueri.tableName, 'id', id);
  }
}
