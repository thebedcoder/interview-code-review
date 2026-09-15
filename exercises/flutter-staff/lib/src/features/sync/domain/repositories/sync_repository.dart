import 'package:fieldops/src/features/sync/data/models/sync_operation_model.dart';

abstract class SyncRepository {
  Future<void> enqueueJobCompletion({
    required String jobId,
    required String notes,
  });

  /// Returns everything still waiting to go out, oldest first.
  Future<List<SyncOperationModel>> pendingOperations();

  Future<int> pendingCount();

  Future<void> push(SyncOperationModel operation);

  Future<void> markSynced(int operationId);

  Future<void> markFailed(int operationId);
}
