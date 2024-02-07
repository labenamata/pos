class UserQueri {
  static const String tableName = 'user';
  static const String createTable = 'CREATE TABLE IF NOT EXISTS $tableName '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'nama TEXT,'
      'username TEXT,'
      'password TEXT,'
      'status TEXT)';
}
