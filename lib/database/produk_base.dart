class ProdukQueri {
  static const String tableName = "produk";
  // ignore: prefer_interpolation_to_compose_strings
  static const String createTable = "CREATE TABLE IF NOT EXISTS $tableName "
      "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "idKategori INTEGER,"
      "nama TEXT,"
      "hargaPokok INTEGER,"
      "hargaJual INTEGER,"
      "stok INTEGER,"
      "image BLOB)";
  static const String select = "select * from $tableName";
}
