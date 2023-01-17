import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  ADB2CEmbedWebView embedWebView;
  MockBuildContext mockContext;

  test('testing embed weview', () {
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
}
