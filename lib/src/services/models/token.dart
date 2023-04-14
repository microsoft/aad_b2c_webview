import 'package:aad_b2c_webview/src/constants.dart';

enum TokenType {
  accessToken,
  idToken,
  refreshToken,
}

extension TokenTypeExtension on TokenType {
  String get name {
    switch (this) {
      case TokenType.accessToken:
        return Constants.accessToken;
      case TokenType.refreshToken:
        return Constants.refreshToken;
      case TokenType.idToken:
        return Constants.idToken;
    }
  }
}

class Token {
  final String value;
  final TokenType type;
  final int? expirationTime;

  Token({required this.type, this.expirationTime, required this.value});
}
