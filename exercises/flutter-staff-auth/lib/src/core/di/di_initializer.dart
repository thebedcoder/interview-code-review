import 'package:kerb/src/core/data/network/api_client.dart';
import 'package:kerb/src/core/data/network/auth_interceptor.dart';
import 'package:kerb/src/core/di/service_locator.dart';
import 'package:kerb/src/features/auth/di/di_initializer.dart';
import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:kerb/src/features/sessions/di/di_initializer.dart';

const String _baseUrl = 'https://api.kerb.dev/v3';

Future<void> initializeServiceLocator() async {
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: _baseUrl),
  );

  const List<DIInitializer> initializers = <DIInitializer>[
    AuthDIInitializer(),
    SessionsDIInitializer(),
  ];
  for (final DIInitializer initializer in initializers) {
    await initializer.init(serviceLocator);
  }

  serviceLocator<ApiClient>().dio.interceptors.add(
    AuthInterceptor(serviceLocator<AuthRepository>()),
  );
}
