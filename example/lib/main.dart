import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:example/b2c_with_multiple_customizations.dart';
import 'package:example/b2c_with_webview.dart';
import 'package:example/button_refresh_token.dart';
import 'package:flutter/material.dart';

import 'b2c_with_button.dart';
import 'b2c_with_simple_customization.dart';
import 'b2c_with_dynamic_customization.dart';
import 'widgets/button_widget.dart';

/// Global keys
/// It is recommended to use .env to save your keys.
///
const aadB2CClientID = "<app-id>";
const aadB2CRedirectURL = "https://myurl.com/myappname";
const aadB2CUserFlowName = "B2C_1_APPNAME_Signin";
const aadB2CScopes = ['openid', 'offline_access'];
const aadB2TenantName = "<tenantName>";
const aadB2CUserAuthFlow =
    "https://$aadB2TenantName.b2clogin.com/$aadB2TenantName.onmicrosoft.com";

B2CWebViewParams params = B2CWebViewParams(
  responseType: Constants.defaultResponseType,
  tenantBaseUrl: aadB2CUserAuthFlow,
  clientId: aadB2CClientID,
  userFlowName: aadB2CUserFlowName,
  redirectUrl: aadB2CRedirectURL,
  scopes: aadB2CScopes,
  containsChallenge: true,
  isLoginFlow: true,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBuilder());
}

class AppBuilder extends StatelessWidget {
  const AppBuilder({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Azure',
      theme: ThemeData(
        primaryColor: const Color(0xFF2F56D2),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontFamily: 'UberMove',
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF8A8A8A),
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: 'UberMoveText',
          ),
          displayMedium: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'UberMove',
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonWidget(
              onTap: _goToLoginButton,
              title: 'B2C with Button',
              icon: Icons.touch_app_outlined,
            ),
            const SizedBox(height: 16.0),

            ButtonWidget(
              onTap: _goToLoginWebView,
              title: 'B2C with WebView',
              icon: Icons.web_asset,
            ),
            const SizedBox(height: 16.0),

            ButtonWidget(
              onTap: _goToLoginCustomization,
              title: 'Simple Customization',
              icon: Icons.code,
            ),
            const SizedBox(height: 16.0),

            ButtonWidget(
              onTap: _goToLoginMFACustomization,
              title: 'Multiple Customizations',
              icon: Icons.dashboard_customize_outlined,
            ),
            const SizedBox(height: 16.0),

            ButtonWidget(
              onTap: _goToLoginDynamic,
              title: 'Dynamic Customization',
              icon: Icons.precision_manufacturing_outlined,
            ),
            const SizedBox(height: 16.0),

            ButtonWidget(
              onTap: _refreshToken,
              title: 'Refresh token',
              icon: Icons.refresh_outlined,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void _goToLoginButton() => _navigator(
        B2CWithButton(params: params),
      );

  void _goToLoginWebView() => _navigator(
        B2CWithWebView(params: params),
      );

  void _goToLoginCustomization() => _navigator(
        B2CWithSimpleCustomization(params: params),
      );

  void _goToLoginMFACustomization() => _navigator(
        B2CWithMultipleCustomizations(params: params),
      );

  void _goToLoginDynamic() => _navigator(
        B2CWithDynamicCustomization(params: params),
      );

  void _navigator(Widget page) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  void _refreshToken() => _navigator(
        const ButtonRefreshToken(),
      );
}
