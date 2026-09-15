import 'package:fieldops/src/features/sync/domain/repositories/sync_repository.dart';

class EnqueueJobCompletionUseCase {
  const EnqueueJobCompletionUseCase(this._repository);

  final SyncRepository _repository;

  Future<void> call({required String jobId, required String notes}) {
    return _repository.enqueueJobCompletion(jobId: jobId, notes: notes);
  }
}
