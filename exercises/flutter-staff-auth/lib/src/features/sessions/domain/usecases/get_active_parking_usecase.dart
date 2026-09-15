import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';
import 'package:kerb/src/features/sessions/domain/repositories/sessions_repository.dart';

class GetActiveParkingUseCase {
  const GetActiveParkingUseCase(this._repository);

  final SessionsRepository _repository;

  Future<ParkingSession?> call() => _repository.active();
}
