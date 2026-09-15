/// Base type for every error that crosses into the domain layer.
///
/// Data sources catch transport- and storage-specific errors and map them to
/// one of these before they reach a use case.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

class StorageException extends AppException {
  const StorageException(super.message);
}

class UnexpectedException extends AppException {
  const UnexpectedException(super.message);
}
