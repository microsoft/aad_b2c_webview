import 'package:aad_b2c_webview/src/constants.dart';
import 'package:dio/dio.dart';
import 'package:pkce/pkce.dart';

class ClientAuthentication {
  final PkcePair pkcePair;
  ClientAuthentication({required this.pkcePair});

  regenerateAccessToken() async {
    // try {
    //   var accessToken =
    //       await SecureStorage.retrieveToken(Constants.accessToken);
    //   bool accessTokenHasExpired = JwtDecoder.isExpired(accessToken!);
    //   if (accessTokenHasExpired) {
    //     var refreshToken =
    //         await SecureStorage.retrieveToken(Constants.refreshToken);
    //     var response = await Dio().post(
    //       Constants.tokenUrl,
    //       data: {
    //         'grant_type': Constants.refreshToken,
    //         'client_id': 'client_id',
    //         'scope': Constants.scopes,
    //         'refresh_token': refreshToken,
    //       },
    //     );
    //     var newAccessToken = response.data[Constants.accessToken];
    //     await SecureStorage.storeToken(Constants.accessToken, newAccessToken);
    //   }
    // } catch (e) {
    //   logger.e(Constants.errorToken, e);
    // }
  }

  Future<Response> getAllTokens({
    required String redirectUri,
    required String clientId,
    required String authCode,
    required String userFlowName,
    required String tenantBaseUrl,
    String scopes = Constants.defaultScopes,
    String grantType = Constants.defaultGrantType,
  }) async {
    var url = "$tenantBaseUrl$userFlowName/oauth2/v2.0/token";
    var response = await Dio().post(url,
        data: {
          'scope': scopes,
          'grant_type': grantType,
          'code': authCode,
          'client_id': clientId,
          'code_verifier': pkcePair.codeVerifier,
          'redirect_uri': redirectUri,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType));
    return response;
  }
}
