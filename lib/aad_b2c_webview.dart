import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:webview_flutter/webview_flutter.dart';

class ADB2CEmbedWebView extends StatefulWidget {
  final String url;
  final String redirectUrl;
  final String redirectRoute;
  final Function(BuildContext context)? onRedirect;

  const ADB2CEmbedWebView(
      {super.key,
      required this.url,
      required this.redirectUrl,
      required this.redirectRoute,
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
  final _key = UniqueKey();
  Function onRedirect = () {};

  @override
  void initState() {
    super.initState();
    userFlowUrl = widget.url;
    redirectUrl = widget.redirectUrl;
    redirectRoute = widget.redirectRoute;
    onRedirect = widget.onRedirect ?? () {};
    //Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
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
              if (response.path.contains(redirectUrl) &&
                  (url.contains("access_token") || url.contains("id_token"))) {
                SecureStorage.storeToken(
                  'idToken',
                  'Bearer ${url.split("id_token=")[1]}',
                );

                //Navigate to the redirect route screen
                if (!mounted) return;
                //call redirect function
                onRedirect(context);
              }
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
