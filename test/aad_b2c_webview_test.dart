import 'package:aad_b2c_webview/src/aad_b2c_webview.dart';
import 'package:aad_b2c_webview/src/login_azure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  ADB2CEmbedWebView embedWebView;
  MockBuildContext mockContext;

  test('testing embed webview', () {
    embedWebView = ADB2CEmbedWebView(
      userFlowUrl: '',
      userFlowName: '',
      clientId: '',
      redirectUrl: '',
      onRedirect: (BuildContext context) {},
      scopes: const ['openId'],
    );
    mockContext = MockBuildContext();
    var mockEmbedWebViewstate = embedWebView.createState().build(mockContext);

    expect(mockEmbedWebViewstate, isNotNull);
  });

  testWidgets('login button works', (tester) async {
    mockContext = MockBuildContext();
    await tester.pumpWidget(
      MaterialApp(
        home: AADLoginButton(
          userFlowUrl:
              'https://icecatalyst.b2clogin.com/icecatalyst.onmicrosoft.com/oauth2/v2.0/authorize',
          userFlowName: 'B2C_1_signinup',
          clientId: 'eeadda00-56a9-4345-967c-07e3aa8b1cee',
          redirectUrl: 'https://jwt.ms',
          context: null,
          onRedirect: (BuildContext context) {},
          scopes: const ['openid', 'https://graph.microsoft.com/User.Read'],
        ),
      ),
    );

    expect(find.byType(GestureDetector), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    // // Rebuild the widget after the state has changed.
    // await tester.pump();
    //
    // expect(mockEmbedWebViewstate, isNotNull);
  });
}
