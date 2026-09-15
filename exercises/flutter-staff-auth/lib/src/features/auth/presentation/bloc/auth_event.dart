part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested();
}

class AuthCallbackReceived extends AuthEvent {
  const AuthCallbackReceived({required this.callback});

  final Uri callback;

  @override
  List<Object?> get props => <Object?>[callback];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}
