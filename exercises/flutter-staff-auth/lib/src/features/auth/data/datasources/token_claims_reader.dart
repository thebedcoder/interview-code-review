import 'dart:convert';

/// Reads the claims out of the access token.
class TokenClaimsReader {
  const TokenClaimsReader();

  Map<String, dynamic> read(String accessToken) {
    final List<String> parts = accessToken.split('.');
    if (parts.length != 3) {
      return <String, dynamic>{};
    }
    final String payload = parts[1].padRight(
      parts[1].length + (4 - parts[1].length % 4) % 4,
      '=',
    );
    return jsonDecode(utf8.decode(base64Url.decode(payload)))
        as Map<String, dynamic>;
  }
}
