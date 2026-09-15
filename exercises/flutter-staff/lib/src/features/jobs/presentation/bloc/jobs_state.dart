part of 'jobs_bloc.dart';

sealed class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object?> get props => <Object?>[];
}

class JobsInitial extends JobsState {
  const JobsInitial();
}

class JobsLoading extends JobsState {
  const JobsLoading();
}

class JobsLoaded extends JobsState {
  const JobsLoaded({required this.jobs});

  final List<Job> jobs;

  @override
  List<Object?> get props => <Object?>[jobs];
}

class JobsFailure extends JobsState {
  const JobsFailure({required this.error});

  final AppException error;

  @override
  List<Object?> get props => <Object?>[error];
}
