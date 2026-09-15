import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';

class ParkingSessionModel {
  const ParkingSessionModel({
    required this.id,
    required this.bayCode,
    required this.startedAtMillis,
    required this.endedAtMillis,
    required this.chargedPence,
  });

  factory ParkingSessionModel.fromJson(Map<String, dynamic> json) {
    return ParkingSessionModel(
      id: json['id'] as String,
      bayCode: json['bay_code'] as String,
      startedAtMillis: json['started_at'] as int,
      endedAtMillis: json['ended_at'] as int?,
      chargedPence: json['charged_pence'] as int?,
    );
  }

  final String id;
  final String bayCode;
  final int startedAtMillis;
  final int? endedAtMillis;
  final int? chargedPence;

  ParkingSession toEntity() {
    return ParkingSession(
      id: id,
      bayCode: bayCode,
      startedAt: DateTime.fromMillisecondsSinceEpoch(startedAtMillis),
      endedAt: endedAtMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(endedAtMillis!),
      chargedPence: chargedPence,
    );
  }
}
