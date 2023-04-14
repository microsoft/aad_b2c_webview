class Constants {
  static const String accessToken = "access_token";
  static const String idToken = "id_token";
  static const String refreshToken = "refresh_token";
  static const String refreshTokenExpiresIn = "refresh_token_expires_in";
  static const String authCode = "code";
  static const String tokenUrl =
      'https://login.microsoftonline.com/tenant.onmicrosoft.com/oauth2/v2.0/token';
  static const String defaultScopes = 'openid profile offline_access';
  static const String errorToken = "error acquiring token";
  static const String policyTokenUrl =
      'https://login.microsoftonline.com/tenant.onmicrosoft.com/oauth2/v2.0/token?p=';
  static const String defaultGrantType = "authorization_code";
  static const String defaultCodeChallengeCode = "S256";
  static const String userFlowUrlEnding = "oauth2/v2.0/authorize";
  static const String userGetTokenUrlEnding = "oauth2/v2.0/token";
  static const defaultResponseType = "code";
}
