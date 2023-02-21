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
        url: '',
        clientId: '',
        redirectUrl: '',
        appRedirectRoute: '',
        onRedirect: (BuildContext context) {});
    mockContext = MockBuildContext();
    var mockEmbedWebViewstate = embedWebView.createState().build(mockContext);

    expect(mockEmbedWebViewstate, isNotNull);
  });

  testWidgets('login button works', (tester) async {
    mockContext = MockBuildContext();
    await tester.pumpWidget(
      MaterialApp(
        home: AADLoginButton(
            url: '',
            clientId: '',
            redirectUrl: '',
            appRedirectRoute: '',
            context: null,
            onRedirect: (BuildContext context) {}),
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
