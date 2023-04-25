import 'dart:io';

import 'package:aad_b2c_webview/src/services/client_authentication.dart';
import 'package:aad_b2c_webview/src/services/models/response_data.dart';
import 'package:aad_b2c_webview/src/services/models/token.dart';

import 'package:flutter/material.dart';
import 'package:pkce/pkce.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants.dart';

class ADB2CEmbedWebView extends StatefulWidget {
  final String tenantBaseUrl;
  final String clientId;
  final String redirectUrl;
  final String userFlowName;
  final Function(BuildContext context)? onRedirect;
  final ValueChanged<Token> onAccessToken;
  final ValueChanged<Token> onIDToken;
  final ValueChanged<Token> onRefreshToken;
  final ValueChanged<Token>? onAnyTokenRetrieved;
  final List<String> scopes;
  final String responseType;

  const ADB2CEmbedWebView({
    super.key,
    // Required to work
    required this.tenantBaseUrl,
    required this.clientId,
    required this.redirectUrl,
    required this.userFlowName,
    required this.scopes,
    required this.onAccessToken,
    required this.onIDToken,
    required this.onRefreshToken,

    // Optionals
    this.onRedirect,
    this.onAnyTokenRetrieved,

    // Optionals with default value
    this.responseType = Constants.defaultResponseType,
  });

  @override
  ADB2CEmbedWebViewState createState() => ADB2CEmbedWebViewState();
}

class ADB2CEmbedWebViewState extends State<ADB2CEmbedWebView> {
  final PkcePair pkcePairInstance = PkcePair.generate();
  final _key = UniqueKey();
  late Function onRedirect;

  bool isLoading = true;
  bool showRedirect = false;

  @override
  void initState() {
    onRedirect = widget.onRedirect ??
        () {
          Navigator.of(context).pop();
        };

    //Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  void onAnyTokenRecivedCallback(Token token) {
    if (widget.onAnyTokenRetrieved != null) {
      widget.onAnyTokenRetrieved!(token);
    }
  }

  void handleTokenCallbacks({required AzureTokenResponse? tokensData}) {
    String? accessTokenValue = tokensData?.accessToken;
    String? idTokenValue = tokensData?.idToken;
    String? refreshTokenValue = tokensData?.refreshToken;

    if (accessTokenValue != null) {
      final Token token =
          Token(type: TokenType.accessToken, value: accessTokenValue);
      widget.onAccessToken(token);
      onAnyTokenRecivedCallback(token);
    }

    if (idTokenValue != null) {
      final token = Token(type: TokenType.idToken, value: idTokenValue);
      widget.onIDToken(token);
      onAnyTokenRecivedCallback(token);
    }

    if (refreshTokenValue != null) {
      final Token token = Token(
          type: TokenType.refreshToken,
          value: refreshTokenValue,
          expirationTime: tokensData?.refreshTokenExpireTime);
      widget.onRefreshToken(token);
      onAnyTokenRecivedCallback(token);
    }
  }

  authorizationCodeFlow(url) async {
    String authCode = url.split("${Constants.authCode}=")[1];

    ClientAuthentication clientAuthentication =
        ClientAuthentication(pkcePair: pkcePairInstance);

    final AzureTokenResponse? tokensData =
        await clientAuthentication.getAllTokens(
      redirectUri: widget.redirectUrl,
      clientId: widget.clientId,
      authCode: authCode,
      userFlowName: widget.userFlowName,
      tenantBaseUrl: widget.tenantBaseUrl,
    );

    if (tokensData != null) {
      if (!mounted) return;
      // call redirect function
      handleTokenCallbacks(tokensData: tokensData);
      onRedirect(context);
    }
  }

  onPageFinishedTasks(String url, Uri response) {
    if (response.path.contains(widget.redirectUrl)) {
      if (url.contains(Constants.idToken)) {
        //Navigate to the redirect route screen; check for mounted component
        if (!mounted) return;
        //call redirect function
        onRedirect(context);
      } else if (url.contains(Constants.accessToken)) {
        //Navigate to the redirect route screen; check for mounted component
        if (!mounted) return;
        //call redirect function
        onRedirect(context);
      } else if (url.contains(Constants.authCode)) {
        //Run authorization code flow and get access token.
        authorizationCodeFlow(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            debuggingEnabled: true,
            initialUrl: getUserFlowUrl(
                userFlow:
                    "${widget.tenantBaseUrl}/${Constants.userFlowUrlEnding}"),
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });

              final Uri response = Uri.dataFromString(url);
              //Check that the user is past authentication and current URL is the redirect with the code.
              onPageFinishedTasks(url, response);
            },
          ),
          if (isLoading || showRedirect)
            const Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            )
          else
            Stack(),
          if (isLoading)
            const Positioned(
              child: Center(
                child: Text('Redirecting to Secure Login...'),
              ),
            )
          else
            Stack(),
        ],
      ),
    );
  }

  String getUserFlowUrl({required String userFlow}) {
    List<String>? userFlowSplit = userFlow.split('?');
    //Check if the user added the full user flow or just till 'authorize'
    if (userFlowSplit.length == 1) {
      return concatUserFlow(userFlow);
    }
    return userFlow;
  }

  String createScopes(List<String> scopeList) {
    String allScope = '';
    for (String scope in scopeList) {
      scope += '%20';
      allScope += scope;
    }
    return allScope.substring(0, allScope.length - 3);
  }

  String concatUserFlow(String url) {
    const idClientParam = '&client_id=';
    const nonceParam = '&nonce=defaultNonce&redirect_uri=';
    const scopeParam = '&scope=';
    const responseTypeParam = '&response_type=';
    const promptParam = '&prompt=login';
    const pageParam = '?p=';
    const codeChallengeMethod =
        '&code_challenge_method=${Constants.defaultCodeChallengeCode}';
    final codeChallenge = "&code_challenge=${pkcePairInstance.codeChallenge}";

    return url +
        pageParam +
        widget.userFlowName +
        idClientParam +
        widget.clientId +
        nonceParam +
        widget.redirectUrl +
        scopeParam +
        createScopes(widget.scopes) +
        responseTypeParam +
        widget.responseType +
        promptParam +
        codeChallenge +
        codeChallengeMethod;
  }
}
