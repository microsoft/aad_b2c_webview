import 'package:flutter/material.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

onRedirect(BuildContext context) {
  Navigator.pushNamed(context, '/');
}

class MyApp extends StatelessWidget {
  static String clientId = dotenv.env['CLIENT_ID'] ?? '';
  static String redirectUrl = dotenv.env['REDIRECT_URL'] ?? '';
  static String authFlowUrl = dotenv.env['SIGNUP_SIGNIIN_USER_FLOW_URL'] ?? '';

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

        '/': (context) => ADB2CEmbedWebView(
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
