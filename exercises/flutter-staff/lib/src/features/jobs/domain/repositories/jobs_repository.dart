import 'package:fieldops/src/features/jobs/domain/entities/job.dart';

abstract class JobsRepository {
  Future<List<Job>> loadJobs({required bool forceRefresh});

  Future<Job> completeJob({required String jobId, required String notes});
}
