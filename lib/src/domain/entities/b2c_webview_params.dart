import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';

class B2CWebViewParams {
  final String tenantBaseUrl;
  final String clientId;
  final String redirectUrl;
  final String userFlowName;
  final String responseType;
  final String urlUserFlow;
  final String promptType;
  final String? userAgent;
  final bool isLoginFlow;
  final bool containsChallenge;
  final List<String> scopes;
  final Color webViewBackgroundColor;
  final Widget? loadingReplacement;
  final int? timeOutInMillis;
  final Function({
    required TokenEntity accessToken,
    required TokenEntity idToken,
    required TokenEntity refreshToken,
  })? onAllTokensRetrieved;
  final VoidCallback? onRedirect;
  final ValueChanged<TokenEntity>? onAccessToken;
  final ValueChanged<TokenEntity>? onIDToken;
  final ValueChanged<TokenEntity>? onRefreshToken;
  final List<OptionalParam>? optionalParameters;
  final ValueChanged<String>? onHtmlErrorInfo;
  final ValueChanged<String>? onHtmlComponents;
  final ValueChanged<String>? onHtmlUrlChange;

  B2CWebViewParams({
    required this.tenantBaseUrl,
    required this.clientId,
    required this.redirectUrl,
    required this.userFlowName,
    required this.scopes,
    required this.isLoginFlow,
    required this.containsChallenge,
    this.onAllTokensRetrieved,
    this.promptType = Constants.promptTypeLogin,
    this.responseType = Constants.defaultResponseType,
    this.urlUserFlow = '',
    this.webViewBackgroundColor = Colors.white,
    this.loadingReplacement,
    this.userAgent,
    this.onRedirect,
    this.onAccessToken,
    this.onIDToken,
    this.onRefreshToken,
    this.optionalParameters,
    this.onHtmlErrorInfo,
    this.onHtmlComponents,
    this.onHtmlUrlChange,
    this.timeOutInMillis,
  });

  B2CWebViewParams copyWith({
    String? urlUserFlow,
    ValueChanged<String>? onHtmlErrorInfo,
    ValueChanged<String>? onHtmlComponents,
    ValueChanged<String>? onHtmlUrlChange,
    final Function({
      required TokenEntity accessToken,
      required TokenEntity idToken,
      required TokenEntity refreshToken,
    })? onAllTokensRetrieved,
  }) {
    return B2CWebViewParams(
      urlUserFlow: urlUserFlow ?? this.urlUserFlow,
      tenantBaseUrl: tenantBaseUrl,
      clientId: clientId,
      redirectUrl: redirectUrl,
      userFlowName: userFlowName,
      responseType: responseType,
      userAgent: userAgent,
      scopes: scopes,
      webViewBackgroundColor: webViewBackgroundColor,
      onRedirect: onRedirect,
      onAccessToken: onAccessToken,
      onIDToken: onIDToken,
      onRefreshToken: onRefreshToken,
      optionalParameters: optionalParameters,
      onHtmlComponents: onHtmlComponents ?? this.onHtmlComponents,
      onHtmlErrorInfo: onHtmlErrorInfo ?? this.onHtmlErrorInfo,
      onHtmlUrlChange: onHtmlUrlChange ?? this.onHtmlUrlChange,
      onAllTokensRetrieved: onAllTokensRetrieved ?? this.onAllTokensRetrieved,
      isLoginFlow: isLoginFlow,
      containsChallenge: containsChallenge,
    );
  }
}
