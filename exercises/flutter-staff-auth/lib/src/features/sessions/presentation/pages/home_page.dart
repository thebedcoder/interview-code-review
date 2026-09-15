import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kerb/src/core/di/service_locator.dart';
import 'package:kerb/src/core/domain/exceptions/app_exception.dart';
import 'package:kerb/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';
import 'package:kerb/src/features/sessions/presentation/bloc/parking_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParkingBloc>(
      create: (_) =>
          serviceLocator<ParkingBloc>()..add(const ParkingRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kerb'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthSignOutRequested()),
          ),
        ],
      ),
      body: BlocBuilder<ParkingBloc, ParkingState>(
        builder: (BuildContext context, ParkingState state) {
          return switch (state) {
            ParkingInitial() || ParkingLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ParkingFailure(:final AppException error) => Center(
              child: Text(error.message),
            ),
            ParkingIdle() => const _IdleView(),
            ParkingActive(:final ParkingSession session) => _ActiveView(
              session: session,
            ),
            ParkingFinished(:final ParkingSession session) => _FinishedView(
              session: session,
            ),
          };
        },
      ),
    );
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Not parked'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.read<ParkingBloc>().add(
              const ParkingStarted(bayCode: 'DEMO-01'),
            ),
            child: const Text('Start parking'),
          ),
        ],
      ),
    );
  }
}

class _ActiveView extends StatelessWidget {
  const _ActiveView({required this.session});

  final ParkingSession session;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Parked in bay ${session.bayCode}'),
          Text('Since ${DateFormat.jm().format(session.startedAt)}'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () =>
                context.read<ParkingBloc>().add(const ParkingStopped()),
            child: const Text('Stop parking'),
          ),
        ],
      ),
    );
  }
}

class _FinishedView extends StatelessWidget {
  const _FinishedView({required this.session});

  final ParkingSession session;

  @override
  Widget build(BuildContext context) {
    final NumberFormat money = NumberFormat.currency(
      locale: 'en_GB',
      symbol: '£',
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Parking finished'),
          Text(money.format((session.chargedPence ?? 0) / 100)),
        ],
      ),
    );
  }
}
