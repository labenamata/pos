// ignore_for_file: prefer_adjacent_string_concatenation

class BahanQueri {
  static const String tableName = "bahan";
  // ignore: prefer_interpolation_to_compose_strings
  static const String createTable = "CREATE TABLE IF NOT EXISTS $tableName " +
      "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "nama TEXT," +
      "satuan TEXT)";
  static const String select = "select * from $tableName";
}
