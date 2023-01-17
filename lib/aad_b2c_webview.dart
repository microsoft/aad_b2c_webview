import 'dart:io';

import 'package:aad_b2c_webview/client_authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

import 'package:webview_flutter/webview_flutter.dart';

class ADB2CEmbedWebView extends StatefulWidget {
  final String url;
  final String clientId;
  final String redirectUrl;
  final String appRedirectRoute;
  final Function(BuildContext context)? onRedirect;

  const ADB2CEmbedWebView(
      {super.key,
      required this.url,
      required this.clientId,
      required this.redirectUrl,
      required this.appRedirectRoute,
      required this.onRedirect});

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
  final _key = UniqueKey();
  Function onRedirect = () {};

  @override
  void initState() {
    super.initState();
    userFlowUrl = widget.url;
    clientId = widget.clientId;
    redirectUrl = widget.redirectUrl;
    redirectRoute = widget.appRedirectRoute;
    onRedirect = widget.onRedirect ?? () {};
    //Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  authorizationCodeFlow(url) async {
    String authCode = url.split(Constants.authCode)[1];
    ClientAuthentication clientAuthentication = ClientAuthentication();
    SecureStorage.storeToken(Constants.accessToken,
        clientAuthentication.getAccessToken(redirectUrl, clientId, authCode));
  }

  onPageFinishedTasks(String url, Uri response) {
    if (response.path.contains(redirectUrl)) {
      if (url.contains(Constants.idToken)) {
        SecureStorage.storeToken(
          Constants.idToken,
          'Bearer ${url.split(Constants.idToken)[1]}',
        );
      } else if (url.contains(Constants.accessToken)) {
        SecureStorage.storeToken(
          Constants.accessToken,
          'Bearer ${url.split(Constants.accessToken)[1]}',
        );
      } else if (url.contains(Constants.authCode)) {
        //Run authorization code flow and get access token.
        authorizationCodeFlow(url);
      }

      //Navigate to the redirect route screen; check for mounted component
      if (!mounted) return;
      //call redirect function
      onRedirect(context);
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
            initialUrl: userFlowUrl,
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
}

class SecureStorage {
  static const flutterSecureStore = FlutterSecureStorage();

  static Future<void> storeToken(String key, String? token) async {
    await flutterSecureStore.write(key: key, value: token);
  }

  static Future<String?> retrieveToken(String key) async {
    return flutterSecureStore.read(key: key);
  }
}
