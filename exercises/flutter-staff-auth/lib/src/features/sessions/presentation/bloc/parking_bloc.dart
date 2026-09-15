import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerb/src/core/domain/exceptions/app_exception.dart';
import 'package:kerb/src/features/sessions/domain/entities/parking_session.dart';
import 'package:kerb/src/features/sessions/domain/usecases/get_active_parking_usecase.dart';
import 'package:kerb/src/features/sessions/domain/usecases/start_parking_usecase.dart';
import 'package:kerb/src/features/sessions/domain/usecases/stop_parking_usecase.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  ParkingBloc({
    required this._getActiveParkingUseCase,
    required this._startParkingUseCase,
    required this._stopParkingUseCase,
  }) : super(const ParkingInitial()) {
    on<ParkingRequested>(_onRequested, transformer: restartable());
    on<ParkingStarted>(_onStarted, transformer: droppable());
    on<ParkingStopped>(_onStopped, transformer: droppable());
  }

  final GetActiveParkingUseCase _getActiveParkingUseCase;
  final StartParkingUseCase _startParkingUseCase;
  final StopParkingUseCase _stopParkingUseCase;

  Future<void> _onRequested(
    ParkingRequested event,
    Emitter<ParkingState> emit,
  ) async {
    emit(const ParkingLoading());
    try {
      final ParkingSession? session = await _getActiveParkingUseCase.call();
      emit(
        session == null
            ? const ParkingIdle()
            : ParkingActive(session: session),
      );
    } on AppException catch (error) {
      emit(ParkingFailure(error: error));
    }
  }

  Future<void> _onStarted(
    ParkingStarted event,
    Emitter<ParkingState> emit,
  ) async {
    emit(const ParkingLoading());
    try {
      final ParkingSession session = await _startParkingUseCase.call(
        bayCode: event.bayCode,
      );
      emit(ParkingActive(session: session));
    } on AppException catch (error) {
      emit(ParkingFailure(error: error));
    }
  }

  Future<void> _onStopped(
    ParkingStopped event,
    Emitter<ParkingState> emit,
  ) async {
    final ParkingState current = state;
    if (current is! ParkingActive) {
      return;
    }
    try {
      final ParkingSession session = await _stopParkingUseCase.call(
        sessionId: current.session.id,
        startedAt: current.session.startedAt,
      );
      emit(ParkingFinished(session: session));
    } on AppException catch (error) {
      emit(ParkingFailure(error: error));
    }
  }
}
