class KategoriQueri {
  static const String tableName = 'kategori';

  static const String createTable = 'CREATE TABLE IF NOT EXISTS $tableName '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'nama TEXT)';
  static const String select = 'select * from $tableName';
}
