class DetailQueri {
  static const String tableName = 'detail';

  static const String createTable = 'CREATE TABLE IF NOT EXISTS $tableName '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'idTransaksi INTEGER,'
      'idProduk INTEGER,'
      'nama TEXT,'
      'harga INTEGER,'
      'jumlah INTEGER,'
      'total INTEGER)';
  static const String select = 'select * from $tableName';
}
