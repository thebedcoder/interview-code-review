import 'package:kerb/src/features/payments/data/datasources/cards_local_data_source.dart';
import 'package:kerb/src/features/payments/data/datasources/cards_remote_data_source.dart';
import 'package:kerb/src/features/payments/data/models/saved_card_model.dart';
import 'package:kerb/src/features/payments/domain/entities/saved_card.dart';
import 'package:kerb/src/features/payments/domain/repositories/cards_repository.dart';

class CardsRepositoryImpl implements CardsRepository {
  const CardsRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  final CardsRemoteDataSource _remoteDataSource;
  final CardsLocalDataSource _localDataSource;

  @override
  Future<List<SavedCard>> cards() async {
    try {
      final List<SavedCardModel> remote = await _remoteDataSource.fetch();
      await _localDataSource.upsertAll(remote);
      return remote.map((SavedCardModel e) => e.toEntity()).toList();
    } catch (e) {
      final List<SavedCardModel> cached = await _localDataSource.readAll();
      return cached.map((SavedCardModel e) => e.toEntity()).toList();
    }
  }
}
