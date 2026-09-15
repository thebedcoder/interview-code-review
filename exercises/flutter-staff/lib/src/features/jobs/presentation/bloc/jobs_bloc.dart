import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:fieldops/src/features/jobs/domain/usecases/complete_job_usecase.dart';
import 'package:fieldops/src/features/jobs/domain/usecases/get_jobs_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  JobsBloc({
    required this._getJobsUseCase,
    required this._completeJobUseCase,
  }) : super(const JobsInitial()) {
    on<JobsRequested>(_onRequested, transformer: restartable());
    on<JobCompleted>(_onJobCompleted, transformer: sequential());
  }

  final GetJobsUseCase _getJobsUseCase;
  final CompleteJobUseCase _completeJobUseCase;

  Future<void> _onRequested(JobsRequested event, Emitter<JobsState> emit) async {
    emit(const JobsLoading());
    try {
      final List<Job> jobs = await _getJobsUseCase.call(
        forceRefresh: event.forceRefresh,
      );
      emit(JobsLoaded(jobs: jobs));
    } on AppException catch (error) {
      emit(JobsFailure(error: error));
    }
  }

  Future<void> _onJobCompleted(
    JobCompleted event,
    Emitter<JobsState> emit,
  ) async {
    final JobsState current = state;
    if (current is! JobsLoaded) {
      return;
    }
    try {
      final Job updated = await _completeJobUseCase.call(
        jobId: event.jobId,
        notes: event.notes,
      );
      final List<Job> jobs = current.jobs
          .map((Job job) => job.id == updated.id ? updated : job)
          .toList();
      emit(JobsLoaded(jobs: jobs));
    } on AppException catch (error) {
      emit(JobsFailure(error: error));
    }
  }
}
