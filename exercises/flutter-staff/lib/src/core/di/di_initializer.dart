import 'package:fieldops/src/core/data/local_db/app_database.dart';
import 'package:fieldops/src/core/data/network/api_client.dart';
import 'package:fieldops/src/core/di/service_locator.dart';
import 'package:fieldops/src/features/auth/di/di_initializer.dart';
import 'package:fieldops/src/features/jobs/di/di_initializer.dart';

const String _baseUrl = 'https://api.fieldops.dev/v1';

Future<void> initializeServiceLocator() async {
  serviceLocator.registerLazySingleton<AppDatabase>(AppDatabase.new);
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: _baseUrl),
  );

  const List<DIInitializer> initializers = <DIInitializer>[
    AuthDIInitializer(),
    JobsDIInitializer(),
  ];
  for (final DIInitializer initializer in initializers) {
    await initializer.init(serviceLocator);
  }
}
