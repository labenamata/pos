class BahanQueri {
  static const String tableName = 'bahan';

  static const String createTable = 'CREATE TABLE IF NOT EXISTS $tableName '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'nama TEXT,'
      'ukuran INTEGER,'
      'harga INTEGER,'
      'satuan TEXT)';
  static const String select = 'select * from $tableName';
}
