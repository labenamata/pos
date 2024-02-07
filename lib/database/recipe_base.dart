class RecipeQueri {
  static const String tableName = 'recipe';
  static const String createTable = 'CREATE TABLE IF NOT EXISTS $tableName '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'idProduk INTEGER,'
      'idBahan INTEGER,'
      'usage REAL)';
  static const String select = 'select * from $tableName';
}
