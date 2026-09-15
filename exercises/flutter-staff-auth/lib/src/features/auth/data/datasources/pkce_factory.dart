import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:kerb/src/features/auth/domain/entities/pkce_challenge.dart';

class PkceFactory {
  const PkceFactory();

  static const int _entropyBytes = 32;

  PkceChallenge create() {
    final Random random = Random.secure();
    final List<int> verifierBytes = List<int>.generate(
      _entropyBytes,
      (_) => random.nextInt(256),
    );
    final String verifier = base64UrlEncode(verifierBytes).replaceAll('=', '');
    final String challenge = base64UrlEncode(
      sha256.convert(utf8.encode(verifier)).bytes,
    ).replaceAll('=', '');
    final List<int> stateBytes = List<int>.generate(
      _entropyBytes,
      (_) => random.nextInt(256),
    );
    return PkceChallenge(
      verifier: verifier,
      challenge: challenge,
      state: base64UrlEncode(stateBytes).replaceAll('=', ''),
    );
  }
}
