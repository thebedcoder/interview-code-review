import 'package:equatable/equatable.dart';

/// The one-time values that tie an authorisation request to the callback that
/// answers it. [state] is what proves the callback came from the request this
/// app started, and not from a link someone else crafted.
class PkceChallenge extends Equatable {
  const PkceChallenge({
    required this.verifier,
    required this.challenge,
    required this.state,
  });

  final String verifier;
  final String challenge;
  final String state;

  @override
  List<Object?> get props => <Object?>[verifier, challenge, state];
}
