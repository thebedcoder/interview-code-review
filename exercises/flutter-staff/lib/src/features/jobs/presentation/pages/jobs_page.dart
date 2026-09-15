import 'package:fieldops/src/core/di/service_locator.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:fieldops/src/features/jobs/presentation/bloc/jobs_bloc.dart';
import 'package:fieldops/src/features/jobs/presentation/widgets/job_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JobsBloc>(
      create: (_) =>
          serviceLocator<JobsBloc>()..add(const JobsRequested()),
      child: const _JobsView(),
    );
  }
}

class _JobsView extends StatelessWidget {
  const _JobsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's jobs"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<JobsBloc>().add(
              const JobsRequested(forceRefresh: true),
            ),
          ),
        ],
      ),
      body: BlocBuilder<JobsBloc, JobsState>(
        builder: (BuildContext context, JobsState state) {
          return switch (state) {
            JobsInitial() || JobsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            JobsFailure(:final AppException error) => Center(
              child: Text(error.message),
            ),
            JobsLoaded(:final List<Job> jobs) => ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                final Job job = jobs[index];
                return JobTile(
                  job: job,
                  onComplete: () => context.read<JobsBloc>().add(
                    JobCompleted(jobId: job.id, notes: ''),
                  ),
                );
              },
            ),
          };
        },
      ),
    );
  }
}
