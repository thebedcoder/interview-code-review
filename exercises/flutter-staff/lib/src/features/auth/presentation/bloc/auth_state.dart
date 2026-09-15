part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.tokens});

  final AuthTokens tokens;

  @override
  List<Object?> get props => <Object?>[tokens];
}

class AuthFailure extends AuthState {
  const AuthFailure({required this.error});

  final AppException error;

  @override
  List<Object?> get props => <Object?>[error];
}
