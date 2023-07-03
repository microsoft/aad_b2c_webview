import 'package:aad_b2c_webview/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  ADB2CEmbedWebView embedWebView;
  MockBuildContext mockContext;

  test('testing embed webview', () {
    embedWebView = ADB2CEmbedWebView(
      onAccessToken: (_) {},
      onIDToken: (_) {},
      onRefreshToken: (_) {},
      tenantBaseUrl: '',
      userFlowName: '',
      clientId: '',
      redirectUrl: '',
      onRedirect: (BuildContext context) {},
      scopes: const ['openId'],
      optionalParameters: [OptionalParam(key: "key", value: "value")],
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
          onAccessToken: (_) {},
          onIDToken: (_) {},
          onRefreshToken: (_) {},
          userFlowUrl: '',
          userFlowName: '',
          clientId: '',
          redirectUrl: '',
          context: null,
          onRedirect: (BuildContext context) {},
          scopes: const ['openId'],
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
