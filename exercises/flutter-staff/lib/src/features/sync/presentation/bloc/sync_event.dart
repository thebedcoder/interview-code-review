part of 'sync_bloc.dart';

sealed class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SyncRequested extends SyncEvent {
  const SyncRequested();
}

class SyncJobCompletionQueued extends SyncEvent {
  const SyncJobCompletionQueued({required this.jobId, required this.notes});

  final String jobId;
  final String notes;

  @override
  List<Object?> get props => <Object?>[jobId, notes];
}
