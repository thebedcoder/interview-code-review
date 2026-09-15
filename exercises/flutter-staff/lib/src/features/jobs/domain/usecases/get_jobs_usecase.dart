import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:fieldops/src/features/jobs/domain/repositories/jobs_repository.dart';

class GetJobsUseCase {
  const GetJobsUseCase(this._repository);

  final JobsRepository _repository;

  Future<List<Job>> call({bool forceRefresh = false}) {
    return _repository.loadJobs(forceRefresh: forceRefresh);
  }
}
