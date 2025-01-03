import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class B2CAuthEntity {
  final String? refreshToken;
  final String? clientId;
  final String? redirectUri;
  final String? authCode;
  final String? providedScopes;
  final String? userFlowName;
  final String? tenantBaseUrl;
  final String grantType;

  B2CAuthEntity({
    this.redirectUri,
    this.clientId,
    this.authCode,
    this.providedScopes,
    this.userFlowName,
    this.tenantBaseUrl,
    this.refreshToken,
    this.grantType = Constants.defaultGrantType,
  });

  B2CAuthEntity copyWith({
    String? refreshToken,
    String? clientId,
    String? redirectUri,
    String? authCode,
    String? providedScopes,
    String? userFlowName,
    String? tenantBaseUrl,
    String? grantType,
  }) {
    return B2CAuthEntity(
      refreshToken: refreshToken ?? this.refreshToken,
      clientId: clientId ?? this.clientId,
      redirectUri: redirectUri ?? this.redirectUri,
      authCode: authCode ?? this.authCode,
      providedScopes: providedScopes ?? this.providedScopes,
      userFlowName: userFlowName ?? this.userFlowName,
      tenantBaseUrl: tenantBaseUrl ?? this.tenantBaseUrl,
      grantType: grantType ?? this.grantType,
    );
  }
}
