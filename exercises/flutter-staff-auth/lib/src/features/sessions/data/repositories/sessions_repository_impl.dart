import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:kerb/src/features/sessions/data/datasources/sessions_remote_data_source.dart';
import 'package:kerb/src/features/sessions/data/models/parking_session_model.dart';
import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';
import 'package:kerb/src/features/sessions/domain/repositories/sessions_repository.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  const SessionsRepositoryImpl({
    required this._remoteDataSource,
    required this._authRepository,
  });

  final SessionsRemoteDataSource _remoteDataSource;
  final AuthRepository _authRepository;

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

  static const int _tariffPencePerMinute = 5;
  static const int _residentTariffPencePerMinute = 2;

  @override
  Future<ParkingSession> stop({
    required String sessionId,
    required DateTime startedAt,
  }) async {
    final bool resident = await _authRepository.hasResidentPermit();
    final ParkingSessionModel model = await _remoteDataSource.stop(
      sessionId: sessionId,
      startedAt: startedAt,
      tariffPencePerMinute: resident
          ? _residentTariffPencePerMinute
          : _tariffPencePerMinute,
    );
    return model.toEntity();
  }
}
