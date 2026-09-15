import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerb/src/core/domain/exceptions/app_exception.dart';
import 'package:kerb/src/features/auth/domain/entities/auth_session.dart';
import 'package:kerb/src/features/auth/domain/entities/pkce_challenge.dart';
import 'package:kerb/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:kerb/src/features/auth/domain/usecases/begin_sign_in_usecase.dart';
import 'package:kerb/src/features/auth/domain/usecases/complete_sign_in_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this._beginSignInUseCase,
    required this._completeSignInUseCase,
    required this._authRepository,
  }) : super(const AuthInitial()) {
    on<AuthStarted>(_onStarted, transformer: droppable());
    on<AuthSignInRequested>(_onSignInRequested, transformer: droppable());
    on<AuthCallbackReceived>(_onCallbackReceived, transformer: sequential());
    on<AuthSignOutRequested>(_onSignOutRequested, transformer: droppable());
  }

  final BeginSignInUseCase _beginSignInUseCase;
  final CompleteSignInUseCase _completeSignInUseCase;
  final AuthRepository _authRepository;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final AuthSession? session = await _authRepository.currentSession();
    emit(
      session == null
          ? const AuthSignedOut()
          : AuthSignedIn(accountId: session.accountId),
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSigningIn());
    final PkceChallenge challenge = await _beginSignInUseCase.call();
    emit(AuthAwaitingCallback(challenge: challenge));
  }

  Future<void> _onCallbackReceived(
    AuthCallbackReceived event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSigningIn());
    try {
      final AuthSession session = await _completeSignInUseCase.call(
        event.callback,
      );
      emit(AuthSignedIn(accountId: session.accountId));
    } on AppException catch (error) {
      emit(AuthFailure(error: error));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(const AuthSignedOut());
  }
}
