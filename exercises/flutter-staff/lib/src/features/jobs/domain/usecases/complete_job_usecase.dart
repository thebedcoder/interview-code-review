import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:fieldops/src/features/jobs/domain/repositories/jobs_repository.dart';

class CompleteJobUseCase {
  const CompleteJobUseCase(this._repository);

  final JobsRepository _repository;

  Future<Job> call({required String jobId, required String notes}) {
    return _repository.completeJob(jobId: jobId, notes: notes);
  }
}
