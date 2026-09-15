import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Owns the on-device SQLite database and its schema version.
///
/// Every schema change must bump [schemaVersion] and add a migration step to
/// [_onUpgrade]. Technicians work offline for hours at a time, so anything in
/// this file runs against databases holding work that has never been uploaded.
class AppDatabase {
  AppDatabase({this.databaseName = 'fieldops.db'});

  static const int schemaVersion = 1;

  final String databaseName;

  Database? _database;

  Future<Database> get database async {
    return _database ??= await _open();
  }

  Future<Database> _open() async {
    final String databasesPath = await getDatabasesPath();
    return openDatabase(
      p.join(databasesPath, databaseName),
      version: schemaVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jobs (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        address TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT NOT NULL DEFAULT '',
        scheduled_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX jobs_scheduled_at ON jobs (scheduled_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // No migrations yet - v1 is the first shipped schema.
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
