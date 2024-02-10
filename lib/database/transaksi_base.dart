class TransaksiQueri {
  static const String tableName = 'transaksi';
  static const String createTable = 'CREATE TABLE IF NOT EXISTS $tableName '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'tanggal INTEGER,'
      'bulan INTEGER,'
      'tahun INTEGER,'
      'jam TEXT,'
      'an TEXT,'
      'total INTEGER,'
      'meja TEXT,'
      'kasir TEXT,'
      'status TEXT,'
      'pembayaran TEXT,'
      'bayar INTEGER,'
      'kembali INTEGER)';
  static const String select = 'select * from $tableName';
}
