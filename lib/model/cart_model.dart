import 'dart:typed_data';
import 'package:pos_app/database/cart_base.dart';
import 'package:pos_app/database/kategori_base.dart';
import 'package:pos_app/database/produk_base.dart';
import 'package:pos_app/db_helper.dart';

class Cart {
  int totalTransaksi;
  List<ListCart> cart;
  Cart({
    required this.totalTransaksi,
    required this.cart,
  });

  Cart copyWith({int? totalTransaksi, List<ListCart>? cart}) {
    return Cart(
      totalTransaksi: totalTransaksi ?? this.totalTransaksi,
      cart: cart ?? this.cart,
    );
  }

  // factory Cart.fromJson(Map<String, dynamic> json) {
  //   //var jsonDetail = json['detail'] as List;
  //   return Cart(
  //     totalTransaksi: json['total'],
  //     idProduk: json['idProduk'],
  //     image: json['image'],
  //     nama: json['nama'],
  //     harga: json['harga'],
  //     jumlah: json['jumlah'],
  //     total: json['total'],
  //   );
  // }

  static Future<Cart> getData({
    String? join,
    int? idKategori,
    String? nama,
  }) async {
    DBHelper helper = DBHelper();
    String sql = CartQueri.select;
    int total = 0;
    String fieldSelect = 'select produk.id,'
        'produk.nama,'
        'produk.hargaJual,'
        'produk.image,'
        'cart.jumlah,'
        'cart.total';

    if (join == null) {
      sql = '$fieldSelect from ${ProdukQueri.tableName} '
          'left join ${CartQueri.tableName} on ${CartQueri.tableName}.idProduk = ${ProdukQueri.tableName}.id '
          'join ${KategoriQueri.tableName} on ${KategoriQueri.tableName}.id = ${ProdukQueri.tableName}.idKategori';
    } else {
      sql = '$fieldSelect from ${CartQueri.tableName} '
          'join ${ProdukQueri.tableName} on ${CartQueri.tableName}.idProduk = ${ProdukQueri.tableName}.id '
          'join ${KategoriQueri.tableName} on ${KategoriQueri.tableName}.id = ${ProdukQueri.tableName}.idKategori '
          'where ${CartQueri.tableName}.jumlah <> 0';
    }

    if (idKategori != null) {
      sql = '$fieldSelect from produk '
          'left join ${CartQueri.tableName} on ${CartQueri.tableName}.idProduk = produk.id '
          'where produk.idKategori = $idKategori';
    }

    if (nama != null) {
      sql = '$fieldSelect from produk '
          'left join ${CartQueri.tableName} on ${CartQueri.tableName}.idProduk = produk.id '
          'where produk.nama like \'%$nama%\'';
    }

    var resultObject = await helper.rawData(sql);
    var sumCart = await helper.rawData(CartQueri.selectSum);

    List<ListCart> listCart =
        resultObject.map((item) => ListCart.fromJson(item)).toList();

    total = sumCart[0]['total'] ?? 0;

    Cart finalData = Cart(cart: listCart, totalTransaksi: total);
    return finalData;
  }

  static addCart(Map<String, dynamic> data) async {
    DBHelper helper = DBHelper();
    List resultObject = await helper.rawData(
        'select * from ${CartQueri.tableName} where idProduk = ${data['idProduk']}');
    if (resultObject.isNotEmpty) {
      await helper.update(CartQueri.tableName, data, resultObject[0]['id']);
    } else {
      await helper.insert(CartQueri.tableName, data);
    }
  }

  static deleteCart(int id) async {
    DBHelper helper = DBHelper();
    await helper.remove(CartQueri.tableName, 'idProduk', id);
  }

  static emptyCart() async {
    DBHelper helper = DBHelper();
    await helper.empty(CartQueri.tableName);
  }
}

class ListCart {
  int id;
  String nama;
  Uint8List image;
  int harga;
  int jumlah;
  int total;

  ListCart({
    required this.id,
    required this.nama,
    required this.image,
    required this.harga,
    required this.jumlah,
    required this.total,
  });

  factory ListCart.fromJson(Map<String, dynamic> json) {
    return ListCart(
      id: json['id'] ?? 0,
      nama: json['nama'],
      image: json['image'],
      harga: json['hargaJual'],
      jumlah: json['jumlah'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
