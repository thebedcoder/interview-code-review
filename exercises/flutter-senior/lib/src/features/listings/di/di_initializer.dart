import 'package:get_it/get_it.dart';
import 'package:habitat/src/core/data/network/api_client.dart';
import 'package:habitat/src/core/di/service_locator.dart';
import 'package:habitat/src/features/favourites/domain/repositories/favourites_repository.dart';
import 'package:habitat/src/features/favourites/domain/usecases/toggle_favourite_usecase.dart';
import 'package:habitat/src/features/listings/data/datasources/listings_remote_data_source.dart';
import 'package:habitat/src/features/listings/data/repositories/listings_repository_impl.dart';
import 'package:habitat/src/features/listings/domain/repositories/listings_repository.dart';
import 'package:habitat/src/features/listings/domain/usecases/get_listings_usecase.dart';
import 'package:habitat/src/features/listings/presentation/bloc/listings_bloc.dart';

class ListingsDIInitializer extends DIInitializer {
  const ListingsDIInitializer();

  @override
  Future<void> init(GetIt registrar) async {
    registrar.registerLazySingleton<ListingsRepository>(
      () => ListingsRepositoryImpl(
        ListingsRemoteDataSource(registrar<ApiClient>()),
      ),
    );
    registrar.registerFactory<ListingsBloc>(
      () => ListingsBloc(
        getListingsUseCase: GetListingsUseCase(registrar<ListingsRepository>()),
        toggleFavouriteUseCase: ToggleFavouriteUseCase(
          registrar<FavouritesRepository>(),
        ),
        favouritesRepository: registrar<FavouritesRepository>(),
      ),
    );
  }
}
