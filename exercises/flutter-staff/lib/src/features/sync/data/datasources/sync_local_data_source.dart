import 'package:fieldops/src/core/data/local_db/app_database.dart';
import 'package:fieldops/src/features/sync/data/models/sync_operation_model.dart';
import 'package:sqflite/sqflite.dart';

/// Reads and writes the offline operation queue.
class SyncQueueStore {
  const SyncQueueStore(this._appDatabase);

  static const String _table = 'sync_operations';
  static const String _orderColumn = 'created_at';

  final AppDatabase _appDatabase;

  Future<void> insert(SyncOperationModel operation) async {
    final Database db = await _appDatabase.database;
    await db.insert(_table, operation.toRow());
  }

  Future<List<SyncOperationModel>> readByStatus(String status) async {
    final Database db = await _appDatabase.database;
    final List<Map<String, Object?>> rows = await db.rawQuery(
      'SELECT * FROM $_table WHERE status = ? ORDER BY $_orderColumn ASC',
      <Object?>[status],
    );
    return rows.map(SyncOperationModel.fromRow).toList();
  }

  Future<int> countByStatus(String status) async {
    final Database db = await _appDatabase.database;
    final List<Map<String, Object?>> rows = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM $_table WHERE status = ?',
      <Object?>[status],
    );
    return rows.first['total']! as int;
  }

  Future<void> updateStatus(int id, String status) async {
    final Database db = await _appDatabase.database;
    await db.update(
      _table,
      <String, Object?>{'status': status},
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  Future<void> bumpAttempts(int id) async {
    final Database db = await _appDatabase.database;
    await db.rawUpdate(
      'UPDATE $_table SET attempts = attempts + 1, status = ? WHERE id = ?',
      <Object?>['pending', id],
    );
  }

  Future<T> runInTransaction<T>(Future<T> Function(Transaction txn) body) async {
    final Database db = await _appDatabase.database;
    return db.transaction<T>(body);
  }
}
