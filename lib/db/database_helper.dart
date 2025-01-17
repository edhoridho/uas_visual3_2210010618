import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'perawatan_hewan.db');
    return openDatabase(path, onCreate: (db, version) {
      return Future.wait([
        db.execute(
          '''CREATE TABLE Hewan (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nama_hewan TEXT,
              jenis_hewan TEXT,
              usia TEXT,
              nama_pemilik TEXT,
              kontak_pemilik TEXT
            )''',
        ),
        db.execute(
          '''CREATE TABLE Perawatan (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              id_hewan INTEGER,
              jenis_perawatan TEXT,
              tanggal_perawatan TEXT,
              biaya INTEGER,
              keterangan TEXT,
              FOREIGN KEY (id_hewan) REFERENCES Hewan(id)
            )''',
        ),
      ]);
    }, version: 1);
  }

  // **CRUD untuk Hewan**

  Future<int> insertHewan(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('Hewan', data);
  }

  Future<List<Map<String, dynamic>>> getHewan() async {
    final db = await database;
    return await db.query('Hewan');
  }

  Future<int> updateHewan(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('Hewan', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteHewan(int id) async {
    final db = await database;
    return await db.delete('Hewan', where: 'id = ?', whereArgs: [id]);
  }

  // **CRUD untuk Perawatan**

  Future<int> insertPerawatan(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('Perawatan', data);
  }

  Future<List<Map<String, dynamic>>> getPerawatanByIdHewan(int idHewan) async {
    final db = await database;
    return await db.query(
      'Perawatan',
      where: 'id_hewan = ?',
      whereArgs: [idHewan],
    );
  }

  // Fungsi untuk mengambil semua data hewan
  Future<List<Map<String, dynamic>>> getAllHewan() async {
    final db = await database;
    return await db.query('hewan'); // Mengambil semua data dari tabel 'hewan'
  }

  Future<int> updatePerawatan(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('Perawatan', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePerawatan(int id) async {
    final db = await database;
    return await db.delete('Perawatan', where: 'id = ?', whereArgs: [id]);
  }
}
