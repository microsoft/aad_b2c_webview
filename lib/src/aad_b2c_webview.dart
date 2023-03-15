import 'dart:io';

import 'package:aad_b2c_webview/src/client_authentication.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../src/constants.dart';

class ADB2CEmbedWebView extends StatefulWidget {
  final String userFlowUrl;
  final String clientId;
  final String redirectUrl;
  final String userFlowName;
  final Function(BuildContext context)? onRedirect;
  final ValueChanged<String>? onAccessToken;
  final ValueChanged<String>? onIDToken;
  final ValueChanged<String>? onAuthToken;
  final ValueChanged<String>? onRefreshToken;
  final List<String> scopes;
  final String? responseType;

  const ADB2CEmbedWebView({
    super.key,
    required this.userFlowUrl,
    required this.clientId,
    required this.redirectUrl,
    this.onRedirect,
    this.onAccessToken,
    this.onIDToken,
    this.onAuthToken,
    this.onRefreshToken,
    required this.scopes,
    this.responseType,
    required this.userFlowName,
  });

  @override
  ADB2CEmbedWebViewState createState() => ADB2CEmbedWebViewState();
}

class ADB2CEmbedWebViewState extends State<ADB2CEmbedWebView> {
  bool isLoading = true;
  bool showRedirect = false;
  String userFlowUrl = '';
  String redirectUrl = '';
  String redirectRoute = '';
  String clientId = '';
  String userFlowName = '';
  final _key = UniqueKey();
  Function onRedirect = () {};
  ValueChanged<String>? onAccessToken;
  ValueChanged<String>? onIDToken;
  ValueChanged<String>? onAuthToken;
  ValueChanged<String>? onRefreshToken;
  List<String> scopes = [];
  String responseType = '';

  @override
  void initState() {
    super.initState();
    userFlowUrl = widget.userFlowUrl;
    clientId = widget.clientId;
    redirectUrl = widget.redirectUrl;
    onRedirect = widget.onRedirect ??
        () {
          Navigator.of(context).pop();
        };
    onAccessToken = widget.onAccessToken;
    onIDToken = widget.onIDToken;
    onAuthToken = widget.onAuthToken;
    onRefreshToken = widget.onRefreshToken;
    scopes = widget.scopes;
    responseType = widget.responseType ?? "id_token";
    userFlowName = widget.userFlowName;

    //Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  authorizationCodeFlow(url) async {
    String authCode = url.split(Constants.authCode)[1];
    ClientAuthentication clientAuthentication = ClientAuthentication();
    final response = await clientAuthentication.getAllTokens(
        redirectUrl, clientId, authCode);
    if (response.statusCode == 200) {
      onAccessToken!(response.data[Constants.accessToken]);
      onIDToken!(response.data[Constants.idToken]);
      onRefreshToken!(response.data[Constants.refreshToken]);

      if (!mounted) return;
      //call redirect function
      onRedirect(context);
    }
  }

  onPageFinishedTasks(String url, Uri response) {
    if (response.path.contains(redirectUrl)) {
      if (url.contains(Constants.idToken)) {
        onIDToken!(url.split(Constants.idToken)[1]);

        //Navigate to the redirect route screen; check for mounted component
        if (!mounted) return;
        //call redirect function
        onRedirect(context);
      } else if (url.contains(Constants.accessToken)) {
        onAccessToken!(url.split(Constants.accessToken)[1]);

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
            initialUrl: getUserFlowUrl(userFlowUrl),
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

  String getUserFlowUrl(String userFlow) {
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

    return url +
        pageParam +
        userFlowName +
        idClientParam +
        clientId +
        nonceParam +
        redirectUrl +
        scopeParam +
        createScopes(scopes) +
        responseTypeParam +
        responseType +
        promptParam;
  }
}
