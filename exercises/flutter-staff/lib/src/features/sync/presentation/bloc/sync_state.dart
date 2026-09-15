part of 'sync_bloc.dart';

sealed class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => <Object?>[];
}

class SyncIdle extends SyncState {
  const SyncIdle({required this.pendingCount});

  final int pendingCount;

  @override
  List<Object?> get props => <Object?>[pendingCount];
}

class SyncInProgress extends SyncState {
  const SyncInProgress({required this.total, required this.completed});

  final int total;
  final int completed;

  @override
  List<Object?> get props => <Object?>[total];
}
