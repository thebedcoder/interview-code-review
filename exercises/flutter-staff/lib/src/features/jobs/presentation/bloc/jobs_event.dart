part of 'jobs_bloc.dart';

sealed class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class JobsRequested extends JobsEvent {
  const JobsRequested({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object?> get props => <Object?>[forceRefresh];
}

class JobCompleted extends JobsEvent {
  const JobCompleted({required this.jobId, required this.notes});

  final String jobId;
  final String notes;

  @override
  List<Object?> get props => <Object?>[jobId, notes];
}
