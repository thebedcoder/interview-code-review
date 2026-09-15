import 'package:fieldops/src/features/jobs/data/datasources/jobs_local_data_source.dart';
import 'package:fieldops/src/features/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:fieldops/src/features/jobs/data/models/job_model.dart';
import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:fieldops/src/features/jobs/domain/repositories/jobs_repository.dart';
import 'package:fieldops/src/features/sync/domain/repositories/sync_repository.dart';

class JobsRepositoryImpl implements JobsRepository {
  const JobsRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
    required this._syncRepository,
  });

  final JobsRemoteDataSource _remoteDataSource;
  final JobsLocalDataSource _localDataSource;
  final SyncRepository _syncRepository;

  @override
  Future<List<Job>> loadJobs({required bool forceRefresh}) async {
    if (!forceRefresh) {
      final List<JobModel> cached = await _localDataSource.readAll();
      if (cached.isNotEmpty) {
        return cached.map((JobModel e) => e.toEntity()).toList();
      }
    }

    final List<JobModel> remote = await _remoteDataSource.fetchJobs();
    // The server is the source of truth for job assignment, so the snapshot
    // replaces whatever is in the cache.
    await _localDataSource.upsertAll(remote);
    return remote.map((JobModel e) => e.toEntity()).toList();
  }

  @override
  Future<Job> completeJob({
    required String jobId,
    required String notes,
  }) async {
    final List<JobModel> cached = await _localDataSource.readAll();
    final JobModel current = cached.firstWhere((JobModel e) => e.id == jobId);
    final JobModel completed = current.completedWith(notes);
    await _localDataSource.upsert(completed);
    await _syncRepository.enqueueJobCompletion(jobId: jobId, notes: notes);
    return completed.toEntity();
  }
}
