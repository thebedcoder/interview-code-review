import 'package:fieldops/src/core/data/local_db/app_database.dart';
import 'package:fieldops/src/core/data/network/api_client.dart';
import 'package:fieldops/src/core/di/service_locator.dart';
import 'package:fieldops/src/features/jobs/data/datasources/jobs_local_data_source.dart';
import 'package:fieldops/src/features/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:fieldops/src/features/jobs/data/repositories/jobs_repository_impl.dart';
import 'package:fieldops/src/features/jobs/domain/repositories/jobs_repository.dart';
import 'package:fieldops/src/features/jobs/domain/usecases/complete_job_usecase.dart';
import 'package:fieldops/src/features/jobs/domain/usecases/get_jobs_usecase.dart';
import 'package:fieldops/src/features/jobs/presentation/bloc/jobs_bloc.dart';
import 'package:fieldops/src/features/sync/domain/repositories/sync_repository.dart';
import 'package:get_it/get_it.dart';

class JobsDIInitializer extends DIInitializer {
  const JobsDIInitializer();

  @override
  Future<void> init(GetIt registrar) async {
    registrar.registerLazySingleton<JobsRepository>(
      () => JobsRepositoryImpl(
        remoteDataSource: JobsRemoteDataSource(registrar<ApiClient>()),
        localDataSource: JobsLocalDataSource(registrar<AppDatabase>()),
        syncRepository: registrar<SyncRepository>(),
      ),
    );
    registrar.registerFactory<JobsBloc>(
      () => JobsBloc(
        getJobsUseCase: GetJobsUseCase(registrar<JobsRepository>()),
        completeJobUseCase: CompleteJobUseCase(registrar<JobsRepository>()),
      ),
    );
  }
}
