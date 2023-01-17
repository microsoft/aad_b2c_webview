import 'package:flutter/material.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

void main() {
  runApp(const MyApp());
}

onRedirect(BuildContext context) {
  Navigator.pushNamed(context, '/');
}

class MyApp extends StatelessWidget {
  static const authFlowUrl = '<user_flow_endpoint>';
  static const redirectUrl = '<redirect_url>';

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF2F56D2),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontFamily: 'UberMove',
          ),
          bodyText1: TextStyle(
            color: Color(0xFF8A8A8A),
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: 'UberMoveText',
          ),
          headline2: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'UberMove',
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the Create Account widget.

        '/': (context) => const ADB2CEmbedWebView(
              url: authFlowUrl,
              redirectUrl: redirectUrl,
              appRedirectRoute: '/',
              clientId: '<client_id>',
              onRedirect: onRedirect,
            ),
      },
    );
  }
}
