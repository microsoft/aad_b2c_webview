import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class TokenEntity {
  final String? value;
  final TokenType type;
  final int? expirationTime;

  TokenEntity({
    required this.type,
    this.expirationTime,
    required this.value,
  });
}
