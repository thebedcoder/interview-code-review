import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:fieldops/src/core/domain/exceptions/app_exception.dart';
import 'package:fieldops/src/features/auth/domain/entities/auth_tokens.dart';
import 'package:fieldops/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this._signInUseCase}) : super(const AuthInitial()) {
    on<AuthSignInRequested>(_onSignInRequested, transformer: droppable());
  }

  final SignInUseCase _signInUseCase;

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final AuthTokens tokens = await _signInUseCase.call(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(tokens: tokens));
    } on AppException catch (error) {
      emit(AuthFailure(error: error));
    }
  }
}
