// ignore_for_file: prefer_adjacent_string_concatenation

class CartQueri {
  static const String tableName = "cart";
  // ignore: prefer_interpolation_to_compose_strings
  static const String createTable = "CREATE TABLE IF NOT EXISTS $tableName " +
      "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "idProduk INTEGER," +
      "nama TEXT," +
      "harga INTEGER," +
      "jumlah INTEGER," +
      "total INTEGER)";
  static const String select =
      "select cart.id , cart.idProduk, cart.nama, cart.harga, produk.image,cart.jumlah, cart.total from $tableName inner join produk on $tableName.idProduk = produk.id";
  static const String selectSum = "select sum(total) as total from $tableName";
}
