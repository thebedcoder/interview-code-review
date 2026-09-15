import 'package:equatable/equatable.dart';

class ParkingSession extends Equatable {
  const ParkingSession({
    required this.id,
    required this.bayCode,
    required this.startedAt,
    required this.endedAt,
    required this.chargedPence,
  });

  final String id;
  final String bayCode;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? chargedPence;

  bool get isActive => endedAt == null;

  @override
  List<Object?> get props => <Object?>[
    id,
    bayCode,
    startedAt,
    endedAt,
    chargedPence,
  ];
}
