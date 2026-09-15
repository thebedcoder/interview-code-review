import 'package:fieldops/src/core/data/local_db/app_database.dart';
import 'package:fieldops/src/core/data/network/api_client.dart';
import 'package:fieldops/src/core/di/service_locator.dart';
import 'package:fieldops/src/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:fieldops/src/features/sync/data/datasources/sync_remote_data_source.dart';
import 'package:fieldops/src/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:fieldops/src/features/sync/domain/repositories/sync_repository.dart';
import 'package:fieldops/src/features/sync/domain/usecases/enqueue_job_completion_usecase.dart';
import 'package:fieldops/src/features/sync/domain/usecases/flush_sync_queue_usecase.dart';
import 'package:fieldops/src/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:get_it/get_it.dart';

class SyncDIInitializer extends DIInitializer {
  const SyncDIInitializer();

  @override
  Future<void> init(GetIt registrar) async {
    registrar.registerLazySingleton<SyncQueueStore>(
      () => SyncQueueStore(registrar<AppDatabase>()),
    );
    registrar.registerLazySingleton<SyncRepository>(
      () => SyncRepositoryImpl(
        queueStore: registrar<SyncQueueStore>(),
        remoteDataSource: SyncRemoteDataSource(registrar<ApiClient>()),
      ),
    );
    registrar.registerLazySingleton<SyncBloc>(
      () => SyncBloc(
        flushSyncQueueUseCase: FlushSyncQueueUseCase(
          registrar<SyncRepository>(),
        ),
        enqueueJobCompletionUseCase: EnqueueJobCompletionUseCase(
          registrar<SyncRepository>(),
        ),
        syncRepository: registrar<SyncRepository>(),
      ),
    );
  }
}
