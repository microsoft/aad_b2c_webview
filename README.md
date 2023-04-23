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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? jwtToken;
  String? refreshToken;

  @override
  Widget build(BuildContext context) {
    const aadB2CClientID = "<clientId>";
    const aadB2CRedirectURL = "<azure_active_directory_url_redirect>";
    const aadB2CUserFlowName = "B2C_<name_of_userflow>";
    const aadB2CScopes = ['openid', 'offline_access'];
    const aadB2CUserAuthFlow =
        "https://<tenant-name>.b2clogin.com/<tenant-name>.onmicrosoft.com"; // https://login.microsoftonline.com/<azureTenantId>/oauth2/v2.0/token/
    const aadB2TenantName = "<tenant-name>";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Login flow
            AADLoginButton(
              userFlowUrl: aadB2CUserAuthFlow,
              clientId: aadB2CClientID,
              userFlowName: aadB2CUserFlowName,
              redirectUrl: aadB2CRedirectURL,
              context: context,
              scopes: aadB2CScopes,
              onAnyTokenRetrieved: (Token anyToken) {},
              onIDToken: (Token token) {
                jwtToken = token.value;
              },
              onAccessToken: (Token token) {},
              onRefreshToken: (Token token) {
                refreshToken = token.value;
              },
              onRedirect: (context) => {},
            ),

            /// Refresh token
            TextButton(
              onPressed: () async {
                if (refreshToken != null) {
                  AzureTokenResponse? response =
                      await ClientAuthentication.refreshTokens(
                    refreshToken: refreshToken!,
                    tenant: aadB2TenantName,
                    policy: aadB2CUserAuthFlow,
                    clientId: aadB2CClientID,
                  );
                  if (response != null) {
                    refreshToken = response.refreshToken;
                    jwtToken = response.idToken;
                  }
                }
              },
              child: const Text("Refresh my token"),
            )
          ],
        ),
      ),
    );
  }
}

```

### Custom Sign in

Simply call page direct or use custom build sign in button to call webview page

```dart
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const aadB2CClientID = "<clientId>";
    const aadB2CRedirectURL = "<azure_active_directory_url_redirect>";
    const aadB2CUserFlowName = "B2C_<name_of_userflow>";
    const aadB2CScopes = ['openid', 'offline_access'];
    const aadB2CUserAuthFlow =
        "https://<tenant-name>.b2clogin.com/<tenant-name>.onmicrosoft.com"; // https://login.microsoftonline.com/<azureTenantId>/oauth2/v2.0/token/
    const aadB2TenantName = "<tenant-name>";

    return Scaffold(
      body: ADB2CEmbedWebView(
        tenantBaseUrl: aadB2CUserAuthFlow,
        userFlowName: aadB2CUserFlowName,
        clientId: aadB2CClientID,
        redirectUrl: aadB2CRedirectURL,
        scopes: aadB2CScopes,
        onAnyTokenRetrieved: (Token anyToken) {},
        onIDToken: (Token token) {},
        onAccessToken: (Token token) {},
        onRefreshToken: (Token token) {},
      ),
    );
  }
}
```
