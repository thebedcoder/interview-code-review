import 'package:fieldops/src/features/jobs/data/datasources/jobs_local_data_source.dart';
import 'package:fieldops/src/features/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:fieldops/src/features/jobs/data/models/job_model.dart';
import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:fieldops/src/features/jobs/domain/repositories/jobs_repository.dart';

class JobsRepositoryImpl implements JobsRepository {
  const JobsRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  final JobsRemoteDataSource _remoteDataSource;
  final JobsLocalDataSource _localDataSource;

  @override
  Future<List<Job>> loadJobs({required bool forceRefresh}) async {
    if (!forceRefresh) {
      final List<JobModel> cached = await _localDataSource.readAll();
      if (cached.isNotEmpty) {
        return cached.map((JobModel e) => e.toEntity()).toList();
      }
    }

    final List<JobModel> remote = await _remoteDataSource.fetchJobs();
    await _localDataSource.upsertAll(remote);
    return remote.map((JobModel e) => e.toEntity()).toList();
  }

  @override
  Future<Job> completeJob({
    required String jobId,
    required String notes,
  }) async {
    final JobModel completed = await _remoteDataSource.completeJob(
      jobId: jobId,
      notes: notes,
    );
    await _localDataSource.upsert(completed);
    return completed.toEntity();
  }
}
