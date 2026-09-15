import 'package:get_it/get_it.dart';
import 'package:kerb/src/core/data/network/api_client.dart';
import 'package:kerb/src/core/di/service_locator.dart';
import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:kerb/src/features/sessions/data/datasources/sessions_remote_data_source.dart';
import 'package:kerb/src/features/sessions/data/repositories/sessions_repository_impl.dart';
import 'package:kerb/src/features/sessions/domain/repositories/sessions_repository.dart';
import 'package:kerb/src/features/sessions/domain/usecases/get_active_parking_usecase.dart';
import 'package:kerb/src/features/sessions/domain/usecases/start_parking_usecase.dart';
import 'package:kerb/src/features/sessions/domain/usecases/stop_parking_usecase.dart';
import 'package:kerb/src/features/sessions/presentation/bloc/parking_bloc.dart';

class SessionsDIInitializer extends DIInitializer {
  const SessionsDIInitializer();

  @override
  Future<void> init(GetIt registrar) async {
    registrar.registerLazySingleton<SessionsRepository>(
      () => SessionsRepositoryImpl(
        remoteDataSource: SessionsRemoteDataSource(registrar<ApiClient>()),
        authRepository: registrar<AuthRepository>(),
      ),
    );
    registrar.registerFactory<ParkingBloc>(
      () => ParkingBloc(
        getActiveParkingUseCase: GetActiveParkingUseCase(
          registrar<SessionsRepository>(),
        ),
        startParkingUseCase: StartParkingUseCase(
          registrar<SessionsRepository>(),
        ),
        stopParkingUseCase: StopParkingUseCase(registrar<SessionsRepository>()),
      ),
    );
  }
}
