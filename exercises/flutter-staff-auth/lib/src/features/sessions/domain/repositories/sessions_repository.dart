import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';

abstract class SessionsRepository {
  Future<ParkingSession?> active();

  Future<ParkingSession> start({required String bayCode});

  Future<ParkingSession> stop({
    required String sessionId,
    required DateTime startedAt,
  });
}
