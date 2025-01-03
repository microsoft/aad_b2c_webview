import 'package:aad_b2c_webview/aad_b2c_webview.dart';

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
