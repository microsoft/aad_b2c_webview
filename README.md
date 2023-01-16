Azure AD B2C Embedded Webview
============================

Azure AD B2C Embedded Webview is a very simple Flutter package that demonstrates how to use the embedded web view to sign in users with Azure AD B2C.
Currently, using Flutter packages - [appAuth](https://pub.dev/packages/flutter_appauth) and [flutter_azure_b2c](https://pub.dev/packages/flutter_azure_b2c) redirects to browser and doesn't provide in-app experience.

This package embeds the web view of the user flow endpoint using [flutter_appview](https://pub.dev/packages/webview_flutter) and redirects the user as per onRedirect callback method.

## Features

Embedded web view for Azure AD B2C for providing in-app experience
Redirects to the route specified in redirectRoute after successful sign in
Successfully secures the id token or access token in the app using flutter secure storage
Navigates to screen in app after successful sign in

## Getting started
To use the package in your Flutter app, add the following code to your main.dart file:
```yaml
dependencies:
  aad_b2c_webview: ^0.0.1
```

## Usage

Example added in aad-b2c-webview/aad_b2c folder

```dart
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
        url: '<user_flow_endpoint>',
        redirectUrl: '<redirect_uri_of_user_flow>',
        redirectRoute: '<route_to_redirect_to_after_sign_in>',
        onRedirect: onRedirect,
      ),
    },
  );
}
```
