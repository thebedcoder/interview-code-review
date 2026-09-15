import 'dart:async';

import 'package:fieldops/src/core/di/service_locator.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/jobs/domain/entities/job.dart';
import 'package:fieldops/src/features/jobs/presentation/bloc/jobs_bloc.dart';
import 'package:fieldops/src/features/jobs/presentation/widgets/job_tile.dart';
import 'package:fieldops/src/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JobsBloc>(
      create: (_) => serviceLocator<JobsBloc>()..add(const JobsRequested()),
      child: const _JobsView(),
    );
  }
}

class _JobsView extends StatefulWidget {
  const _JobsView();

  @override
  State<_JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<_JobsView> {
  late final SyncBloc _syncBloc;
  StreamSubscription<SyncState>? _syncSubscription;
  Timer? _pollTimer;
  SyncState _syncState = const SyncIdle(pendingCount: 0);

  @override
  void initState() {
    super.initState();
    _syncBloc = serviceLocator<SyncBloc>();
    _resubscribe();
    _restartPolling();
    unawaited(_warmUpQueue());
  }

  void _resubscribe() {
    _syncSubscription?.cancel();
    _syncSubscription = _syncBloc.stream.listen((SyncState state) {
      setState(() => _syncState = state);
    });
  }

  void _restartPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _syncBloc.add(const SyncRequested());
    });
  }

  Future<void> _warmUpQueue() async {
    _syncBloc.add(const SyncRequested());
  }

  void _complete(Job job) {
    _syncBloc.add(SyncJobCompletionQueued(jobId: job.id, notes: ''));
    context.read<JobsBloc>().add(JobCompleted(jobId: job.id, notes: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's jobs"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _restartPolling();
              context.read<JobsBloc>().add(
                const JobsRequested(forceRefresh: true),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (_syncState case SyncInProgress(:final int total, :final int completed))
            MaterialBanner(
              content: Text('Uploading $completed of $total completed jobs'),
              actions: const <Widget>[SizedBox.shrink()],
            ),
          if (_syncState case SyncIdle(:final int pendingCount)
              when pendingCount > 0)
            MaterialBanner(
              content: Text('$pendingCount jobs waiting to upload'),
              actions: const <Widget>[SizedBox.shrink()],
            ),
          Expanded(
            child: BlocBuilder<JobsBloc, JobsState>(
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
                        onComplete: () => _complete(job),
                      );
                    },
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
