import 'package:habitat/src/core/data/network/api_client.dart';
import 'package:habitat/src/core/di/service_locator.dart';
import 'package:habitat/src/features/favourites/di/di_initializer.dart';
import 'package:habitat/src/features/listings/di/di_initializer.dart';

const String _baseUrl = 'https://api.habitat.dev/v2';

Future<void> initializeServiceLocator() async {
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: _baseUrl),
  );

  const List<DIInitializer> initializers = <DIInitializer>[
    FavouritesDIInitializer(),
    ListingsDIInitializer(),
  ];
  for (final DIInitializer initializer in initializers) {
    await initializer.init(serviceLocator);
  }
}
