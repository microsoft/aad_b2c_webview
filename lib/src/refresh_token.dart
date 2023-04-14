import 'package:dio/dio.dart';
import 'constants.dart';
import 'response_data.dart';

class RefreshToken {
  static Future<TokenResponseDataModel?> regenerateAccessToken({
    required String refreshToken,
    required String tenant,
    required String policy,
    required String clientId,
  }) async {
    var url = "https://$tenant.b2clogin.com/$tenant.onmicrosoft.com/$policy/oauth2/v2.0/token";
    Response response = await Dio().post(
      url,
      data: {
        'grant_type': Constants.refreshToken,
        'scope': Constants.defaultScopes,
        'client_id': clientId,
        'refresh_token': refreshToken,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (response.statusCode == 200) {
      return TokenResponseDataModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}