import 'dart:convert';

import 'package:aad_b2c_webview/src/constants.dart';
import 'package:aad_b2c_webview/src/services/models/response_data.dart';
import 'package:pkce/pkce.dart';
import 'package:http/http.dart' as http;

const _formUrlEncodedContentType = "application/x-www-form-urlencoded";

class ClientAuthentication {
  final PkcePair pkcePair;
  ClientAuthentication({required this.pkcePair});

  /// Refresh token: This method also returns a new refresh token [AzureTokenResponse]
  static Future<AzureTokenResponse?> refreshTokens({
    required String refreshToken,
    required String tenant,
    required String policy,
    required String clientId,
  }) async {
    final uri = Uri.parse(
        "https://$tenant.b2clogin.com/$tenant.onmicrosoft.com/$policy/${Constants.userGetTokenUrlEnding}");

    final response = await http.post(uri, body: {
      'grant_type': Constants.refreshToken,
      'scope': Constants.defaultScopes,
      'client_id': clientId,
      'refresh_token': refreshToken,
    }, headers: {
      "Content-Type": _formUrlEncodedContentType
    });

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = jsonDecode(response.body);
      return AzureTokenResponse.fromJson(body);
    } else {
      return null;
    }
  }

  /// Get Access, Id and refresh token, check its response: [AzureTokenResponse]
  Future<AzureTokenResponse?> getAllTokens({
    required String redirectUri,
    required String clientId,
    required String authCode,
    required String providedScopes,
    required String userFlowName,
    required String tenantBaseUrl,
    String grantType = Constants.defaultGrantType,
  }) async {
    final uri = Uri.parse(
        "$tenantBaseUrl/$userFlowName/${Constants.userGetTokenUrlEnding}");
    final response = await http.post(uri, body: {
      'scope': providedScopes,
      'grant_type': grantType,
      'code': authCode,
      'client_id': clientId,
      'code_verifier': pkcePair.codeVerifier,
      'redirect_uri': redirectUri,
    }, headers: {
      "Content-Type": _formUrlEncodedContentType
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return AzureTokenResponse.fromJson(body);
    } else {
      return null;
    }
  }
}
