import 'dart:io';

import 'package:aad_b2c_webview/src/client_authentication.dart';
import 'package:flutter/material.dart';
import 'package:pkce/pkce.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../src/constants.dart';

enum TokenType { accessToken, idToken, refreshToken }

class ADB2CEmbedWebView extends StatefulWidget {
  final String tenantBaseUrl;
  final String clientId;
  final String redirectUrl;
  final String userFlowName;
  final Function(BuildContext context)? onRedirect;
  final ValueChanged<String>? onAccessToken;
  final ValueChanged<String>? onIDToken;
  final ValueChanged<String>? onAuthToken;
  final ValueChanged<String>? onRefreshToken;
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
    // Optionals
    this.onRedirect,
    this.onAccessToken,
    this.onIDToken,
    this.onAuthToken,
    this.onRefreshToken,
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
    super.initState();
    onRedirect = widget.onRedirect ??
        () {
          Navigator.of(context).pop();
        };

    //Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  // Avoid calling callbacks when null values are present
  void handleTokenCallback(
      {required String? token, required TokenType tokenType}) {
    if (token != null) {
      switch (tokenType) {
        case TokenType.accessToken:
          if (widget.onAccessToken != null) {
            widget.onAccessToken!(token);
          }
          break;
        case TokenType.idToken:
          if (widget.onIDToken != null) {
            widget.onIDToken!(token);
          }
          break;
        case TokenType.refreshToken:
          if (widget.onRefreshToken != null) {
            widget.onRefreshToken!(token);
          }

          break;
      }
    }
  }

  authorizationCodeFlow(url) async {
    String authCode = url.split(Constants.authCode)[1];

    ClientAuthentication clientAuthentication =
        ClientAuthentication(pkcePair: pkcePairInstance);

    final response = await clientAuthentication.getAllTokens(
      redirectUri: widget.redirectUrl,
      clientId: widget.clientId,
      authCode: authCode,
      userFlowName: widget.userFlowName,
      tenantBaseUrl: widget.tenantBaseUrl,
    );

    if (response.statusCode == 200) {
      handleTokenCallback(
          tokenType: TokenType.accessToken,
          token: response.data[Constants.accessToken]);
      handleTokenCallback(
          tokenType: TokenType.idToken,
          token: response.data[Constants.idToken]);
      handleTokenCallback(
          tokenType: TokenType.refreshToken,
          token: response.data[Constants.refreshToken]);

      if (!mounted) return;
      //call redirect function
      onRedirect(context);
    }
  }

  onPageFinishedTasks(String url, Uri response) {
    if (response.path.contains(widget.redirectUrl)) {
      if (url.contains(Constants.idToken)) {
        handleTokenCallback(
            token: url.split(Constants.idToken)[1],
            tokenType: TokenType.idToken);
        //Navigate to the redirect route screen; check for mounted component
        if (!mounted) return;
        //call redirect function
        onRedirect(context);
      } else if (url.contains(Constants.accessToken)) {
        handleTokenCallback(
            token: url.split(Constants.accessToken)[1],
            tokenType: TokenType.accessToken);

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
                userFlow: widget.tenantBaseUrl + Constants.userFlowUrlEnding),
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
