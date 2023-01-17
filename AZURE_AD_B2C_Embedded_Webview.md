## Azure AD B2C Integration : In App Experience With Embedded Web view (Flutter) and Azure AD B2C User flows

Azure Active Directory B2C (AAD B2C) is a cloud-based identity and access management service that enables you to customize and control the user sign-up, sign-in, and profile management process.
This article will walk you through several ways on how we can integrate Azure AD B2C's user login workflow within mobile app development using Flutter.

It will also demonstrate how to secure the token in the app using [flutter-secure-storage](https://pub.dev/packages/flutter_secure_storage) and how to navigate to a screen inside the app after successful sign in.

Consider the below scenario:-

You have a mobile app that needs to authenticate users using Azure AD B2C. You want to provide a seamless experience to your users by not redirecting them to a browser for authentication. You want to provide a native experience to your users for registration and authentication.

## Below is an example of list of requirements

* User should be able to register and login using Azure AD B2C
* User should be able to login using social providers like Google, Facebook, Microsoft, etc.
* User should be able to login using local accounts like email and password
* User should be able to login using phone number
* User should be able to login using OTP
* User should be able to login using biometrics like fingerprint, face id, etc.

## Steps Involved

* Integrate Azure AD B2C's login workflow into it.
* Use the same login screen for both Android and iOS
* Retrieve the user's access token and use it to call an API.
* Navigate to a different screen/route after successful login.

We can do this by using the Azure AD B2C's default view, which is a web view that redirects to the Azure AD B2C's login page in a browser of your choice, and then redirects back to the app after the user has logged in.

There are several Flutter packages available for this, one of them being [flutter_appauth](https://pub.dev/packages/flutter_appauth)
This package is a wrapper around the [AppAuth](https://appauth.io/) library, which is a library that allows you to authenticate users using OAuth 2.0 and OpenID Connect.
The code for integration, looks like something like this:

```dart
import 'package:flutter_appauth/flutter_appauth.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();

final AuthorizationTokenResponse result = await appAuth.authorizeAndExchangeCode(
  AuthorizationTokenRequest(
    '<client_id>',
    '<redirect_url>',
    discoveryUrl: '<discovery_url>',
    scopes: ['<scopes>'],
  ),
);

final idToken = result.idToken;
var accessToken = result.accessToken;
```
Here,
* `<client_id>` is the client ID of the app registration in Azure AD B2C.
* `<redirect_url>` is the redirect URL of the app registration in Azure AD B2C.
* `<discovery_url>` is the discovery URL of the app registration in Azure AD B2C.
* `<scopes>` is the scope of the app registration in Azure AD B2C.
* `result.idToken` is the ID token of the user.
* `result.accessToken` is the access token of the user.

The entire code snippet looks something like below:-

```dart
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class LoginScreen extends ConsumerWidget {
  
  @override
  build(BuildContext context, ScopedReader watch) {
    final appAuth = FlutterAppAuth();
    final authState = watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Login'),
          onPressed: () async {
            try {
              final AuthorizationTokenResponse result =
                  await appAuth.authorizeAndExchangeCode(
                AuthorizationTokenRequest(
                  '<client_id>',
                  '<redirect_url>',
                  discoveryUrl: '<discovery_url>',
                  scopes: ['<scopes>'],
                ),
              );

              final idToken = result.idToken;
              var accessToken = result.accessToken;
              authState.state = idToken;
            } catch (e) {
              print(e);
            }
          },
        ),
      ),
    );
  } 
}
```

When the onPressed method is clicked, it calls the authorizeAndExchangeCode method of the FlutterAppAuth class, which redirects the user to the browser, and then back to the app after the user has logged in.

This approach has few drawbacks:
* The user is redirected to the browser, and then back to the app, which is not a great user experience.
* The user's token is stored in the browser's cache, which is not secure.
* For a successful redirection to the app, we have to define a appAuthRedirectScheme in build.gradle file. For example: redirect URL becomes com.example.authapp://oauthredirect where "oauthredirect" is the callback required by app auth.

Now, let's see how we can achieve the same using Azure AD B2C's embedded web view.

Embedded Web View provides us with a web view that is embedded within the app, and it does not redirect the user to the browser. This is a great user experience, and it is also more secure than the default view.

Just imagine, once you have UI customization on top of Azure AD B2C and you use this approach , you can have a seamless experience for your users.
Everything from multi factor authentication, OTP verification will happen within the app . This gives the user a great experience and at the same time, everything is happening securely within Azure AD.
You can also use the same login screen for both Android and iOS.

Let's see how we can achieve this.

First, we need to create a new app registration in Azure AD B2C.
We need to add a new redirect URI to the app registration. The redirect URI should be in the one of the following format:

* Native mobile: `<app_scheme>://<host>/<path>`.
  For example, if the app scheme is com.example.authapp, the redirect URI will be com.example.authapp://oauthredirect.

* Generic redirection: `https:// or http://`.
  For example, if the redirect URI is https://example.com, the redirect URI will be https://example.com.

Now, we can use two packages for achieving embedded web view experience in Flutter.

These are [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) and [flutter_webview_plugin](https://pub.dev/packages/flutter_webview_plugin).

### A simple code snippet for embedded web view using flutter_inappwebview looks like this:-

```dart
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Login'),
    ),
    body: InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse('<login_url>')),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
        ),
      ),
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
      onLoadStart: (InAppWebViewController controller, Uri? url) {
        if (url.toString().startsWith('<redirect_url>')) {
          Navigator.of(context).pop();
        }
      },
    ),
  );
}
```

### A simple code snippet for embedded web view using flutter_webview_plugin looks like this:-

```dart
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

@override
Widget build(BuildContext context) {
  return WebviewScaffold(
      url: '<user_flow_run_endpoint>',
      appBar: AppBar(
      title: Text('Login'),
  ),
  withJavascript: true,
  withLocalStorage: true,
  withZoom: false,
  hidden: true,
  initialChild: Container(
  color: Colors.white,
  child: const Center(
  child: Text('Loading...'),
  ),
  ),
  onWebViewCreated: (WebViewController webViewController) {
  _controller.complete(webViewController);
  onPageFinished: (String url) {
  if (url.toString().startsWith('<redirect_url>')) {
  Navigator.pushReplacementNamed(context, '/home');
  }
  },
  );
  }
```
## Benefits of using this approach are below:-

* The user does not have to be redirected to the browser. This is a great user experience.
* The user's token is stored in the app's cache (example: one can store in secure storage using flutter-secure-storage package), which is more secure.
* The web view can be customized to match the app's theme. It can be added with Stack, Positioned, Scaffold and constructed as per app's requirements.
* One can retrieve the user's token on successful redirection using onPageFinished method and navigate to any route/screen within the app.

We have also developed a very easy to use Flutter package [aad_b2c_webview](https://pub.dev/packages/aad_b2c_webview) which can be used to achieve this approach.

An example is provided below:

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

      '/': (context) =>
      const ADB2CEmbedWebView(
        url: '<user_flow_endpoint>',
        clientId: '<client_id_of_user_flow>',
        redirectUrl: '<redirect_uri_of_user_flow>',
        appRedirectRoute: '<route_to_redirect_to_after_sign_in>',
        onRedirect: onRedirect,
      ),
    },
  );
}
```
## Parameters Used In ADB2CEmbedWebView

* url: This is the user flow/policy endpoint

* clientId: This is client id of the application used for redirection within user flow

* redirectUrl: This is redirect Url of the application used for redirection within user flow

* appRedirectRoute: This is the in-app route to navigate to, after successful sign in on redirect

* onRedirect: This is the callback method to handle the redirect url. This method is called when the redirect url is hit. This method should return the route to navigate to after successful sign in.

## Conclusion
Hope this article helps you understand how to achieve embedded web view experience in Flutter. This approach is very easy to implement and gives a great user experience.
We are now trying to achieve the same experience in React Native. We will share the article soon.


## References
[Azure AD B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/overview)
[Flutter](https://flutter.dev/)
