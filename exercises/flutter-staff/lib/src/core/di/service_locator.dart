import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

/// Contract for per-feature dependency registration.
///
/// Implementations live in `features/<feature>/di/di_initializer.dart` and are
/// wired together by the core initializer. Domain code never touches the
/// locator - it receives its collaborators through the constructor.
abstract class DIInitializer {
  const DIInitializer();

  Future<void> init(GetIt registrar);
}
