import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Local cache so the wallet and recent receipts render instantly on open.
class AppDatabase {
  AppDatabase({this.databaseName = 'kerb.db'});

  static const int schemaVersion = 1;

  final String databaseName;

  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final String path = await getDatabasesPath();
    return openDatabase(
      p.join(path, databaseName),
      version: schemaVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_cards (
        id TEXT PRIMARY KEY,
        brand TEXT NOT NULL,
        last4 TEXT NOT NULL,
        expiry_month INTEGER NOT NULL,
        expiry_year INTEGER NOT NULL,
        network_token TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE receipts (
        id TEXT PRIMARY KEY,
        bay_code TEXT NOT NULL,
        vehicle_plate TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        started_at INTEGER NOT NULL,
        ended_at INTEGER NOT NULL,
        charged_pence INTEGER NOT NULL,
        card_last4 TEXT NOT NULL
      )
    ''');
  }
}
