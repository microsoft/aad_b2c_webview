import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class AzureTokenResponse {
  final String? idToken;
  final String? refreshToken;
  final String? accessToken;
  final int? refreshTokenExpireTime;

  AzureTokenResponse({
    this.idToken,
    this.accessToken,
    this.refreshToken,
    this.refreshTokenExpireTime,
  });

  // Casts types to whatever is required, if fails returns nulls
  static T? _castType<T>(x) => x is T ? x : null;

  /// Transforms the seconds that the token expires from: "seconds from now"
  /// that AAD sends to -> "seconds since epoch", to keep consistency with how
  /// JWT sends back inside the the token and to allow easy storage to know at any
  /// time when a token will expire since it can be easly compared i.e
  /// (DateTime.now().millisecondsSinceEpoch * 10) >= _getExpirationTimeInSecondsSinceEpoch(value)
  /// In this way you would know if your token is already expired just like you would do
  /// with a JWT token checking on the "exp" param.
  static int? _getExpirationTimeInSecondsSinceEpoch(dynamic secondsFromNow) {
    var secondsFromNowCastedToInt = _castType<int>(secondsFromNow);
    if (secondsFromNowCastedToInt != null) {
      int milliseconds = DateTime.now().millisecondsSinceEpoch +
          (secondsFromNowCastedToInt * 1000);
      return milliseconds ~/ 1000;
    }
    return null;
  }

  AzureTokenResponse.fromJson(Map<String, dynamic> json)
      : idToken = json[Constants.idToken],
        accessToken = json[Constants.accessToken],
        refreshToken = json[Constants.refreshToken],
        refreshTokenExpireTime = _getExpirationTimeInSecondsSinceEpoch(
            json[Constants.refreshTokenExpiresIn]);
}
