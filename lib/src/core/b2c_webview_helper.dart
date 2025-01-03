import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class B2CWebViewHelper {
  final PkcePair _pkcePairInstance;
  final B2CAuthRepository _b2cAuthRepository;

  B2CWebViewHelper({
    required PkcePair pkcePairInstance,
    required B2CAuthRepository b2cAuthRepository,
  })  : _b2cAuthRepository = b2cAuthRepository,
        _pkcePairInstance = pkcePairInstance;

  PkcePair get pkcePair => _pkcePairInstance;

  /// Constructs the user flow URL with optional parameters.
  B2CWebViewParams getUserFlowUrl({required B2CWebViewParams params}) {
    //Check if the user added the full user flow or just till 'authorize'
    if (!params.userFlowName.contains('?')) {
      final String url =
          "${params.tenantBaseUrl}/${Constants.userFlowUrlEnding}";
      return _concatUserFlow(params, url);
    }
    params = params.copyWith(urlUserFlow: params.userFlowName);
    return params;
  }

  /// Creates a string representation of the scopes.
  String createScopes(List<String> scopeList) {
    return scopeList.join(' ');
  }

  /// Concatenates the user flow URL with additional parameters.
  B2CWebViewParams _concatUserFlow(B2CWebViewParams params, String url) {
    const idClientParam = '&client_id=';
    const nonceParam = '&nonce=defaultNonce&redirect_uri=';
    const scopeParam = '&scope=';
    const responseTypeParam = '&response_type=';
    final promptParam = '&prompt=${params.promptType}';
    const pageParam = '?p=';
    const codeChallengeMethod =
        '&code_challenge_method=${Constants.defaultCodeChallengeCode}';

    final codeChallenge = "&code_challenge=${_pkcePairInstance.codeChallenge}";
    final StringBuffer urlAuth = StringBuffer();

    urlAuth
      ..write(url)
      ..write(pageParam)
      ..write(params.userFlowName)
      ..write(idClientParam)
      ..write(params.clientId)
      ..write(nonceParam)
      ..write(params.redirectUrl.encodeComponent())
      ..write(scopeParam)
      ..write(createScopes(params.scopes))
      ..write(responseTypeParam)
      ..write(params.responseType);

    final optionalParameters = params.optionalParameters ?? [];
    if (optionalParameters.isNotEmpty) {
      for (var param in optionalParameters) {
        urlAuth.write("&${param.key}=${param.value}");
      }
    }

    if (params.isLoginFlow) {
      urlAuth.write(promptParam);
    }

    if (params.containsChallenge) {
      urlAuth
        ..write(codeChallenge)
        ..write(codeChallengeMethod);
    }

    params = params.copyWith(urlUserFlow: urlAuth.toString());
    return params;
  }

  Future<void> checkPage({
    required B2CWebViewParams params,
    required String url,
  }) async {
    final Uri response = Uri.dataFromString(url);
    final authCode = response.queryParameters[Constants.authCode];
    if (authCode != null) {
      await _authorizationCodeFlow(params, authCode);
    } else if (params.onRedirect != null) {
      params.onRedirect!();
    }
  }

  Future<void> _authorizationCodeFlow(
    B2CWebViewParams params,
    String codeFlow,
  ) async {
    final AzureTokenResponseEntity? tokensData =
        await _b2cAuthRepository.getAllTokens(
      B2CAuthEntity(
        redirectUri: params.redirectUrl.encodeComponent(),
        clientId: params.clientId,
        authCode: codeFlow,
        providedScopes: (params.scopes).isEmpty
            ? Constants.defaultScopes
            : createScopes(params.scopes),
        userFlowName: params.userFlowName,
        tenantBaseUrl: params.tenantBaseUrl,
      ),
    );

    if (tokensData != null) {
      TokenEntity accessToken = TokenEntity(
        type: TokenType.accessToken,
        value: tokensData.accessToken,
      );

      TokenEntity idToken = TokenEntity(
        type: TokenType.idToken,
        value: tokensData.idToken,
      );

      TokenEntity refreshToken = TokenEntity(
        type: TokenType.refreshToken,
        value: tokensData.refreshToken,
        expirationTime: tokensData.refreshTokenExpireTime,
      );

      if (accessToken.value != null && params.onAccessToken != null) {
        params.onAccessToken!(accessToken);
      }

      if (idToken.value != null && params.onIDToken != null) {
        params.onIDToken!(idToken);
      }

      if (refreshToken.value != null && params.onRefreshToken != null) {
        params.onRefreshToken!(refreshToken);
      }

      if (params.onAllTokensRetrieved != null) {
        params.onAllTokensRetrieved!(
          accessToken: accessToken,
          idToken: idToken,
          refreshToken: refreshToken,
        );
      }
    } else if (params.onHtmlErrorInfo != null) {
      params.onHtmlErrorInfo!('Get Tokens Failed');
    }
  }
}
