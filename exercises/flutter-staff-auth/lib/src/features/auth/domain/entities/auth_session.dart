import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.accountId,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String accountId;

  @override
  List<Object?> get props => <Object?>[
    accessToken,
    refreshToken,
    expiresAt,
    accountId,
  ];
}
