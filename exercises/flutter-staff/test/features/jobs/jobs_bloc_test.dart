import 'package:bloc_test/bloc_test.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:fieldops/src/features/jobs/domain/repositories/jobs_repository.dart';
import 'package:fieldops/src/features/jobs/domain/usecases/complete_job_usecase.dart';
import 'package:fieldops/src/features/jobs/domain/usecases/get_jobs_usecase.dart';
import 'package:fieldops/src/features/jobs/presentation/bloc/jobs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockJobsRepository extends Mock implements JobsRepository {}

Job _job({String id = 'job-1', JobStatus status = JobStatus.scheduled}) {
  return Job(
    id: id,
    title: 'Replace boiler valve',
    customerName: 'Acme Ltd',
    address: '12 Bridge Street',
    status: status,
    notes: '',
    scheduledAt: DateTime.utc(2026, 9, 15, 9),
    updatedAt: DateTime.utc(2026, 9, 15, 8),
  );
}

void main() {
  late _MockJobsRepository repository;

  setUp(() {
    repository = _MockJobsRepository();
  });

  JobsBloc buildBloc() {
    return JobsBloc(
      getJobsUseCase: GetJobsUseCase(repository),
      completeJobUseCase: CompleteJobUseCase(repository),
    );
  }

  group('JobsRequested', () {
    blocTest<JobsBloc, JobsState>(
      'emits loading then loaded when the repository returns jobs',
      setUp: () {
        when(
          () => repository.loadJobs(forceRefresh: any(named: 'forceRefresh')),
        ).thenAnswer((_) async => <Job>[_job()]);
      },
      build: buildBloc,
      act: (JobsBloc bloc) => bloc.add(const JobsRequested()),
      expect: () => <JobsState>[
        const JobsLoading(),
        JobsLoaded(jobs: <Job>[_job()]),
      ],
    );

    blocTest<JobsBloc, JobsState>(
      'emits failure when the repository throws',
      setUp: () {
        when(
          () => repository.loadJobs(forceRefresh: any(named: 'forceRefresh')),
        ).thenThrow(const NetworkException('offline'));
      },
      build: buildBloc,
      act: (JobsBloc bloc) => bloc.add(const JobsRequested()),
      expect: () => <JobsState>[
        const JobsLoading(),
        const JobsFailure(error: NetworkException('offline')),
      ],
    );
  });

  group('JobCompleted', () {
    blocTest<JobsBloc, JobsState>(
      'replaces the completed job in the loaded list',
      setUp: () {
        when(
          () => repository.loadJobs(forceRefresh: any(named: 'forceRefresh')),
        ).thenAnswer((_) async => <Job>[_job()]);
        when(
          () => repository.completeJob(
            jobId: any(named: 'jobId'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async => _job(status: JobStatus.completed));
      },
      build: buildBloc,
      act: (JobsBloc bloc) async {
        bloc.add(const JobsRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const JobCompleted(jobId: 'job-1', notes: 'Valve swapped'));
      },
      skip: 2,
      expect: () => <JobsState>[
        JobsLoaded(jobs: <Job>[_job(status: JobStatus.completed)]),
      ],
    );
  });
}
