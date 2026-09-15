sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ParsingException extends AppException {
  const ParsingException(super.message);
}

class StorageException extends AppException {
  const StorageException(super.message);
}
