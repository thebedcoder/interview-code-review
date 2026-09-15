import 'package:fieldops/src/core/di/service_locator.dart';
import 'package:fieldops/src/features/sync/data/models/sync_operation_model.dart';
import 'package:fieldops/src/features/sync/domain/repositories/sync_repository.dart';
import 'package:fieldops/src/features/sync/domain/usecases/flush_sync_queue_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSyncRepository extends Mock implements SyncRepository {}

SyncOperationModel _operation(int id) {
  return SyncOperationModel(
    id: id,
    kind: 'completeJob',
    jobId: 'job-$id',
    payloadJson: '{"notes":""}',
    attempts: 0,
    status: 'pending',
    createdAt: 1757923200000,
  );
}

void main() {
  late _MockSyncRepository repository;

  setUp(() {
    repository = _MockSyncRepository();
    serviceLocator.registerSingleton<SyncRepository>(repository);
    registerFallbackValue(_operation(1));
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  test('uploads every pending operation and marks it synced', () async {
    when(
      () => repository.pendingOperations(),
    ).thenAnswer((_) async => <SyncOperationModel>[_operation(1), _operation(2)]);
    when(() => repository.push(any())).thenAnswer((_) async {});
    when(() => repository.markSynced(any())).thenAnswer((_) async {});
    when(() => repository.pendingCount()).thenAnswer((_) async => 0);

    final FlushSyncQueueUseCase useCase = FlushSyncQueueUseCase(repository);
    final int completed = await useCase.call();

    expect(completed, 2);
    verify(() => repository.markSynced(1)).called(1);
    verify(() => repository.markSynced(2)).called(1);
  });

  test('reports progress as each operation goes out', () async {
    when(
      () => repository.pendingOperations(),
    ).thenAnswer((_) async => <SyncOperationModel>[_operation(1), _operation(2)]);
    when(() => repository.push(any())).thenAnswer((_) async {});
    when(() => repository.markSynced(any())).thenAnswer((_) async {});
    when(() => repository.pendingCount()).thenAnswer((_) async => 0);

    final List<int> progress = <int>[];
    final FlushSyncQueueUseCase useCase = FlushSyncQueueUseCase(repository);
    await useCase.call(onProgress: (int completed, int _) => progress.add(completed));

    expect(progress, <int>[1, 2]);
  });
}
