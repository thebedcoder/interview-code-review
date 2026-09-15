import 'package:get_it/get_it.dart';
import 'package:kerb/src/core/data/network/api_client.dart';
import 'package:kerb/src/core/di/service_locator.dart';
import 'package:kerb/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:kerb/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kerb/src/features/auth/data/datasources/pkce_factory.dart';
import 'package:kerb/src/features/auth/data/datasources/token_claims_reader.dart';
import 'package:kerb/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:kerb/src/features/auth/domain/usecases/begin_sign_in_usecase.dart';
import 'package:kerb/src/features/auth/domain/usecases/complete_sign_in_usecase.dart';
import 'package:kerb/src/features/auth/presentation/bloc/auth_bloc.dart';

class AuthDIInitializer extends DIInitializer {
  const AuthDIInitializer();

  @override
  Future<void> init(GetIt registrar) async {
    registrar.registerLazySingleton<AuthLocalDataSource>(
      AuthLocalDataSource.new,
    );
    registrar.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSource(registrar<ApiClient>()),
        localDataSource: registrar<AuthLocalDataSource>(),
        pkceFactory: const PkceFactory(),
        claimsReader: const TokenClaimsReader(),
      ),
    );
    registrar.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        beginSignInUseCase: BeginSignInUseCase(registrar<AuthRepository>()),
        completeSignInUseCase: CompleteSignInUseCase(
          registrar<AuthRepository>(),
        ),
        authRepository: registrar<AuthRepository>(),
      ),
    );
  }
}
