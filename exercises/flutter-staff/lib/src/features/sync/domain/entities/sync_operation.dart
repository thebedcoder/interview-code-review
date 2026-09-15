import 'package:equatable/equatable.dart';

enum SyncOperationKind { completeJob }

class SyncOperation extends Equatable {
  const SyncOperation({
    required this.id,
    required this.kind,
    required this.jobId,
    required this.payload,
    required this.attempts,
    required this.createdAt,
  });

  final int id;
  final SyncOperationKind kind;
  final String jobId;
  final Map<String, Object?> payload;
  final int attempts;
  final DateTime createdAt;

  @override
  List<Object?> get props => <Object?>[id, kind, jobId, payload, attempts, createdAt];
}
