// ignore_for_file: prefer_adjacent_string_concatenation

class RecipeQueri {
  static const String tableName = "recipe";
  // ignore: prefer_interpolation_to_compose_strings
  static const String createTable = "CREATE TABLE IF NOT EXISTS $tableName " +
      "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "idProduk INTEGER," +
      "idBahan INTEGER," +
      "usage REAL)";
  static const String select = "select * from $tableName";
}
