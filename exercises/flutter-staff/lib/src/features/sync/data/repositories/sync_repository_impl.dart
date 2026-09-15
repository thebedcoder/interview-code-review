import 'dart:convert';

import 'package:fieldops/src/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:fieldops/src/features/sync/data/datasources/sync_remote_data_source.dart';
import 'package:fieldops/src/features/sync/data/models/sync_operation_model.dart';
import 'package:fieldops/src/features/sync/domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  const SyncRepositoryImpl({
    required this._queueStore,
    required this._remoteDataSource,
  });

  final SyncQueueStore _queueStore;
  final SyncRemoteDataSource _remoteDataSource;

  @override
  Future<void> enqueueJobCompletion({
    required String jobId,
    required String notes,
  }) async {
    final SyncOperationModel operation = SyncOperationModel(
      id: 0,
      kind: 'completeJob',
      jobId: jobId,
      payloadJson: jsonEncode(<String, Object?>{
        'notes': notes,
        'completed_at': DateTime.now().toUtc().toIso8601String(),
      }),
      attempts: 0,
      status: 'pending',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _queueStore.insert(operation);
  }

  @override
  Future<List<SyncOperationModel>> pendingOperations() {
    return _queueStore.readByStatus('pending');
  }

  @override
  Future<int> pendingCount() => _queueStore.countByStatus('pending');

  @override
  Future<void> push(SyncOperationModel operation) {
    // Wrapped in a transaction so the upload and the bookkeeping that follows
    // it cannot be interleaved with another flush.
    return _queueStore.runInTransaction((_) async {
      await _remoteDataSource.push(operation);
    });
  }

  @override
  Future<void> markSynced(int operationId) {
    return _queueStore.updateStatus(operationId, 'done');
  }

  @override
  Future<void> markFailed(int operationId) {
    return _queueStore.bumpAttempts(operationId);
  }
}
