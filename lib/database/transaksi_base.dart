// ignore_for_file: prefer_adjacent_string_concatenation

class TransaksiQueri {
  static const String tableName = "transaksi";
  // ignore: prefer_interpolation_to_compose_strings
  static const String createTable = "CREATE TABLE IF NOT EXISTS $tableName " +
      "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "tanggal INTEGER," +
      "bulan INTEGER," +
      "tahun INTEGER," +
      "jam TEXT," +
      "an TEXT," +
      "total INTEGER," +
      "status TEXT," +
      "pembayaran TEXT," +
      "bayar INTEGER," +
      "kembali INTEGER)";
  static const String select = "select * from $tableName";
}
