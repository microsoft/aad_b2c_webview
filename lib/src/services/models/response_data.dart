import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class TokenResponseDataModel {
  final String? idToken;
  final String? refreshToken;
  final String? accessToken;
  final int? refreshTokenExpireTime;

  TokenResponseDataModel({
    this.idToken,
    this.accessToken,
    this.refreshToken,
    this.refreshTokenExpireTime,
  });

  TokenResponseDataModel.fromJson(Map<String, dynamic> json)
      : idToken = json[Constants.idToken],
        accessToken = json[Constants.accessToken],
        refreshToken = json[Constants.refreshToken],
        refreshTokenExpireTime = json[Constants.refreshTokenExpiresIn];
}
