import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

abstract class DIInitializer {
  const DIInitializer();

  Future<void> init(GetIt registrar);
}
