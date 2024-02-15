import 'package:flutter/material.dart';
import 'package:pos_app/constant.dart';
import 'package:pos_app/database/bahan_base.dart';
import 'package:pos_app/database/cart_base.dart';
import 'package:pos_app/database/detail_base.dart';
import 'package:pos_app/database/kategori_base.dart';
import 'package:pos_app/database/produk_base.dart';
import 'package:pos_app/database/recipe_base.dart';
import 'package:pos_app/database/transaksi_base.dart';
import 'package:pos_app/database/user_base.dart';
import 'package:pos_app/page/cart/cart_page.dart';
import 'package:pos_app/page/login/login_page.dart';
import 'package:pos_app/page/transaksi/transaksi_page.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

final createTable = [
  BahanQueri.createTable,
  KategoriQueri.createTable,
  ProdukQueri.createTable,
  RecipeQueri.createTable,
  TransaksiQueri.createTable,
  CartQueri.createTable,
  DetailQueri.createTable,
  UserQueri.createTable
];

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFinish = false;

  @override
  void initState() {
    super.initState();
    cDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: primaryColor,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(
              isFinish.toString(),
              style: const TextStyle(color: textColor, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  Future<void> cDatabase() async {
    final dbPath = await sqlite.getDatabasesPath();

    Future<Database> db = sqlite.openDatabase(
      path.join(dbPath, 'pos.db'),
    );

    db.then((database) async {
      for (var tables in createTable) {
        await database.execute(tables);
      }
      Map<String, dynamic> data = {
        'nama': 'Master Admin',
        'username': 'admin',
        'password': 'admin',
        'status': 'admin',
      };
      var result = await database
          .query('user', where: 'username = ?', whereArgs: ['admin']);
      if (result.isEmpty) {
        await database.insert(
          'user',
          data,
        );
      }
      setState(() {
        isFinish = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TransaksiPage()),
        );
      });
    });
  }
}
