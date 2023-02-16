import 'package:flutter/material.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

void main() {
  runApp(const MyApp());
}

onRedirect(BuildContext context) {
  Navigator.pushNamed(context, '/');
}

class MyApp extends StatelessWidget {
  static const String authFlowUrl =
      'https://dinkotestorg.b2clogin.com/dinkotestorg.onmicrosoft.com/B2C_1_login-register/oauth2/v2.0/authorize';
  static const String redirectUrl = 'https://jwt.ms';
  static const String clientId = '87a90db8-3f52-4546-b719-43f232a4c1f8';

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
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF8A8A8A),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the Create Account widget.

        '/': (context) => const ADB2CEmbedWebView(
              url: MyApp.authFlowUrl,
              redirectUrl: MyApp.redirectUrl,
              appRedirectRoute: '/',
              clientId: MyApp.clientId,
              onRedirect: onRedirect,
            ),
      },
    );
  }
}
