import 'package:habitat/src/features/favourites/data/datasources/favourites_local_data_source.dart';
import 'package:habitat/src/features/favourites/domain/repositories/favourites_repository.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  const FavouritesRepositoryImpl(this._localDataSource);

  final FavouritesLocalDataSource _localDataSource;

  @override
  Future<Set<String>> read() => _localDataSource.read();

  @override
  Future<void> toggle(String listingId) async {
    final Set<String> current = await _localDataSource.read();
    if (!current.add(listingId)) {
      current.remove(listingId);
    }
    await _localDataSource.write(current);
  }
}
