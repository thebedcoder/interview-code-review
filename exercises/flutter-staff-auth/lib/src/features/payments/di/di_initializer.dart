import 'package:get_it/get_it.dart';
import 'package:kerb/src/core/data/local_db/app_database.dart';
import 'package:kerb/src/core/data/network/api_client.dart';
import 'package:kerb/src/core/di/service_locator.dart';
import 'package:kerb/src/features/payments/data/datasources/cards_local_data_source.dart';
import 'package:kerb/src/features/payments/data/datasources/cards_remote_data_source.dart';
import 'package:kerb/src/features/payments/data/repositories/cards_repository_impl.dart';
import 'package:kerb/src/features/payments/domain/repositories/cards_repository.dart';
import 'package:kerb/src/features/payments/domain/usecases/get_cards_usecase.dart';

class PaymentsDIInitializer extends DIInitializer {
  const PaymentsDIInitializer();

  @override
  Future<void> init(GetIt registrar) async {
    registrar.registerLazySingleton<AppDatabase>(AppDatabase.new);
    registrar.registerLazySingleton<CardsRepository>(
      () => CardsRepositoryImpl(
        remoteDataSource: CardsRemoteDataSource(registrar<ApiClient>()),
        localDataSource: CardsLocalDataSource(registrar<AppDatabase>()),
      ),
    );
    registrar.registerLazySingleton<GetCardsUseCase>(
      () => GetCardsUseCase(registrar<CardsRepository>()),
    );
  }
}
