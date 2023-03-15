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
  aad_b2c_webview: <latest_version>
```

## Usage

### Simple In-built Sign In Button

To add the easy to use sign in with microsoft button simply use the AADLoginButton widget 
and a beautiful sign in button appears as shown below.

```dart
import 'package:aad_b2c_webview/src/login_azure.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AADLoginButton(
        userFlowUrl:
        '<https://<tenant_id>.b2clogin.com/<tenant_id>.onmicrosoft.com/oauth2/v2.0/authorize>',
        clientId: '<client-id>',
        userFlowName: 'B2C_<Name_of_UserFlow>',
        redirectUrl: '<redirect_url>',
        onRedirect: (BuildContext context){
          ///Handle navigation to whatever page you choose
          ///Use the build context for navigation
        },
        context: context,
        onAccessToken: (value) {
          ///Store or use access token from here
        },
        onIDToken: (value) {
          ///Store or use ID token from here
        },
        onRefreshToken: (value) {
          ///Store or use refresh token from here
        },
      ),
    );
  }
}
```

### Custom Sign in

Simply call page direct or use custom build sign in button to call webview page

```dart
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ADB2CEmbedWebView(
        userFlowUrl:
        '<https://<tenant_id>.b2clogin.com/<tenant_id>.onmicrosoft.com/oauth2/v2.0/authorize>',
        clientId: '<client-id>',
        userFlowName: 'B2C_<Name_of_UserFlow>',
        redirectUrl: '<redirect_url>',
        onRedirect: (BuildContext context){
          ///Handle navigation to whatever page you choose
          ///Use the build context for navigation
        },
        context: context,
        onAccessToken: (value) {
          ///Store or use access token from here
        },
        onIDToken: (value) {
          ///Store or use ID token from here
        },
        onRefreshToken: (value) {
          ///Store or use refresh token from here
        },
      ),
    );
  }
}
```
