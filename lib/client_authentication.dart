import 'package:aad_b2c_webview/constants.dart';

import 'aad_b2c_webview.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:pkce/pkce.dart';

class ClientAuthentication {
  var logger = Logger();
  final pkcePair = PkcePair.generate();

  regenerateAccessToken() async {
    try {
      var accessToken =
      await SecureStorage.retrieveToken(Constants.accessToken);
      bool accessTokenHasExpired = JwtDecoder.isExpired(accessToken!);
      if (accessTokenHasExpired) {
        var refreshToken =
        await SecureStorage.retrieveToken(Constants.refreshToken);
        var response = await Dio().post(
          Constants.tokenUrl,
          data: {
            'grant_type': Constants.refreshToken,
            'client_id': 'client_id',
            'scope': Constants.scopes,
            'refresh_token': refreshToken,
          },
        );
        var newAccessToken = response.data[Constants.accessToken];
        await SecureStorage.storeToken(Constants.accessToken, newAccessToken);
      }
    } catch (e) {
      logger.e(Constants.errorToken, e);
    }
  }

  getAccessToken(String redirectUri, String clientId, String authCode) async {
    var response = await Dio().post(
      Constants.policyTokenUrl,
      data: {
        'grant_type': 'authorization_code',
        'code': authCode,
        'client_id': clientId,
        'code_verifier': pkcePair.codeVerifier,
        'redirect_uri': redirectUri,
      },
    );
    var accessToken = response.data[Constants.accessToken];
    var idToken = response.data[Constants.idToken];
    var refreshToken = response.data[Constants.refreshToken];
    await SecureStorage.storeToken(Constants.accessToken, accessToken);
    await SecureStorage.storeToken(Constants.idToken, idToken);
    await SecureStorage.storeToken(Constants.refreshToken, refreshToken);
  }
}
