import 'package:pos_app/database/bahan_base.dart';
import 'package:pos_app/database/recipe_base.dart';
import 'package:pos_app/db_helper.dart';

class Recipe {
  int id;
  int idProduk;
  int idBahan;
  String nama;
  String satuan;
  double usage;

  Recipe({
    required this.id,
    required this.idProduk,
    required this.idBahan,
    required this.nama,
    required this.satuan,
    required this.usage,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      idProduk: json['idProduk'],
      idBahan: json['idBahan'],
      nama: json['nama'],
      satuan: json['satuan'],
      usage: json['usage'],
      id: json['id'],
    );
  }

  static Future<List<Recipe>> getData(int idProduk) async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.getRecipe(RecipeQueri.tableName, idProduk);
    List<Recipe> data = [];

    for (int i = 0; i < resultObject.length; i++) {
      var bahans = await helper.getBahan(
          BahanQueri.tableName, resultObject[i]['idBahan']);
      data.add(Recipe(
          idProduk: resultObject[i]['idProduk'],
          idBahan: resultObject[i]['idBahan'],
          nama: bahans[0]['nama'],
          satuan: bahans[0]['satuan'],
          usage: resultObject[i]['usage'],
          id: resultObject[i]['id']));
    }
    return data;
  }

  static addRecipe(Map<String, dynamic> data) async {
    DBHelper helper = DBHelper();
    var list = await helper.rawData(
        'SELECT * FROM recipe WHERE idProduk = ${data['idProduk']} and idBahan = ${data['idBahan']}');
    if (list.isEmpty) {
      await helper.insert(RecipeQueri.tableName, data);
    } else {
      await helper.update(RecipeQueri.tableName, data, list[0]['id']);
    }
  }

  static deleteRecipe(int id) async {
    DBHelper helper = DBHelper();

    await helper.remove(RecipeQueri.tableName, 'id', id);
  }
}
