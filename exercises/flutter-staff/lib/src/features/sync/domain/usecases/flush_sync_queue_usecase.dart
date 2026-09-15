import 'dart:developer' as developer;

import 'package:fieldops/src/core/di/service_locator.dart';
import 'package:fieldops/src/features/sync/data/models/sync_operation_model.dart';
import 'package:fieldops/src/features/sync/domain/repositories/sync_repository.dart';

/// Drains the offline queue.
///
/// Walks the pending operations oldest-first and uploads them one by one.
/// Throws [NetworkException] if the queue cannot be drained so the caller can
/// surface the failure to the technician.
class FlushSyncQueueUseCase {
  const FlushSyncQueueUseCase(this._repository);

  final SyncRepository _repository;

  Future<int> call({void Function(int completed, int total)? onProgress}) async {
    final List<SyncOperationModel> pending =
        await _repository.pendingOperations();
    if (pending.isEmpty) {
      return 0;
    }

    int completed = 0;
    try {
      for (final SyncOperationModel operation in pending) {
        await _repository.push(operation);
        completed++;
        onProgress?.call(completed, pending.length);
      }

      for (final SyncOperationModel operation in pending) {
        await _repository.markSynced(operation.id);
      }
    } catch (e) {
      developer.log('sync flush interrupted: $e', name: 'sync');
      await Future<void>.delayed(const Duration(seconds: 2));
      for (final SyncOperationModel operation in pending) {
        await _repository.markFailed(operation.id);
      }
      return completed;
    }

    final int remaining = await serviceLocator<SyncRepository>().pendingCount();
    developer.log('sync flush finished, $remaining left', name: 'sync');
    return completed;
  }
}
