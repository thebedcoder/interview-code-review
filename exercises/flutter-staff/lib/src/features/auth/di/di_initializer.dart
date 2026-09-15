import 'package:fieldops/src/core/data/network/api_client.dart';
import 'package:fieldops/src/core/di/service_locator.dart';
import 'package:fieldops/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fieldops/src/features/auth/data/datasources/token_local_data_source.dart';
import 'package:fieldops/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fieldops/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:fieldops/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:fieldops/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class AuthDIInitializer extends DIInitializer {
  const AuthDIInitializer();

  @override
  Future<void> init(GetIt registrar) async {
    registrar.registerLazySingleton<TokenLocalDataSource>(
      () => const TokenLocalDataSource(FlutterSecureStorage()),
    );
    registrar.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSource(registrar<ApiClient>()),
        localDataSource: registrar<TokenLocalDataSource>(),
      ),
    );
    registrar.registerFactory<AuthBloc>(
      () => AuthBloc(signInUseCase: SignInUseCase(registrar<AuthRepository>())),
    );
  }
}
