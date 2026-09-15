import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';
import 'package:kerb/src/features/sessions/domain/repositories/sessions_repository.dart';

class StartParkingUseCase {
  const StartParkingUseCase(this._repository);

  final SessionsRepository _repository;

  Future<ParkingSession> call({required String bayCode}) =>
      _repository.start(bayCode: bayCode);
}
