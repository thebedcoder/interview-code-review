import 'dart:convert';

import 'package:fieldops/src/features/sync/domain/entities/sync_operation.dart';

class SyncOperationModel {
  const SyncOperationModel({
    required this.id,
    required this.kind,
    required this.jobId,
    required this.payloadJson,
    required this.attempts,
    required this.status,
    required this.createdAt,
  });

  factory SyncOperationModel.fromRow(Map<String, Object?> row) {
    return SyncOperationModel(
      id: row['id']! as int,
      kind: row['kind']! as String,
      jobId: row['job_id']! as String,
      payloadJson: row['payload']! as String,
      attempts: row['attempts']! as int,
      status: row['status']! as String,
      createdAt: row['created_at']! as int,
    );
  }

  final int id;
  final String kind;
  final String jobId;
  final String payloadJson;
  final int attempts;
  final String status;
  final int createdAt;

  Map<String, Object?> get payload =>
      jsonDecode(payloadJson) as Map<String, Object?>;

  Map<String, Object?> toRow() {
    return <String, Object?>{
      'kind': kind,
      'job_id': jobId,
      'payload': payloadJson,
      'attempts': attempts,
      'status': status,
      'created_at': createdAt,
    };
  }

  SyncOperation toEntity() {
    return SyncOperation(
      id: id,
      kind: SyncOperationKind.completeJob,
      jobId: jobId,
      payload: payload,
      attempts: attempts,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }
}
