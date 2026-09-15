import 'package:kerb/src/core/data/local_db/app_database.dart';
import 'package:kerb/src/features/payments/data/models/saved_card_model.dart';
import 'package:sqflite/sqflite.dart';

class CardsLocalDataSource {
  const CardsLocalDataSource(this._appDatabase);

  static const String _table = 'saved_cards';

  final AppDatabase _appDatabase;

  Future<List<SavedCardModel>> readAll() async {
    final Database db = await _appDatabase.database;
    final List<Map<String, Object?>> rows = await db.query(_table);
    return rows.map(SavedCardModel.fromRow).toList();
  }

  Future<void> upsertAll(List<SavedCardModel> cards) async {
    final Database db = await _appDatabase.database;
    final Batch batch = db.batch();
    for (final SavedCardModel card in cards) {
      batch.insert(
        _table,
        card.toRow(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
