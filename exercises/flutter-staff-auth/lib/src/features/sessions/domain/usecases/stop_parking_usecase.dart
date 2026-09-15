import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';
import 'package:kerb/src/features/sessions/domain/repositories/sessions_repository.dart';

class StopParkingUseCase {
  const StopParkingUseCase(this._repository);

  final SessionsRepository _repository;

  Future<ParkingSession> call({
    required String sessionId,
    required DateTime startedAt,
  }) => _repository.stop(sessionId: sessionId, startedAt: startedAt);
}
