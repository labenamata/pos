import 'package:pos_app/database/cart_base.dart';
import 'package:pos_app/database/detail_base.dart';
import 'package:pos_app/database/produk_base.dart';
import 'package:pos_app/database/transaksi_base.dart';
import 'package:pos_app/db_helper.dart';
import 'package:pos_app/model/cart_model.dart';

class Transaksi {
  int total;
  List<ListTransaksi> transaksiList;

  Transaksi({
    required this.total,
    required this.transaksiList,
  });

  Transaksi copyWith({int? total, List<ListTransaksi>? transaksiList}) {
    return Transaksi(
      total: total ?? this.total,
      transaksiList: transaksiList ?? this.transaksiList,
    );
  }

  static Future<Transaksi> getData(
      {int? tanggal, int? bulan, int? tahun, required String status}) async {
    DBHelper helper = DBHelper();
    List resultObject;
    List<ListTransaksi> listTransaksi = [];
    int total = 0;
    //String sql = 'SELECT * FROM transaksi';
    String sql = 'FROM transaksi where status = \'$status\'';
    if (tanggal != null && bulan != null && tahun != null) {
      sql =
          'FROM ${TransaksiQueri.tableName} WHERE tanggal = $tanggal and bulan = $bulan and tahun = $tahun and status = '
          '\'$status\'';
    } else if (tanggal == null && bulan != null && tahun != null) {
      sql =
          'FROM ${TransaksiQueri.tableName} WHERE bulan = $bulan and tahun = $tahun and status = \'$status\'';
    } else if (tanggal == null && bulan == null && tahun != null) {
      sql =
          'FROM ${TransaksiQueri.tableName} WHERE tahun = $tahun and status = \'$status\'';
    }

    String sqlAll = 'SELECT * ';

    String sqlSum = 'SELECT sum(total) as total ';

    resultObject = await helper.rawData(sqlAll + sql);
    var sumTransaksi = await helper.rawData(sqlSum + sql);

    for (var item in resultObject) {
      String sql =
          'SELECT * FROM ${DetailQueri.tableName} WHERE idTransaksi = ${item['id']}';
      var cariTransaksi = await helper.rawData(sql);
      listTransaksi.add(ListTransaksi.fromJson(item, cariTransaksi));
    }

    total = sumTransaksi[0]['total'] ?? 0;
    // resultObject.map((item) async {
    //   String sql =
    //       'SELECT * FROM ${DetailQueri.tableName} WHERE idTransaksi = ${item['id']}';
    //   var cariTransaksi = await helper.rawData(sql);
    //   if (kDebugMode) {
    //     print('detail ${cariTransaksi.length}');
    //   }
    //   listTransaksi.add(Transaksi.fromJson(item, cariTransaksi));
    // });
    // for (int i = 0; i <= resultObject.length; i++) {
    //   String sql =
    //       'SELECT * FROM ${DetailQueri.tableName} WHERE idTransaksi = ${resultObject[i]['id']}';
    //   var cariTransaksi = await helper.rawData(sql);
    //   listTransaksi.add(Transaksi(
    //       id: resultObject[i]['id'],
    //       tanggal: resultObject[i]['id'],
    //       bulan: resultObject[i]['id'],
    //       tahun: resultObject[i]['id'],
    //       jam: resultObject[i]['id'],
    //       an: resultObject[i]['id'],
    //       total: resultObject[i]['id'],
    //       status: resultObject[i]['id'],
    //       pembayaran: resultObject[i]['id'],
    //       bayar: resultObject[i]['id'],
    //       kembali: resultObject[i]['id']));
    // }

    Transaksi transaksi = Transaksi(transaksiList: listTransaksi, total: total);

    return transaksi;
  }

  static addTransaksi(Map<String, dynamic> data) async {
    DBHelper helper = DBHelper();
    int insertId = await helper.insert(TransaksiQueri.tableName, data);
    var detail = await helper.getData(CartQueri.tableName);

    for (var element in detail) {
      Map<String, dynamic> inserData = {
        'idTransaksi': insertId,
        'idProduk': element['idProduk'],
        'nama': element['nama'],
        'harga': element['harga'],
        'jumlah': element['jumlah'],
        'total': element['total'],
      };
      await helper.insert(DetailQueri.tableName, inserData);
    }
    await Cart.emptyCart();
  }

  static updateTransaksi(Map<String, dynamic> data,
      List<Map<String, dynamic>> detail, int id) async {
    DBHelper helper = DBHelper();
    await helper.update(ProdukQueri.tableName, data, id);
    for (var details in detail) {
      await helper.insert(DetailQueri.tableName, details);
    }
  }
}

class DetailTransaksi {
  int id;
  int idTransaksi;
  int idProduk;
  String nama;

  int harga;
  int jumlah;
  int total;
  DetailTransaksi({
    required this.id,
    required this.idTransaksi,
    required this.idProduk,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.total,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      id: json['id'],
      idTransaksi: json['idTransaksi'],
      idProduk: json['idProduk'],
      nama: json['nama'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      total: json['total'],
    );
  }
}

class ListTransaksi {
  int id;
  int tanggal;
  int bulan;
  int tahun;
  String jam;
  String an;
  String meja;
  String kasir;
  int total;
  String status;
  String pembayaran;
  int bayar;
  int kembali;
  List<DetailTransaksi> detailTransaksi;

  ListTransaksi({
    required this.id,
    required this.tanggal,
    required this.bulan,
    required this.tahun,
    required this.jam,
    required this.an,
    required this.meja,
    required this.kasir,
    required this.total,
    required this.status,
    required this.pembayaran,
    required this.bayar,
    required this.kembali,
    required this.detailTransaksi,
  });

  factory ListTransaksi.fromJson(Map<String, dynamic> json, List detail) {
    //var jsonDetail = json['detail'] as List;
    return ListTransaksi(
      id: json['id'],
      tanggal: json['tanggal'],
      bulan: json['bulan'],
      tahun: json['tahun'],
      jam: json['jam'],
      an: json['an'],
      meja: json['meja'] ?? '',
      kasir: json['kasir'] ?? '',
      total: json['total'],
      status: json['status'],
      pembayaran: json['pembayaran'],
      bayar: json['bayar'] ?? 0,
      kembali: json['kembali'] ?? 0,
      detailTransaksi:
          detail.map((item) => DetailTransaksi.fromJson(item)).toList(),
    );
  }
}
