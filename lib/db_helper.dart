import 'package:pos_app/database/bahan_base.dart';
import 'package:pos_app/database/cart_base.dart';
import 'package:pos_app/database/detail_base.dart';
import 'package:pos_app/database/kategori_base.dart';
import 'package:pos_app/database/produk_base.dart';
import 'package:pos_app/database/recipe_base.dart';
import 'package:pos_app/database/transaksi_base.dart';
import 'package:pos_app/database/user_base.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static final DBHelper _dbHelper = DBHelper._singleton();

  factory DBHelper() {
    return _dbHelper;
  }

  DBHelper._singleton();

  //baris terakhir singleton

  final createTable = [
    BahanQueri.createTable,
    KategoriQueri.createTable,
    ProdukQueri.createTable,
    RecipeQueri.createTable,
    TransaksiQueri.createTable,
    CartQueri.createTable,
    DetailQueri.createTable,
    UserQueri.createTable
  ]; // membuat daftar table yang akan dibuat

  Future<Database> openDB() async {
    final dbPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(path.join(dbPath, 'pos.db'),
        onCreate: (db, version) async {
      // for (var tables in createTable) {
      //   await db.execute(tables).then((value) {}).catchError((err) {
      //     if (kDebugMode) {
      //       print("errornya ${err.toString()}");
      //     }
      //   });
      // }
      // Map<String, dynamic> data = {
      //   'nama': 'Master Admin',
      //   'username': 'admin',
      //   'password': 'admin',
      //   'status': 'admin',
      // };
      // var result =
      //     await db.query('user', where: 'username = ?', whereArgs: ['admin']);
      // if (result.isEmpty) {
      //   await db.insert(
      //     'user',
      //     data,
      //   );
      // }
    }, version: 1);
  }

  insert(String table, Map<String, dynamic> data) async {
    final db = await openDB();
    var result = await db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  update(String table, Map<String, dynamic> data, int id) async {
    final db = await openDB();
    var result =
        await db.update(table, data, where: 'id = ?', whereArgs: ['$id']);
    return result;
  }

  search(String table, int id) async {
    final db = await openDB();
    var result = await db.query(table, where: 'id = ?', whereArgs: ['$id']);
    return result;
  }

  Future<List> searchRaw(String table, int id) async {
    final db = await openDB();
    var result = await db.query(table, where: 'id = ?', whereArgs: ['$id']);
    return result;
  }

  Future<List> searchLike(String table, String name) async {
    final db = await openDB();
    var result =
        await db.query(table, where: 'nama LIKE ?', whereArgs: ['%$name%']);
    return result;
  }

  Future<List> getData(String tableName) async {
    final db = await openDB();
    var result = await db.query(tableName);
    return result.toList();
  }

  Future<List> getRecipe(String tableName, int id) async {
    final db = await openDB();
    var result =
        await db.query(tableName, where: 'idProduk = ?', whereArgs: ['$id']);
    return result.toList();
  }

  Future<List> getBahan(String tableName, int id) async {
    final db = await openDB();
    var result = await db.query(tableName, where: 'id = ?', whereArgs: ['$id']);
    return result.toList();
  }

  Future<List> getByKategori(String tableName, int id) async {
    final db = await openDB();
    var result =
        await db.query(tableName, where: 'idKategori = ?', whereArgs: ['$id']);
    return result.toList();
  }

  remove(String table, String field, int id) async {
    final db = await openDB();
    var result =
        await db.delete(table, where: '$field = ?', whereArgs: ['$id']);
    return result;
  }

  empty(String table) async {
    final db = await openDB();
    var result = await db.delete(table);
    return result;
  }

  Future<List> tempData(int id) async {
    final db = await openDB();
    var result = await db.query("temp",
        columns: ['qty'], where: 'menu_id = ?', whereArgs: ['$id']);
    return result.toList();
  }

  Future<List> rawData(String sql) async {
    final db = await openDB();
    var result = await db.rawQuery(sql);
    return result.toList();
  }
}
