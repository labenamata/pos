// ignore_for_file: prefer_adjacent_string_concatenation

class KategoriQueri {
  static const String tableName = "kategori";
  // ignore: prefer_interpolation_to_compose_strings
  static const String createTable = "CREATE TABLE IF NOT EXISTS $tableName " +
      "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "nama TEXT)";
  static const String select = "select * from $tableName";
}
