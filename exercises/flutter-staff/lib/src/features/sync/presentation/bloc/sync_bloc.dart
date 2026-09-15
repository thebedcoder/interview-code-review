import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fieldops/src/features/sync/domain/repositories/sync_repository.dart';
import 'package:fieldops/src/features/sync/domain/usecases/enqueue_job_completion_usecase.dart';
import 'package:fieldops/src/features/sync/domain/usecases/flush_sync_queue_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  SyncBloc({
    required this._flushSyncQueueUseCase,
    required this._enqueueJobCompletionUseCase,
    required this._syncRepository,
  }) : super(const SyncIdle(pendingCount: 0)) {
    on<SyncRequested>(_onSyncRequested);
    on<SyncJobCompletionQueued>(_onJobCompletionQueued);
  }

  final FlushSyncQueueUseCase _flushSyncQueueUseCase;
  final EnqueueJobCompletionUseCase _enqueueJobCompletionUseCase;
  final SyncRepository _syncRepository;

  Future<void> _onSyncRequested(
    SyncRequested event,
    Emitter<SyncState> emit,
  ) async {
    final int total = await _syncRepository.pendingCount();
    if (total == 0) {
      emit(const SyncIdle(pendingCount: 0));
      return;
    }

    emit(SyncInProgress(total: total, completed: 0));
    await _flushSyncQueueUseCase.call(
      onProgress: (int completed, int batchTotal) {
        emit(SyncInProgress(total: batchTotal, completed: completed));
      },
    );
    emit(SyncIdle(pendingCount: await _syncRepository.pendingCount()));
  }

  Future<void> _onJobCompletionQueued(
    SyncJobCompletionQueued event,
    Emitter<SyncState> emit,
  ) async {
    await _enqueueJobCompletionUseCase.call(
      jobId: event.jobId,
      notes: event.notes,
    );
    emit(SyncIdle(pendingCount: await _syncRepository.pendingCount()));
    add(const SyncRequested());
  }
}
