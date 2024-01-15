// ignore_for_file: prefer_adjacent_string_concatenation

class DetailQueri {
  static const String tableName = "detail";
  // ignore: prefer_interpolation_to_compose_strings
  static const String createTable = "CREATE TABLE IF NOT EXISTS $tableName " +
      "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "idTransaksi INTEGER," +
      "idProduk INTEGER," +
      "nama TEXT," +
      "harga INTEGER," +
      "jumlah INTEGER," +
      "total INTEGER)";
  static const String select = "select * from $tableName";
}
