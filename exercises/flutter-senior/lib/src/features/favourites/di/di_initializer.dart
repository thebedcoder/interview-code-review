import 'package:get_it/get_it.dart';
import 'package:habitat/src/core/di/service_locator.dart';
import 'package:habitat/src/features/favourites/data/datasources/favourites_local_data_source.dart';
import 'package:habitat/src/features/favourites/data/repositories/favourites_repository_impl.dart';
import 'package:habitat/src/features/favourites/domain/repositories/favourites_repository.dart';

class FavouritesDIInitializer extends DIInitializer {
  const FavouritesDIInitializer();

  @override
  Future<void> init(GetIt registrar) async {
    registrar.registerLazySingleton<FavouritesRepository>(
      () => const FavouritesRepositoryImpl(FavouritesLocalDataSource()),
    );
  }
}
