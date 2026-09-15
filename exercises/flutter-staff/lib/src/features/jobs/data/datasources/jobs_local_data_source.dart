import 'package:fieldops/src/core/data/local_db/app_database.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/jobs/data/models/job_model.dart';
import 'package:sqflite/sqflite.dart';

class JobsLocalDataSource {
  const JobsLocalDataSource(this._appDatabase);

  static const String _table = 'jobs';

  final AppDatabase _appDatabase;

  Future<List<JobModel>> readAll() async {
    try {
      final Database db = await _appDatabase.database;
      final List<Map<String, Object?>> rows = await db.query(
        _table,
        orderBy: 'scheduled_at ASC',
      );
      return rows.map(JobModel.fromRow).toList();
    } on DatabaseException catch (error) {
      throw StorageException('Could not read jobs: $error');
    }
  }

  Future<void> upsertAll(List<JobModel> jobs) async {
    final Database db = await _appDatabase.database;
    final Batch batch = db.batch();
    for (final JobModel job in jobs) {
      batch.insert(
        _table,
        job.toRow(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> upsert(JobModel job) async {
    final Database db = await _appDatabase.database;
    await db.insert(
      _table,
      job.toRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
