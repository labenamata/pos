// ignore_for_file: prefer_adjacent_string_concatenation

class UserQueri {
  static const String tableName = "user";
  // ignore: prefer_interpolation_to_compose_strings
  static const String createTable = "CREATE TABLE IF NOT EXISTS $tableName " +
      "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
      "nama TEXT," +
      "username TEXT," +
      "password TEXT," +
      "status TEXT)";
}
