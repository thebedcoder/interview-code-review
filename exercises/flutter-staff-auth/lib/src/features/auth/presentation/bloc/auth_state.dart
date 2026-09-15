part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthSigningIn extends AuthState {
  const AuthSigningIn();
}

class AuthAwaitingCallback extends AuthState {
  const AuthAwaitingCallback({required this.challenge});

  final PkceChallenge challenge;

  @override
  List<Object?> get props => <Object?>[challenge];
}

class AuthSignedIn extends AuthState {
  const AuthSignedIn({required this.accountId});

  final String accountId;

  @override
  List<Object?> get props => <Object?>[accountId];
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}

class AuthFailure extends AuthState {
  const AuthFailure({required this.error});

  final AppException error;

  @override
  List<Object?> get props => <Object?>[error];
}
