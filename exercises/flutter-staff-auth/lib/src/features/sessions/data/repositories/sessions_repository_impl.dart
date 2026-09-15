import 'package:kerb/src/features/sessions/data/datasources/sessions_remote_data_source.dart';
import 'package:kerb/src/features/sessions/data/models/parking_session_model.dart';
import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';
import 'package:kerb/src/features/sessions/domain/repositories/sessions_repository.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  const SessionsRepositoryImpl(this._remoteDataSource);

  final SessionsRemoteDataSource _remoteDataSource;

  @override
  Future<ParkingSession?> active() async {
    final ParkingSessionModel? model = await _remoteDataSource.active();
    return model?.toEntity();
  }

  @override
  Future<ParkingSession> start({required String bayCode}) async {
    final ParkingSessionModel model = await _remoteDataSource.start(
      bayCode: bayCode,
    );
    return model.toEntity();
  }

  @override
  Future<ParkingSession> stop({required String sessionId}) async {
    final ParkingSessionModel model = await _remoteDataSource.stop(
      sessionId: sessionId,
    );
    return model.toEntity();
  }
}
